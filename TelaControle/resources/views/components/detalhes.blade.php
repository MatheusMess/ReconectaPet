@if($caso >=10)


@php
    // Determina se este componente está mostrando "antes" ou "depois"
    $isBefore = in_array($caso, [10, 12], true);
    $isAfter  = in_array($caso, [11, 13], true);

    // campos e imagens
    $campos = ['tipo','raca','tam','sexo','cor','aparencia','LugarV','LugarE','nome'];
    $imagens = ['imagem1','imagem2','imagem3','imagem4'];

    // helper: valor "N..." deve receber "' '" quando não informado -> aqui usamos string com um espaço
    $nValue = function($key) use ($animal) {
        $k = 'N'.$key;
        $v = $animal[$k] ?? null;
        // retornar " " quando não informado (conforme requisito)
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
        // para "antes" sempre mostra o original
        if ($isBefore) {
            return $origValue($key);
        }
        // para "depois" mostra N... quando presente (caso contrário original)
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

        {{-- usar display('nome') ao invés de checar diretamente $animal['nome'] --}}
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
                        <p>{{ $display('LugarV') }}</p>
                        @break
                    @case(2)
                        <li><b>Lugar encontrado:</b></li>
                        <p>{{ $display('LugarE') }}</p>
                        @break
                    @case(3)
                    @case(4)
                    @case(5)
                        <li><b>Ultimo lugar visto:</b></li>
                        <p class="{{ $isChanged('LugarV') ? ($isBefore ? 'alterado1' : 'alterado2') : '' }}">{{ $display('LugarV') }}</p>
                        <li><b>Lugar encontrado:</b></li>
                        <p class="{{ $isChanged('LugarE') ? ($isBefore ? 'alterado1' : 'alterado2') : '' }}">{{ $display('LugarE') }}</p>
                        @break
                    @case(6)
                        <li><b>Lugar encontrado:</b></li>
                        <p>{{ $display('LugarE') }}</p>
                        @break
                    @case(7)
                        <li><b>Ultimo lugar visto:</b></li>
                        <p>{{ $display('LugarV') }}</p>
                        @break

                    {{-- Perdido: antes = 10, depois = 11 --}}
                    @case(10)
                    @case(11)
                        @php
                            $changedLV = $isChanged('LugarV');
                            $clsLV = $changedLV ? ($isBefore ? 'alterado1' : 'alterado2') : '';
                        @endphp
                        <li><b>Último lugar visto:</b></li>
                        <p class="{{ $clsLV }}">{{ $display('LugarV') }}</p>
                        @break

                    {{-- Encontrado: antes = 12, depois = 13 --}}
                    @case(12)
                    @case(13)
                        @php
                            $changedLE = $isChanged('LugarE');
                            $clsLE = $changedLE ? ($isBefore ? 'alterado1' : 'alterado2') : '';
                        @endphp
                        <li><b>Lugar encontrado:</b></li>
                        <p class="{{ $clsLE }}">{{ $display('LugarE') }}</p>
                        @break

                    @default
                @endswitch
            </ul>
        </div>

        <div class="botao">
            @if($aceitar)
                <button id="reso" class="btn-caso">Aceitar</button>
            @endif
            @if($recusar)
                <button id="aban" class="btn-caso">Recusar</button>
            @endif
            @if($resolvido)
                <button id="reso" class="btn-caso">Resolvido</button>
            @endif
            @if($abandonar)
                <button id="aban" class="btn-caso">Abandonar</button>
            @endif
            @if($rcr)
                <button id="aban" class="btn-caso">Reativar Caso</button>
            @endif
            @if($rca)
                <button id="reso" class="btn-caso">Reativar Caso</button>
            @endif
        </div>
    </div>
</div>

<style>
    /* container reduzido e responsivo */
    .pai{
        margin: 4%;
        background-color: aqua;
        width: 1050px;
        height: 650px;
        align-self: center;
        justify-self: center;
        border-radius: 50px;
        padding: 40px;
        display: flex;
        align-items: center;
        padding-left: 50px;
        margin-top: 20px;
    }
    img{
        margin: 10px;
        width: 150px;
        height: 150px;
        object-fit: cover; 
        object-position: center; 
        border-radius: 30px;
        display: inline-block;
        transition: width 0.3s, height 0.3s;
    }
    
    
    #detalhes{
        border-radius: 50px;
        width: 40%;
        height: 90%;
        align-items: center;
        display: flex;
        
        font-size: 20px;
        padding: 3%;
        margin-top: 20px;
        
    }
    #imgs{
        height: 60%;
        padding-top: 3%;
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        align-items: center;
        margin: 20px;
    }
    #img{
        width: 40%;
        height: 100%;
        align-items: center;
        justify-items: center;
        display: inline-block;
        flex-direction: column;
        font-size: 50px;
        border-radius: 50px;
    }
    li{
        margin-top: 15px;
    }
    #snome{
        width: 100%;
        height: 20%;
        margin-top: 10px;
        padding: 30px;
    }

    /* destaque vermelho / verde */
    .alterado1, .changed-before { background: rgba(255,0,0,0.18); }
    .alterado2, .changed-after { background: rgba(0,128,0,0.18); }

    /* detalhes: sempre branco, com overflow para telas pequenas */
    #detalhes{
        width: 100%;
        height: 20%;
        font-size: 30px; 
        padding: 30px;
    }

    .div2{
        width: 55%;
        display: flex;
        flex-direction: column;
        
        align-items: center;
        margin-left: 3%;
        margin-top: 20px;   
    }
    .botao{
        margin: 20px;
        width: 100%;
        display: flex; 
        justify-content: center;
        gap: 20px; 
    }
    #reso{
        background:rgba(0, 128, 0, 0.5);
    }
    #aban{
        background:rgba(255, 0, 0, 0.75);
    }
    #reso:hover{
        background: gold;
    }
    #aban:hover{
        background: gold;
    }
    .btn-caso{
        
        color:#333;
        border:none;
        border-radius:20px;
        padding:12px 32px;
        font-size:18px;
        font-weight:500;
        box-shadow:0 2px 8px rgba(0,0,0,0.08);
        cursor:pointer;
        transition:background 0.25s;
    }
    
    
