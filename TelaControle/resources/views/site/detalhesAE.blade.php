@extends('site.layout')
@section('title','Detalhes')
@section('conteudo')
    @php
        $animal = [
            'nome' => '',
            'tipo' => 'Gato',
            'raca' => 'Siamês',
            'cor' => 'Preto e creme',
            'sexo' => 'Fêmea',
            'tam' => 'Médio',
            'imagem1' => 'https://adotar.com.br/upload/2024-04/animais_imagem1112099.jpg?w=700&format=webp',
            'imagem2' => 'https://adotar.com.br/upload/2024-04/animais_imagem1112078.jpeg?w=700&format=webp',
            'imagem3' => 'https://adotar.com.br/upload/2024-04/animais_imagem1112079.jpeg?w=700&format=webp',
            'imagem4' => 'https://adotar.com.br/upload/2024-04/animais_imagem1112076.jpeg?w=115&format=webp',
            'aparencia' => 'entre a parte clara e a parte escura tem um tom de marrom com cinza',
            'LugarV' => '',
            'LugarE' => 'Rua Olívia da Silva de Oliveira'
        ];
    @endphp
    <x-detalhes :animal="$animal" :caso="2"/>

@endsection