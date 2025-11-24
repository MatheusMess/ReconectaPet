@props(['animais' => [], 'usuario' => false, 'showActions' => false])

@php
    // VERIFICAR SE JÁ FOI RENDERIZADO para evitar duplicação
    if (isset($jaRenderizado) && $jaRenderizado) {
        return;
    }
    $jaRenderizado = true;
@endphp

@if(!$usuario)
    {{-- Seção para animais --}}
    @forelse($animais as $animal)
        <div class="col-md-6 col-lg-4 mb-4">
            <div id="item" class="card h-100">
                <div class="img">
                    {{-- CORREÇÃO COMPLETA para imagens --}}
                    @php
                        $images = $animal->imagens ?? [];
                        $primeiraImagem = asset('images/animais/noimg.jpg');
                        
                        // CASO 1: Já é uma string URL válida
                        if (is_string($images) && !empty($images) && filter_var($images, FILTER_VALIDATE_URL)) {
                            $primeiraImagem = $images;
                        }
                        // CASO 2: É um array
                        elseif (is_array($images)) {
                            if (count($images) > 0) {
                                $primeiraItem = $images[0];
                                // Se o primeiro item é string URL válida
                                if (is_string($primeiraItem) && filter_var($primeiraItem, FILTER_VALIDATE_URL)) {
                                    $primeiraImagem = $primeiraItem;
                                }
                                // Se é um caminho local
                                elseif (is_string($primeiraItem)) {
                                    $primeiraImagem = asset($primeiraItem);
                                }
                            }
                        }
                        // CASO 3: É JSON string
                        elseif (is_string($images) && !empty($images)) {
                            $decoded = json.decode($images, true);
                            if (is_array($decoded) && count($decoded) > 0) {
                                $primeiraItem = $decoded[0];
                                if (is_string($primeiraItem)) {
                                    $primeiraImagem = filter_var($primeiraItem, FILTER_VALIDATE_URL) 
                                        ? $primeiraItem 
                                        : asset($primeiraItem);
                                }
                            } else {
                                // Se não é JSON válido, tenta usar como caminho direto
                                $primeiraImagem = asset($images);
                            }
                        }
                        
                        // Garantir que é uma URL válida
                        if (!filter_var($primeiraImagem, FILTER_VALIDATE_URL)) {
                            $primeiraImagem = asset('images/animais/noimg.jpg');
                        }
                    @endphp
                    
                    <img src="{{ $primeiraImagem }}" class="card-img-top" alt="Imagem do animal" 
                         onerror="this.src='{{ asset('images/animais/noimg.jpg') }}'">
                </div>
                <div class="card-body">
                    <h5 class="card-title">
                        @if(is_string($animal->nome ?? null) && trim($animal->nome) !== '')
                            {{ $animal->nome }}
                        @else
                            (Sem coleira)
                        @endif
                    </h5>
                    <ul class="list-unstyled mb-3">
                        <li><strong>Animal:</strong> 
                            @if(is_string($animal->especie ?? null))
                                {{ $animal->especie }}
                            @else
                                Não informado
                            @endif
                        </li>
                        <li><strong>Raça:</strong> 
                            @if(is_string($animal->raca ?? null))
                                {{ $animal->raca }}
                            @else
                                Não informada
                            @endif
                        </li>
                        <li><strong>Cor:</strong> 
                            @if(is_string($animal->cor ?? null))
                                {{ $animal->cor }}
                            @else
                                Não informada
                            @endif
                        </li>
                        <li><strong>Sexo:</strong> 
                            @if(is_string($animal->sexo ?? null))
                                {{ $animal->sexo }}
                            @else
                                Não informado
                            @endif
                        </li>
                        <li><strong>Situação:</strong> 
                            @if(is_string($animal->situacao ?? null))
                                {{ ucfirst($animal->situacao) }}
                            @else
                                Não informada
                            @endif
                        </li>
                        <li><strong>Status:</strong> 
                            @if(is_string($animal->status ?? null))
                                {{ ucfirst($animal->status) }}
                            @else
                                Pendente
                            @endif
                        </li>
                    </ul>

                    <div id="btns" class="d-flex flex-column gap-2">
                        {{-- BOTÕES DE AÇÃO (apenas se showActions for true) --}}
                        @if($showActions)
                            <div class="d-flex gap-2 w-100">
                                <form action="{{ route('animal.aceitar') }}" method="POST" class="flex-fill">
                                    @csrf
                                    <input type="hidden" name="id" value="{{ $animal->id }}">
                                    <button type="submit" class="btn btn-success w-100">Aceitar</button>
                                </form>
                                <form action="{{ route('animal.recusar') }}" method="POST" class="flex-fill">
                                    @csrf
                                    <input type="hidden" name="id" value="{{ $animal->id }}">
                                    <button type="submit" class="btn btn-danger w-100">Recusar</button>
                                </form>
                            </div>
                        @endif
                    </div>
                </div>
            </div>
        </div>
    @empty
        <div class="col-12 text-center mt-5">
            <h5><b>Nenhum animal encontrado</b></h5>
        </div>
    @endforelse
