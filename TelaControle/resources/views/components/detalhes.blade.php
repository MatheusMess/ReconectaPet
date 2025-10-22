@if($caso >=10)


@php
    // Determina se este componente está mostrando "antes" ou "depois"
    $isBefore = in_array($caso, [10, 12], true);
    $isAfter  = in_array($caso, [11, 13], true);

    
    $campos = ['tipo','raca','tam','sexo','cor','aparencia','lugar_visto','lugar_encontrado','nome'];
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
                        <p>{{ $display('lugar_visto') }}</p>
                        @break
                    @case(2)
                        <li><b>Lugar encontrado:</b></li>
                        <p>{{ $display('lugar_encontrado') }}</p>
                        @break
                    @case(3)
                    @case(4)
                    @case(5)
                        <li><b>Ultimo lugar visto:</b></li>
                        <p class="{{ $isChanged('lugar_visto') ? ($isBefore ? 'alterado1' : 'alterado2') : '' }}">{{ $display('lugar_visto') }}</p>
                        <li><b>Lugar encontrado:</b></li>
                        <p class="{{ $isChanged('lugar_encontrado') ? ($isBefore ? 'alterado1' : 'alterado2') : '' }}">{{ $display('lugar_encontrado') }}</p>
                        @break
                    @case(6)
                        <li><b>Lugar encontrado:</b></li>
                        <p>{{ $display('lugar_encontrado') }}</p>
                        @break
                    @case(7)
                        <li><b>Ultimo lugar visto:</b></li>
                        <p>{{ $display('lugar_visto') }}</p>
                        @break

                    {{-- Perdido: antes = 10, depois = 11 --}}
                    @case(10)
                    @case(11)
                        @php
                            $changedLV = $isChanged('lugar_visto');
                            $clsLV = $changedLV ? ($isBefore ? 'alterado1' : 'alterado2') : '';
                        @endphp
                        <li><b>Último lugar visto:</b></li>
                        <p class="{{ $clsLV }}">{{ $display('lugar_visto') }}</p>
                        @break

                    {{-- Encontrado: antes = 12, depois = 13 --}}
                    @case(12)
                    @case(13)
                        @php
                            $changedLE = $isChanged('lugar_encontrado');
                            $clsLE = $changedLE ? ($isBefore ? 'alterado1' : 'alterado2') : '';
                        @endphp
                        <li><b>Lugar encontrado:</b></li>
                        <p class="{{ $clsLE }}">{{ $display('lugar_encontrado') }}</p>
                        @break

                    @default
                @endswitch
            </ul>
        </div>

        <div class="botao">
            @if($caso == 10) 
                <button id="reso" class="btn-caso">Aceitar</button>
                <button id="aban" class="btn-caso">Recusar</button>
            @elseif($caso == 11)
                <button id="reso" class="btn-caso">Resolvido</button>
                <button id="aban" class="btn-caso">Inativar</button>
            @endif
        </div>
    </div>
</div>

<style>
    /* estilos combinados (unificados dos dois blocos originais) */

    /* container principal */
    .pai{
        margin: 4%;
        background-color: rgb(16, 196, 228);
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
        transform: scale(0.85);
        transform-origin: top center;
        transition: transform 180ms ease;
    }

    /* imagens */
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

    /* área de detalhes */
    #detalhes{
        border-radius: 50px;
        width: 100%;
        height: 20%;
        font-size: 30px;
        padding: 30px;
        display: flex;
        align-items: center;
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

    /* layout secundário */
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
    #reso:hover, #aban:hover{
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

    /* ajustes de responsividade (mantidos e combinados) */
    @media (max-width: 1600px) {
        .pai { transform: scale(0.7); }
    }
    @media (max-width: 1400px) {
        .pai { transform: scale(0.65); }
    }
    @media (max-width: 1300px) {
        .pai { transform: scale(0.60); }
        .pai { transform: none; flex-direction: column; align-items: stretch; }
    }
    @media (max-width: 1000px) {
        .pai { transform: scale(0.55); transform: none; flex-direction: column; align-items: stretch; }
    }

    /* regras alternativas para a versão sem "antes/depois" */
    .white { background: white; }
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

</style>

@else
<div class="pai">
    <div id="img" class="white" style="border-radius: 50px">
        <div id="imgs">
            <img src="{{ $animal['imagem1'] ?? asset('images/animais/noimg.jpg') }}" alt="{{ $animal['nome'] ?? 'Animal' }}">
            <img src="{{ $animal['imagem2'] ?? asset('images/animais/noimg.jpg') }}" alt="{{ $animal['nome'] ?? 'Animal' }}">
            <img src="{{ $animal['imagem3'] ?? asset('images/animais/noimg.jpg') }}" alt="{{ $animal['nome'] ?? 'Animal' }}">
            <img src="{{ $animal['imagem4'] ?? asset('images/animais/noimg.jpg') }}" alt="{{ $animal['nome'] ?? 'Animal' }}">
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
                        <p>{{$animal['lugar_visto']}}</p>
                        @break
                    @case(2)
                        <li><b>Lugar encontrado:</b></li>
                        <p>{{$animal['lugar_encontrado']}}</p>
                        @break
                    @case(3)
                        <li><b>Ultimo lugar visto:</b></li>
                        <p>{{$animal['lugar_visto']}}</p>
                        <li><b>Lugar encontrado:</b></li>
                        <p>{{$animal['lugar_encontrado']}}</p>
                        @break
                    @case(4)
                        <li><b>Ultimo lugar visto:</b></li>
                        <p>{{$animal['lugar_visto']}}</p>
                        <li><b>Lugar encontrado:</b></li>
                        <p>{{$animal['lugar_encontrado']}}</p>
                        @break
                    @case(5)
                        <li><b>Ultimo lugar visto:</b></li>
                        <p>{{$animal['lugar_visto']}}</p>
                        <li><b>Lugar encontrado:</b></li>
                        <p>{{$animal['lugar_encontrado']}}</p>
                        @break
                    @   case(6)
                        <li><b>Lugar encontrado:</b></li>
                        <p>{{$animal['lugar_encontrado']}}</p>
                        @break
                    @case(7)
                        <li><b>Ultimo lugar visto:</b></li>
                        <p>{{$animal['lugar_visto']}}</p>
                        @break
                    @default
                @endswitch
            </ul>
        </div>
        <div class="botao" >
            @if($caso == 5 || $caso == 6 || $caso == 7)
                <button id="reso" class="btn-caso" >Aceitar</button>
                <button id="aban" class="btn-caso" >Recusar</button>
            @endif
            
            @if($caso == 1 || $caso == 2)
                <button id="reso" class="btn-caso" >Resolvido</button>
                <button id="aban" class="btn-caso" >Inativar</button>
            @endif

            @if($caso == 3)
                <button id="aban" class="btn-caso" >Reativar Caso</button>
            @endif

            @if($caso == 4)
                <button id="reso" class="btn-caso" >Reativar Caso</button>
            @endif
            
        </div>
    </div>
</div>


<style>
    
    .pai{
        margin: 4%;
        background-color: rgb(16, 196, 228);
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
        background:rgb(31, 151, 31);
    }
    #aban{
        background:rgb(206, 39, 39);
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