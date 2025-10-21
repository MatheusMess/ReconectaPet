@extends('site.layout')
@section('title','Início')
@section('conteudo')
    <style>
        #pai{
            display: grid;
            grid-template-columns: 1fr 1fr 1fr 1fr;
            grid-template-rows: 1fr 1fr;
            gap: 40px;
            height: 50%;
            margin: 5%;
            border-radius: 50px;
            padding: 20px;
            justify-items: center;
            align-items: center;
        }
        .opcao{
            position: relative;
            background-color: rgb(16, 196, 228);
            width: 220px;
            height: 220px;
            border-radius: 30px;
            display: flex;
            justify-content: center;
            align-items: center;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
            
        }
        .opcao:hover{
            transform: scale(1.08);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.18);
            cursor: pointer;
            background-color: gold;
            border-radius: 50px;
            transition: 200ms;
        }
        .opcao:not(:hover){
            border-radius: 30px;
            transition: 200ms;
        }
        .icone-fundo{
            position: absolute;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%);
            font-size: 125px;
            color: #757575;
            opacity: 0.18;
            z-index: 1;
            pointer-events: none;
            align-items: center;
            
            #estrela{
                padding-top: 40px;
                font-size: 150px;
            }
        }

        h1{
            position: relative;
            z-index: 2;
            text-align: center;
            font-size: 22px;
            color: #00363a;
            font-weight: bold;
        }
    </style>
    <div id="pai">
        <div class="opcao">
            <span class="icone-fundo">&#128062;</span> <!-- pata -->
            <a href="animais-encontrados"><h1>Animais Encontrados</h1></a>
        </div>
        <div class="opcao">
            <span class="icone-fundo">&#128364;</span> <!-- pata -->
            <a href="n-animais-encontrados"><h1>Novos Animais Encontrados</h1></a>
        </div>
        <div class="opcao">
            <span class="icone-fundo">&#10004;</span> <!-- verificado -->
            <a href="cr"><h1>Casos Resolvidos</h1></a>
        </div>
        <div class="opcao">
            <span class="icone-fundo"><i class="material-icons" id="estrela">star</i></span> <!-- X -->
            <a href="todos-animais"><h1>Todos Animais</h1></a>
        </div>
        <div class="opcao">
            <span class="icone-fundo">&#128269;</span> <!-- lupa -->
            <a href="animais-perdidos"><h1>Animais Perdidos</h1></a>
        </div>
        <div class="opcao">
            <span class="icone-fundo">&#9940;</span> <!-- lupa -->
            <a href="n-animais-perdidos"><h1>Novos Animais Perdidos</h1></a>
        </div>
        <div class="opcao">
            <span class="icone-fundo">&#10060;</span> <!-- X -->
            <a href="ca"><h1>Casos Inativados</h1></a>
        </div>
        <div class="opcao">
            <span class="icone-fundo">&#128393;</span> <!-- X -->
            <a href="ce"><h1>Casos Editados</h1></a>
        </div>
    </div>
@endsection