@else
    {{-- Seção para usuários --}}
    @forelse($animais as $usuarioItem)
        <div class="col-md-6 col-lg-4 mb-4">
            <div id="item" class="card h-100">
                <div class="img">
                    <img src="{{ file_exists(public_path('images/usuarios/'.$usuarioItem->id.'.png')) ? asset('images/usuarios/'.$usuarioItem->id.'.png') : asset('images/usuarios/1.png') }}" 
                         class="card-img-top" alt="Imagem do usuário"
                         onerror="this.src='{{ asset('images/usuarios/1.png') }}'">
                </div>
                <div class="card-body">
                    <h5 class="card-title">{{ $usuarioItem->nome }}</h5>
                    <ul class="list-unstyled mb-3">
                        <li><strong>Email:</strong> {{ $usuarioItem->email }}</li>
                        <li><strong>Telefone:</strong> {{ $usuarioItem->tel ?? 'Não informado' }}</li>
                        <li><strong>CPF:</strong> {{ $usuarioItem->cpf ?? 'Não informado' }}</li>
                        <li><strong>Tipo:</strong> {{ $usuarioItem->adm ? 'Administrador' : 'Usuário' }}</li>
                        <li><strong>Status:</strong> 
                            @if($usuarioItem->banido)
                                <span class="text-danger">🚫 Banido</span>
                            @else
                                <span class="text-success">✅ Ativo</span>
                            @endif
                        </li>
                    </ul>
                    <div id="btns" class="d-flex flex-column gap-2">
                        {{-- BOTÕES DE AÇÃO (apenas se showActions for true) --}}
                        @if($showActions)
                            {{-- Botões de banimento --}}
                            @if(!$usuarioItem->banido)
                                <form action="{{ route('usuario.banir') }}" method="POST" class="w-100">
                                    @csrf
                                    <input type="hidden" name="id" value="{{ $usuarioItem->id }}">
                                    <button type="submit" class="btn btn-danger w-100">🚫 Banir</button>
                                </form>
                            @else
                                <form action="{{ route('usuario.desbanir') }}" method="POST" class="w-100">
                                    @csrf
                                    <input type="hidden" name="id" value="{{ $usuarioItem->id }}">
                                    <button type="submit" class="btn btn-success w-100">✅ Desbanir</button>
                                </form>
                            @endif

                            {{-- Botões de admin --}}
                            @if(!$usuarioItem->adm)
                                <form action="{{ route('usuario.tornarAdmin') }}" method="POST" class="w-100">
                                    @csrf
                                    <input type="hidden" name="id" value="{{ $usuarioItem->id }}">
                                    <button type="submit" class="btn btn-info w-100">👑 Tornar Admin</button>
                                </form>
                            @else
                                <form action="{{ route('usuario.removerAdmin') }}" method="POST" class="w-100">
                                    @csrf
                                    <input type="hidden" name="id" value="{{ $usuarioItem->id }}">
                                    <button type="submit" class="btn btn-secondary w-100">👤 Remover Admin</button>
                                </form>
                            @endif
                        @endif
                    </div>
                </div>
            </div>
        </div>
    @empty
        <div class="col-12 text-center mt-5">
            <h5><b>Nenhum usuário encontrado</b></h5>
        </div>
    @endforelse
@endif

@include('components.css.CSSlista')