</style>
@if($caso >= 10)
    <style>
        /* tela cheia: escala inicial */
        .pai{
            transform: scale(0.85);
            transform-origin: top center;
            transition: transform 180ms ease;
        }

        /* conforme a tela reduz, reduz a escala */
        @media (max-width: 1600px) {
            .pai { transform: scale(0.7); }
        }
        @media (max-width: 1400px) {
            .pai { transform: scale(0.65); }
        }
        @media (max-width: 1300px) {
            .pai { transform: scale(0.60); }
                transform: none;
                flex-direction: column;
                align-items: stretch;
        }
        @media (max-width: 1000px) {
            .pai { transform: scale(0.55); }
                transform: none;
                flex-direction: column;
                align-items: stretch;
        }
        
    </style>
    /*
    @if($caso == 11 || $caso == 13)
        <style>
        .alterado2{
            background-color: rgba(42, 160, 42, 0.795);
            font-weight: bold;
        }
        </style>
    @endif
    @if($caso == 10 || $caso == 12)
        <style>
        .alterado1{
            background-color: rgba(252, 59, 59, 0.801);
            font-weight: bold;
        }
        </style>
    @endif*/
@endif
@else
        <div class="pai">
    <div id="img" class="white" style="border-radius: 50px">
        <div id="imgs">
            <img src="{{ $animal['imagem1'] ?? asset('images/placeholder.png') }}" alt="{{ $animal['nome'] ?? 'Animal' }}">
            <img src="{{ $animal['imagem2'] ?? asset('images/placeholder.png') }}" alt="{{ $animal['nome'] ?? 'Animal' }}">
            <img src="{{ $animal['imagem3'] ?? asset('images/placeholder.png') }}" alt="{{ $animal['nome'] ?? 'Animal' }}">
            <img src="{{ $animal['imagem4'] ?? asset('images/placeholder.png') }}" alt="{{ $animal['nome'] ?? 'Animal' }}">
        </div>
        @if(!$animal['nome'])
            <span id="snome" class="center">(Sem coleira)</span>
        @endif
        @if($animal['nome'])
            <span id="nome" class="center">{{ $animal['nome']}}</span>
        @endif
        
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
                @switch($caso)
                    @case(1)
                        <li><b>Ultimo lugar visto:</b></li>
                        <p>{{$animal['LugarV']}}</p>
                        @break
                    @case(2)
                        <li><b>Lugar encontrado:</b></li>
                        <p>{{$animal['LugarE']}}</p>
                        @break
                    @case(3)
                        <li><b>Ultimo lugar visto:</b></li>
                        <p>{{$animal['LugarV']}}</p>
                        <li><b>Lugar encontrado:</b></li>
                        <p>{{$animal['LugarE']}}</p>
                        @break
                    @case(4)
                        <li><b>Ultimo lugar visto:</b></li>
                        <p>{{$animal['LugarV']}}</p>
                        <li><b>Lugar encontrado:</b></li>
                        <p>{{$animal['LugarE']}}</p>
                        @break
                    @case(5)
                        <li><b>Ultimo lugar visto:</b></li>
                        <p>{{$animal['LugarV']}}</p>
                        <li><b>Lugar encontrado:</b></li>
                        <p>{{$animal['LugarE']}}</p>
                        @break
                    @case(6)
                        <li><b>Lugar encontrado:</b></li>
                        <p>{{$animal['LugarE']}}</p>
                        @break
                    @case(7)
                        <li><b>Ultimo lugar visto:</b></li>
                        <p>{{$animal['LugarV']}}</p>
                        @break
                    @default
                @endswitch
            </ul>
        </div>
        <div class="botao" >
            @if($aceitar)
                <button id="reso" class="btn-caso" >Aceitar</button>
            @endif

            @if($recusar)
                <button id="aban" class="btn-caso" >Recusar</button>
            @endif
            
            @if($resolvido)
                <button id="reso" class="btn-caso" >Resolvido</button>
            @endif

            @if($abandonar)
                <button id="aban" class="btn-caso" >Abandonar</button>
            @endif

            @if($rcr)
                <button id="aban" class="btn-caso" >Reativar Caso</button>
            @endif

            @if($rca)
                <button id="reso" class="btn-caso" >Reativar Caso</button>
            @endif
            
        </div>
    </div>
