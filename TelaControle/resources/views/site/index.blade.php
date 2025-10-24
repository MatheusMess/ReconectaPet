@extends('site.layout')
@section('title','Início')
@section('conteudo')
    @include('components.css.CSSindex')
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
            <a href="casos-resolvidos"><h1>Casos Resolvidos</h1></a>
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
            <a href="casos-inativados"><h1>Casos Inativados</h1></a>
        </div>
        <div class="opcao">
            <span class="icone-fundo">&#128393;</span> <!-- X -->
            <a href="ce"><h1>Casos Editados</h1></a>
        </div>
    </div>
@endsection