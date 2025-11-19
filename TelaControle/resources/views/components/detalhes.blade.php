@php
    // PROTEÇÃO ADICIONADA: valores padrão
    $caso = $caso ?? 1;
    $animal = $animal ?? null;
    
    if (!$animal) {
        echo '<div class="error">Animal não encontrado</div>';
        return;
    }
@endphp

@if($caso >= 10)
@php
    // Determina se este componente está mostrando "antes" ou "depois"
    $isBefore = in_array($caso, [10, 12], true);
    $isAfter  = in_array($caso, [11, 13], true);

    // Verifica se há edição pendente
    $temEdicao = isset($animal->editado);
    $editado = $temEdicao ? $animal->editado : null;

    // Função para obter valor a ser exibido
    $display = function($campo) use ($isBefore, $animal, $editado, $temEdicao) {
        if ($isBefore || !$temEdicao) {
            return $animal->$campo ?? ' ';
        }
        
        // Para "depois", usa o valor editado se existir
        $campoEditado = 'n_' . $campo;
        return $editado->$campoEditado ?? $animal->$campo ?? ' ';
    };

    // Função para verificar se campo foi alterado
    $isChanged = function($campo) use ($temEdicao, $animal, $editado) {
        if (!$temEdicao) return false;
        
        $campoEditado = 'n_' . $campo;
        $valorOriginal = $animal->$campo ?? null;
        $valorEditado = $editado->$campoEditado ?? null;
        
        return $valorEditado && $valorEditado !== $valorOriginal;
    };

    // Função para obter imagens - CORRIGIDA para usar array
    $getImages = function() use ($isBefore, $animal, $editado, $temEdicao) {
        if ($isBefore || !$temEdicao) {
            return $animal->imagens ?? [];
        }
        
        return $editado->n_imagens ?? $animal->imagens ?? [];
    };

    // Função para obter src da imagem - CORRIGIDA
    $imageSrc = function($imgIndex) use ($getImages) {
        $images = $getImages();
        return $images[$imgIndex - 1] ?? asset('images/animais/noimg.jpg');
    };
@endphp