</div>


<style>
    
    .pai{
        margin: 4%;
        background-color: aqua;
        width: 1050px;
        height: 650px;
        align-self: center;
        justify-self: center;
        border-radius: 50px;
        padding: 20px;
        display: flex;
        align-items: center;
        padding-left: 50px;
        margin-top: 20px;
    }
    img{
        margin: 10px;
        width: 150px;
        height: 150px;
        object-fit: cover; 
        object-position: center; 
        border-radius: 30px;
        display: inline-block;
        transition: width 0.3s, height 0.3s;
    }
    
    
    #detalhes{
        border-radius: 50px;
        width: 100%;
        height: 80%;
        align-items: center;
        display: flex;
        
        font-size: 20px;
        padding: 3%;
        margin-top: 20px;

    }
    #imgs{
        height: 60%;
        padding-top: 3%;
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        align-items: center;
        margin: 20px;
    }
    #img{
        width: 40%;
        height: 90%;
        align-items: center;
        justify-items: center;
        display: inline-block;
        flex-direction: column;
        font-size: 50px;
        
    }
    li{
        margin-top: 15px;
    }
    #nome{
        width: 100%;
        height: 20%;
        margin-top: 10px;
        padding: 30px;
    }
    #snome{
        width: 100%;
        height: 20%;
        font-size: 30px; 
        padding: 30px;
    }
    .div2{
        height: 100%;
        width: 55%;
        display: flex;
        flex-direction: column;
        
        align-items: center;
        margin-left: 3%;
        margin-top: 20px;   
    }
    .botao{
        margin: 20px;
        width: 100%;
        display: flex; 
        justify-content: center;
        gap: 20px; 
    }
    #reso{
        background:rgba(0, 128, 0, 0.5);
    }
    #aban{
        background:rgba(255, 0, 0, 0.75);
    }
    #reso:hover{
        background: gold;
    }
    #aban:hover{
        background: gold;
    }
    .btn-caso{
        
        color:#333;
        border:none;
        border-radius:20px;
        padding:12px 32px;
        font-size:18px;
        font-weight:500;
        box-shadow:0 2px 8px rgba(0,0,0,0.08);
        cursor:pointer;
        transition:background 0.25s;
    }
    
</style>

@endif