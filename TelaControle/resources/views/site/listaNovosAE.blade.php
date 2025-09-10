
@extends('site.layout')
@section('title','Lista')
@section('conteudo')
    <div class="container mt-4">
        <h2 class="mb-4">Novos Animais Encontrados</h2>
        <div class="row">
            @php
                $animais = [
                    [
                        'tipo' => 'Gato',
                        'nome' => '(sem coleira)',
                        'raca' => 'Siamês',
                        'cor' => 'Branco e cinza',
                        'sexo' => 'Fêmea',
                        'imagem' => 'https://adotar.com.br/upload/2016-07/animais_imagem200048.jpg?w=700&format=webp',
                    ],
                    [
                        'tipo' => 'Cachorro',
                        'nome' => 'Max',
                        'raca' => 'Labrador',
                        'cor' => 'Preto',
                        'sexo' => 'Macho',
                        'imagem' => 'https://cdn.los-animales.org/fotos/419836998_7902153-filhote-de-labrador-preto.jpg',
                    ],
                    [
                        'tipo' => 'Gato',
                        'nome' => '(sem coleira)',
                        'raca' => 'Persa',
                        'cor' => 'Cinza',
                        'sexo' => 'Macho',
                        'imagem' => 'https://img.olx.com.br/images/25/252444316710330.jpg',
                    ],
                    [
                        'tipo' => 'Cachorro',
                        'nome' => 'Luna',
                        'raca' => 'Akbash',
                        'cor' => 'Branco',
                        'sexo' => 'Fêmea',
                        'imagem' => 'https://cdn.pixabay.com/photo/2018/12/09/14/58/dog-3865029_1280.jpg',
                    ],
                ];
            @endphp
            <x-lista :animais="$animais" :showActions="true" />
        </div>
    </div>
@endsection