<div class="pai">
    <div id="img" class="card">
        @if($caso == 10 || $caso == 11)
            <h2 class="titulo">Perdido</h2>
        @elseif($caso == 12 || $caso == 13)
            <h2 class="titulo">Encontrado</h2>
        @endif

        <div id="imgs">
            @for($i = 1; $i <= 4; $i++)
                @php
                    $src = $imageSrc($i);
                    $changed = $isChanged('imagens');
                    $cls = $changed ? ($isBefore ? 'changed-before' : 'changed-after') : '';
                @endphp
                <div class="img-wrap {{ $cls }}">
                    <img src="{{ $src }}" alt="{{ $display('nome') ?: 'Animal' }}">
                </div>
            @endfor
        </div>

        @php
            $nameChanged = $isChanged('nome');
            $nameClass = $nameChanged ? ($isBefore ? 'changed-before' : 'changed-after') : '';
            $nomeDisplay = $display('nome');
        @endphp

        @if(empty(trim($nomeDisplay)) || $nomeDisplay === ' ')
            <span id="snome" class="center">(Sem coleira)</span>
        @else
            <span id="nome" class="center {{ $nameClass }}">{{ $nomeDisplay }}</span>
        @endif
    </div>

    <div class="div2">
        <div id="detalhes" class="card">
            <ul>
                {{-- CORRIGIDO: usando campos reais do modelo --}}
                @foreach([
                    'especie' => 'Animal', 
                    'raca' => 'Raça', 
                    'porte' => 'Porte', 
                    'sexo' => 'Sexo', 
                    'cor' => 'Cor'
                ] as $campo => $label)
                    @php
                        $changed = $isChanged($campo);
                        $cls = $changed ? ($isBefore ? 'alterado1' : 'alterado2') : '';
                    @endphp
                    <li class="{{ $cls }}"><b>{{ $label }}: </b>{{ $display($campo) }}</li>
                @endforeach

                {{-- CORRIGIDO: usando caracteristicas em vez de aparencia --}}
                <li><b>Características:</b></li>
                @php
                    $changedCaracteristicas = $isChanged('caracteristicas');
                    $clsCaracteristicas = $changedCaracteristicas ? ($isBefore ? 'alterado1' : 'alterado2') : '';
                @endphp
                <p class="{{ $clsCaracteristicas }}">{{ $display('caracteristicas') }}</p>

                {{-- CORRIGIDO: usando descricao em vez de aparencia --}}
                @if($display('descricao'))
                <li><b>Descrição:</b></li>
                @php
                    $changedDescricao = $isChanged('descricao');
                    $clsDescricao = $changedDescricao ? ($isBefore ? 'alterado1' : 'alterado2') : '';
                @endphp
                <p class="{{ $clsDescricao }}">{{ $display('descricao') }}</p>
                @endif

                {{-- Exibição específica por situação -- CORRIGIDA --}}
                @if(in_array($caso, [10, 11]) || ($animal->status === 'perdido' && $caso < 10))
                    @php
                        $changedLocal = $isChanged('ultimo_local_visto');
                        $clsLocal = $changedLocal ? ($isBefore ? 'alterado1' : 'alterado2') : '';
                    @endphp
                    <li><b>Último lugar visto:</b></li>
                    <p class="{{ $clsLocal }}">{{ $display('ultimo_local_visto') }}</p>
                @endif

                @if(in_array($caso, [12, 13]) || ($animal->status === 'encontrado' && $caso < 10))
                    @php
                        $changedLocal = $isChanged('endereco_desaparecimento');
                        $clsLocal = $changedLocal ? ($isBefore ? 'alterado1' : 'alterado2') : '';
                    @endphp
                    <li><b>Local encontrado:</b></li>
                    <p class="{{ $clsLocal }}">{{ $display('endereco_desaparecimento') }}</p>
                @endif

                {{-- Informações de endereço --}}
                @if($display('cidade') || $display('bairro'))
                <li><b>Localização:</b></li>
                <p>
                    @if($display('cidade')){{ $display('cidade') }}@endif
                    @if($display('bairro')), {{ $display('bairro') }}@endif
                    @if($display('rua')), {{ $display('rua') }}@endif
                </p>
                @endif
            </ul>
        </div>

        <div class="botao">
            {{-- Botões para casos de edição (10-13) --}}
            @if($caso == 10)
                <form action="{{ route('animal.aceitar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal->id }}">
                    <button type="submit" id="reso" class="btn-caso">Aceitar</button>
                </form>

                <form action="{{ route('animal.recusar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal->id }}">
                    <button type="submit" id="aban" class="btn-caso">Recusar</button>
                </form>
            @elseif($caso == 11)
                <form action="{{ route('animal.resolver') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal->id }}">
                    <button type="submit" id="reso" class="btn-caso">Resolvido</button>
                </form>

                <form action="{{ route('animal.inativar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal->id }}">
                    <button type="submit" id="aban" class="btn-caso">Inativar</button>
                </form>
            @endif

            {{-- Botões para casos normais (1-7) --}}
            @if($caso == 5 || $caso == 6 || $caso == 7)
                <form action="{{ route('animal.aceitar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal->id }}">
                    <button type="submit" id="reso" class="btn-caso">Aceitar</button>
                </form>

                <form action="{{ route('animal.recusar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal->id }}">
                    <button type="submit" id="aban" class="btn-caso">Recusar</button>
                </form>
            @endif

            @if($caso == 1 || $caso == 2)
                <form action="{{ route('animal.resolver') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal->id }}">
                    <button type="submit" id="reso" class="btn-caso">Resolvido</button>
                </form>

                <form action="{{ route('animal.inativar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal->id }}">
                    <button type="submit" id="aban" class="btn-caso">Inativar</button>
                </form>
            @endif

            @if($caso == 3)
                <form action="{{ route('animal.reativar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal->id }}">
                    <button type="submit" id="aban" class="btn-caso">Reativar Caso</button>
                </form>
            @endif

            @if($caso == 4)
                <form action="{{ route('animal.reativar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal->id }}">
                    <button type="submit" id="reso" class="btn-caso">Reativar Caso</button>
                </form>
            @endif
        </div>
    </div>
