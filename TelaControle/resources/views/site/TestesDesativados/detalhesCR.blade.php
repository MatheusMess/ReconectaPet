@extends('site.layout')
@section('title','Detalhes')
@section('conteudo')
    @php
        $animal = [
            'nome' => 'Muttley',
            'tipo' => 'Cachorro',
            'raca' => 'Vira-Lata',
            'cor' => 'Caramelo',
            'sexo' => 'Macho',
            'tam' => 'Grande',
            'imagem1' => 'https://assets.brasildefato.com.br/2024/09/image_processing20210113-1654-11x5azn-750x533.jpeg',
            'imagem2' => 'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQ20-xvTBxtn2DUGCP5yMeum9c4mTjcxaBIcjJlNiAO79-ZLZer',
            'imagem3' => 'https://fotos.amomeupet.org/uploads/fotos/1731164068_672f77a4e7588_hd.jpg',
            'imagem4' => 'https://preview.redd.it/leo-the-beagle-v0-3dvjpseinazd1.jpg?width=640&crop=smart&auto=webp&s=f91bece5eef3db5592d70d64b174a6af3d5497ee',
            'aparencia' => 'Ele é magro e a cor da barriga é branco',
            'LugarV' => 'Rua Exemplo da Silva',
            'LugarE' => 'Rua Exemplo de Oliveira'
        ];
    @endphp
    <x-detalhes :animal="$animal" :caso="3"/>
@endsection