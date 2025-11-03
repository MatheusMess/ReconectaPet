@if($caso >=10)


@php
    // Determina se este componente está mostrando "antes" ou "depois"
    $isBefore = in_array($caso, [10, 12], true);
    $isAfter  = in_array($caso, [11, 13], true);

    
    $campos = ['tipo','raca','tam','sexo','cor','aparencia','lugarV','lugarE','nome'];
    $imagens = ['imagem1','imagem2','imagem3','imagem4'];

    $nValue = function($key) use ($animal) {
        $k = 'N'.$key;
        $v = $animal[$k] ?? null;
        if (is_null($v) || trim((string)$v) === '') {
            return ' ';
        }
        return $v;
    };

    $origValue = function($key) use ($animal) {
        $v = $animal[$key] ?? null;
        return is_null($v) ? ' ' : $v;
    };

    $display = function($key) use ($isBefore, $origValue, $nValue) {
        if ($isBefore) {
            return $origValue($key);
        }
        $nv = $nValue($key);
        return trim((string)$nv) === ' ' ? $origValue($key) : $nv;
    };

    $isChanged = function($key) use ($origValue, $nValue) {
        $orig = (string)$origValue($key);
        $nv   = (string)$nValue($key);
        return trim($nv) !== '' && trim($nv) !== ' ' && $nv !== $orig;
    };

    $imageSrc = function($imgKey) use ($isBefore, $origValue, $nValue) {
        $orig = $origValue($imgKey);
        if ($isBefore) {
            return trim((string)$orig) === '' ? asset('images/placeholder.png') : $orig;
        }
        $nv = $nValue($imgKey);
        if (trim((string)$nv) === ' ') {
            return trim((string)$orig) === '' ? asset('images/placeholder.png') : $orig;
        }
        return $nv;
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
            @foreach($imagens as $img)
                @php
                    $src = $imageSrc($img);
                    $changed = $isChanged($img);
                    $cls = $changed ? ($isBefore ? 'changed-before' : 'changed-after') : '';
                @endphp
                <div class="img-wrap {{ $cls }}">
                    <img src="{{ $src }}" alt="{{ $display('nome') ?: 'Animal' }}">
                </div>
            @endforeach
        </div>

        @php
            $nameChanged = $isChanged('nome');
            $nameClass = $nameChanged ? ($isBefore ? 'changed-before' : 'changed-after') : '';
        @endphp

        @if(trim((string)($display('nome'))) === '')
            <span id="snome" class="center">(Sem coleira)</span>
        @else
            <span id="nome" class="center {{ $nameClass }}">{{ $display('nome') }}</span>
        @endif
    </div>

    <div class="div2">
        <div id="detalhes" class="card">
            <ul>
                @foreach(['tipo' => 'Animal', 'raca' => 'Raça', 'tam' => 'Tamanho', 'sexo' => 'Sexo', 'cor' => 'Cor'] as $campo => $label)
                    @php
                        $changed = $isChanged($campo);
                        $cls = $changed ? ($isBefore ? 'alterado1' : 'alterado2') : '';
                    @endphp
                    <li class="{{ $cls }}"><b>{{ $label }}: </b>{{ $display($campo) }}</li>
                @endforeach

                <li><b>Detalhes da aparência:</b></li>
                @php 
                    $changedA = $isChanged('aparencia');
                    $clsA = $changedA ? ($isBefore ? 'alterado1' : 'alterado2') : '';
                @endphp
                <p class="{{ $clsA }}">{{ $display('aparencia') }}</p>

                @switch($caso)
                    @case(1)
                        <li><b>Ultimo lugar visto:</b></li>
                        <p>{{ $display('lugarV') }}</p>
                        @break
                    @case(2)
                        <li><b>Lugar encontrado:</b></li>
                        <p>{{ $display('lugarE') }}</p>
                        @break
                    @case(3)
                    @case(4)
                    @case(5)
                        <li><b>Ultimo lugar visto:</b></li>
                        <p class="{{ $isChanged('lugarV') ? ($isBefore ? 'alterado1' : 'alterado2') : '' }}">{{ $display('lugarV') }}</p>
                        <li><b>Lugar encontrado:</b></li>
                        <p class="{{ $isChanged('lugarE') ? ($isBefore ? 'alterado1' : 'alterado2') : '' }}">{{ $display('lugarE') }}</p>
                        @break
                    @case(6)
                        <li><b>Lugar encontrado:</b></li>
                        <p>{{ $display('lugarE') }}</p>
                        @break
                    @case(7)
                        <li><b>Ultimo lugar visto:</b></li>
                        <p>{{ $display('lugarV') }}</p>
                        @break

                    {{-- Perdido: antes = 10, depois = 11 --}}
                    @case(10)
                    @case(11)
                        @php
                            $changedLV = $isChanged('lugarV');
                            $clsLV = $changedLV ? ($isBefore ? 'alterado1' : 'alterado2') : '';
                        @endphp
                        <li><b>Último lugar visto:</b></li>
                        <p class="{{ $clsLV }}">{{ $display('lugarV') }}</p>
                        @break

                    {{-- Encontrado: antes = 12, depois = 13 --}}
                    @case(12)
                    @case(13)
                        @php
                            $changedLE = $isChanged('lugarE');
                            $clsLE = $changedLE ? ($isBefore ? 'alterado1' : 'alterado2') : '';
                        @endphp
                        <li><b>Lugar encontrado:</b></li>
                        <p class="{{ $clsLE }}">{{ $display('lugarE') }}</p>
                        @break

                    @default
                @endswitch
            </ul>
        </div>

        <div class="botao">
            @if($caso == 10)
                <form action="{{ route('animal.aceitar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="reso" class="btn-caso">Aceitar</button>
                </form>

                <form action="{{ route('animal.recusar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="aban" class="btn-caso">Recusar</button>
                </form>
            @elseif($caso == 11)
                <form action="{{ route('animal.resolver') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="reso" class="btn-caso">Resolvido</button>
                </form>

                <form action="{{ route('animal.inativar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="aban" class="btn-caso">Inativar</button>
                </form>
            @endif

            {{-- Versão alternativa (casos menores) --}}
            @if($caso == 5 || $caso == 6 || $caso == 7)
                <form action="/animal/aceitar" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="reso" class="btn-caso">Aceitar</button>
                </form>

                <form action="{{ route('animal.recusar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="aban" class="btn-caso">Recusar</button>
                </form>
            @endif

            @if($caso == 1 || $caso == 2)
                <form action="{{ route('animal.resolver') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="reso" class="btn-caso">Resolvido</button>
                </form>

                <form action="{{ route('animal.inativar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="aban" class="btn-caso">Inativar</button>
                </form>
            @endif

            @if($caso == 3)
                <form action="{{ route('animal.reativar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="aban" class="btn-caso">Reativar Caso</button>
                </form>
            @endif

            @if($caso == 4)
                <form action="{{ route('animal.reativar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="reso" class="btn-caso">Reativar Caso</button>
                </form>
            @endif
        </div>
    </div>
</div>

@else
<div class="pai">
    <div id="img" class="white" style="border-radius: 50px">
        <div id="imgs">
            <img src="{{ file_exists(public_path('images/animais/'.$animal['id'].'/imagem1.png')) ? asset('images/animais/'.$animal['id'].'/imagem1.png') : asset('images/animais/noimg.jpg') }}" alt="{{ $animal['tipo'].' '.$animal['nome'] ?? $animal['tipo'] }}">
            <img src="{{ file_exists(public_path('images/animais/'.$animal['id'].'/imagem2.png')) ? asset('images/animais/'.$animal['id'].'/imagem2.png') : asset('images/animais/noimg.jpg') }}" alt="{{ $animal['tipo'].' '.$animal['nome'] ?? $animal['tipo'] }}">
            <img src="{{ file_exists(public_path('images/animais/'.$animal['id'].'/imagem3.png')) ? asset('images/animais/'.$animal['id'].'/imagem3.png') : asset('images/animais/noimg.jpg') }}" alt="{{ $animal['tipo'].' '.$animal['nome'] ?? $animal['tipo'] }}">
            <img src="{{ file_exists(public_path('images/animais/'.$animal['id'].'/imagem4.png')) ? asset('images/animais/'.$animal['id'].'/imagem4.png') : asset('images/animais/noimg.jpg') }}" alt="{{ $animal['tipo'].' '.$animal['nome'] ?? $animal['tipo'] }}">
        </div>
        @if(!$animal['nome'])
            <span id="snome" >(Sem coleira)</span>
        @endif
        @if($animal['nome'])
            <span id="nome" ><b>{{ $animal['nome']}}</b></span>
        @endif
        <ul class="caso">
            <li>
                <b>Situação: </b>{{ $animal['situacao'] }}
            </li>
            <li id="caso"><b>Caso {{ $animal['status'] }}</b></li>
        </ul>
    </div>
    <!--
    caso [dap] = 1
    caso [dae] = 2
    caso [dcr] = 3
    caso [dca] = 4
    caso [dce]  = 5
    caso [dnae] = 6
    caso [dnap] = 7
    -->
    <div class="div2" >
        <div id="detalhes" class="white card-content" style="width: 100%;">
            <ul>
                <li><b>Animal: </b>{{$animal['tipo']}}</li>
                <li><b>Raça:   </b>{{$animal['raca']}}</li>
                <li><b>Tamanho:</b>{{$animal['tam']}}</li>
                <li><b>Sexo:   </b>{{$animal['sexo']}}</li>
                <li><b>Cor:    </b>{{$animal['cor']}}</li>
                <li><b>Detalhes da aparência:</b></li>
                <p>{{$animal['aparencia']}}</p>
                
                @if($caso == 3 || $caso == 4 || $caso == 5)
                    <li><b>Ultimo lugar visto:</b></li>
                    <p>{{$animal['lugarV']}}</p>
                    <li><b>Lugar encontrado:</b></li>
                    <p>{{$animal['lugarE']}}</p>
                @endif
                
                @if($caso == 1 || $caso == 2)
                    <li><b>Ultimo lugar visto:</b></li>
                    <p>{{$animal['lugarV']}}</p>
                @endif

                @if($caso == 2 || $caso == 6)
                    <li><b>Lugar encontrado:</b></li>
                    <p>{{$animal['lugarE']}}</p>
                @endif
            </ul>
        </div>
        <div class="botao" >
            @if($caso == 5 || $caso == 6 || $caso == 7)
                <form action="{{ route('animal.aceitar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="reso" class="btn-caso">Aceitar</button>
                </form>

                <form action="{{ route('animal.recusar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="aban" class="btn-caso">Recusar</button>
                </form>
            @endif

            @if($caso == 1 || $caso == 2)
                <form action="{{ route('animal.resolver') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="reso" class="btn-caso">Resolvido</button>
                </form>

                <form action="{{ route('animal.inativar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="aban" class="btn-caso">Inativar</button>
                </form>
            @endif

            @if($caso == 3)
                <form action="{{ route('animal.reativar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="aban" class="btn-caso">Reativar Caso</button>
                </form>
            @endif

            @if($caso == 4)
                <form action="{{ route('animal.reativar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="reso" class="btn-caso">Reativar Caso</button>
                </form>
            @endif
            {{--
            @if($caso == 5 || $caso == 6 || $caso == 7)
                <form action="{{ route('animal.aceitar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="reso" class="btn-caso">Aceitar</button>
                </form>

                <form action="{{ route('animal.recusar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="aban" class="btn-caso">Recusar</button>
                </form>
            @endif
            
            @if($caso == 1 || $caso == 7)
                <button id="reso" class="btn-caso" >Resolvido</button>
                <button id="aban" class="btn-caso" >Inativar</button>
            @endif

            @if($caso == 3)
                <button id="aban" class="btn-caso" >Reativar Caso</button>
            @endif

            @if($caso == 4)
                <button id="reso" class="btn-caso" >Reativar Caso</button>
            @endif
            --}}
        </div>
    </div>
</div>
@endif

@include('components.css.CSSdetalhes')