@extends('site.layout')
@section('title','Detalhes')
@section('conteudo')
        @php
        $animal = [
            'nome' => 'Spike',
            'tipo' => 'Cachorro',
            'raca' => 'Labrador',
            'cor' => 'Marrom',
            'sexo' => 'Macho',
            'tam' => 'Grande',
            'imagem1' => 'https://adotar.com.br/upload/2023-04/animais_imagem979687.jpg?w=700&format=webp',
            'imagem2' => 'https://cruzarcachorro.com.br/imagens/produto/1/2853.jpg',
            'imagem3' => 'https://i.pinimg.com/736x/9c/67/38/9c6738bf74f94adf5ed0f9e4170cbf2d.jpg',
            'imagem4' => 'https://adnchocolate.com.ar/wp-content/uploads/como-son-las-hembras-labrador.webp',
            'aparencia' => 'pelo marrom escuro quase preto, o focinho é mais claro que o pelo',
            //'aparencia' => 'Orelhas peludas, olhos azuis, parecido com um lobo',
            //'LugarV' => 'Rua aleatória, 123 - Bairro Exemplo',
            'LugarV' => 'Av. João Olímpio de Oliveira, Vila Asem, Itapetininga - SP',
            'LugarE' => ''
        ];
    @endphp
    <x-detalhes :animal="$animal" :caso="1"/>

@endsection