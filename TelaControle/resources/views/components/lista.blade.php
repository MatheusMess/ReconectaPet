@php
    $urlDetalhes = url('d' . trim(request()->path(), '/'));
@endphp

@if(!$usuario)
    {{-- Seção para animais --}}
    @forelse($informacoes as $animal)
        <div class="col-md-6 col-lg-4 mb-4">
            <div id="item" class="card h-100">
                <div class="img">
                    {{-- CORREÇÃO COMPLETA para imagens --}}
                    @php
                        $images = $animal->imagens ?? [];
                        $primeiraImagem = asset('images/animais/noimg.jpg');
                        
                        // DEBUG: Verificar o que vem nas imagens
                        $tipoImagens = gettype($images);
                        
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
                            $decoded = json_decode($images, true);
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
                    
                    {{-- DEBUG: Mostrar info da imagem --}}
                    <div style="display: none;">
                        Imagens tipo: {{ $tipoImagens }}<br>
                        Imagens valor: {{ json_encode($images) }}<br>
                        Imagem final: {{ $primeiraImagem }}
                    </div>
                    
                    <img src="{{ $primeiraImagem }}" class="card-img-top" alt="Imagem do animal" 
                         onerror="this.src='{{ asset('images/animais/noimg.jpg') }}'">
                </div>
                <div class="card-body">
                    <h5 class="card-title">
                        @if(is_string($animal->nome ?? null))
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
                                {{ $animal->situacao }}
                            @else
                                Não informada
                            @endif
                        </li>
                    </ul>

                    <div id="btns" class="d-flex justify-content-center">
                        {{-- APENAS BOTÃO VER DETALHES --}}
                        <form action="{{$urlDetalhes}}" method="POST" style="display: inline;">
                            @csrf
                            <input type="hidden" name="id" value="{{ $animal->id }}">
                            <button id="det" type="submit" class="btn btn-primary">Ver Detalhes</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    @empty
        <div class="col-12 text-center mt-5">
            <h5><b>Nenhum registro encontrado</b></h5>
        </div>
    @endforelse
@else
    {{-- Seção para usuários --}}
    @forelse($informacoes as $usuario)
        <div class="col-md-6 col-lg-4 mb-4">
            <div id="item" class="card h-100">
                <div class="img">
                    <img src="{{ file_exists(public_path('images/usuarios/'.$usuario->id.'.png')) ? asset('images/usuarios/'.$usuario->id.'.png') : asset('images/usuarios/1.png') }}" class="card-img-top" alt="Imagem do usuário">
                </div>
                <div class="card-body">
                    <h5 class="card-title">{{ $usuario->nome }}</h5>
                    <ul class="list-unstyled mb-3">
                        <li><strong>Email:</strong> {{ $usuario->email }}</li>
                        <li><strong>Telefone:</strong> {{ $usuario->tel ?? 'Não informado' }}</li>
                        <li><strong>CPF:</strong> {{ $usuario->cpf ?? 'Não informado' }}</li>
                        <li><strong>Tipo:</strong> {{ $usuario->adm ? 'Administrador' : 'Usuário' }}</li>
                    </ul>
                    <div id="btns" class="d-flex justify-content-center">
                        {{-- APENAS BOTÃO VER DETALHES --}}
                        <form action="{{$urlDetalhes}}" method="POST" style="display: inline;">
                            @csrf
                            <input type="hidden" name="id" value="{{ $usuario->id }}">
                            <button id="det" type="submit" class="btn btn-primary">Ver Detalhes</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    @empty
        <div class="col-12 text-center mt-5">
            <h5><b>Nenhum registro encontrado</b></h5>
        </div>
    @endforelse
@endif

@include('components.css.CSSlista')