</div>

@else
{{-- Visualização normal (casos 1-9) --}}
<div class="pai">
    <div id="img" class="white" style="border-radius: 50px">
        <div id="imgs">
            {{-- CORRIGIDO: usando array de imagens --}}
            @php $images = $animal->imagens ?? []; @endphp
            @for($i = 0; $i < 4; $i++)
                @php $src = $images[$i] ?? asset('images/animais/noimg.jpg'); @endphp
                <img src="{{ $src }}" alt="{{ $animal->especie . ' ' . ($animal->nome ?? '') }}">
            @endfor
        </div>
        
        @if(!$animal->nome || trim($animal->nome) === '')
            <span id="snome">(Sem coleira)</span>
        @else
            <span id="nome"><b>{{ $animal->nome }}</b></span>
        @endif
        
        <ul class="caso">
            {{-- CORRIGIDO: usando status em vez de situacao --}}
            <li><b>Situação: </b>{{ ucfirst($animal->status) }}</li>
            <li id="caso"><b>Caso {{ $animal->situacao }}</b></li>
        </ul>
    </div>

    <div class="div2">
        <div id="detalhes" class="white card-content" style="width: 100%;">
            <ul>
                {{-- CORRIGIDO: campos reais do modelo --}}
                <li><b>Animal: </b>{{ $animal->especie }}</li>
                <li><b>Raça: </b>{{ $animal->raca }}</li>
                <li><b>Porte: </b>{{ $animal->porte }}</li>
                <li><b>Sexo: </b>{{ $animal->sexo }}</li>
                <li><b>Cor: </b>{{ $animal->cor }}</li>
                
                @if($animal->caracteristicas)
                <li><b>Características:</b></li>
                <p>{{ $animal->caracteristicas }}</p>
                @endif

                @if($animal->descricao)
                <li><b>Descrição:</b></li>
                <p>{{ $animal->descricao }}</p>
                @endif

                {{-- CORRIGIDO: usando campos reais de localização --}}
                @if($animal->status === 'perdido' || in_array($caso, [1, 3, 4, 5, 7]))
                    <li><b>Último lugar visto:</b></li>
                    <p>{{ $animal->ultimo_local_visto }}</p>
                @endif

                @if($animal->status === 'encontrado' || in_array($caso, [2, 3, 4, 5, 6]))
                    <li><b>Local encontrado:</b></li>
                    <p>{{ $animal->endereco_desaparecimento }}</p>
                @endif

                {{-- Informações de endereço --}}
                @if($animal->cidade || $animal->bairro)
                <li><b>Localização:</b></li>
                <p>
                    @if($animal->cidade){{ $animal->cidade }}@endif
                    @if($animal->bairro), {{ $animal->bairro }}@endif
                    @if($animal->rua), {{ $animal->rua }}@endif
                </p>
                @endif
            </ul>
        </div>

        <div class="botao">
            {{-- Botões para diferentes casos --}}
            @if(in_array($caso, [5, 6, 7]))
                <form action="{{ route('animal.aceitar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal->id }}">
                    <button type="submit" id="reso" class="btn-caso">Aceitar</button>
                </form>

                <form action="{{ route('animal.recusar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal->id }}">
                    <button type="submit" id="aban" class="btn-caso">Recusar</button>
                </form>
            @endif

            @if(in_array($caso, [1, 2]))
                <form action="{{ route('animal.resolver') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal->id }}">
                    <button type="submit" id="reso" class="btn-caso">Resolvido</button>
                </form>

                <form action="{{ route('animal.inativar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal->id }}">
                    <button type="submit" id="aban" class="btn-caso">Inativar</button>
                </form>
            @endif

            @if($caso == 3)
                <form action="{{ route('animal.reativar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal->id }}">
                    <button type="submit" id="aban" class="btn-caso">Reativar Caso</button>
                </form>
            @endif

            @if($caso == 4)
                <form action="{{ route('animal.reativar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal->id }}">
                    <button type="submit" id="reso" class="btn-caso">Reativar Caso</button>
                </form>
            @endif
        </div>
    </div>
</div>
@endif

@include('components.css.CSSdetalhes')