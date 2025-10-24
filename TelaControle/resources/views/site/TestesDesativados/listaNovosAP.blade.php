
@extends('site.layout')
@section('title','Lista')
@section('conteudo')
    <div class="container mt-4">
        <h2 class="mb-4">Novos Animais Perdidos</h2>
        <div class="row">
            @php
                $animais = [
                    [
                        'tipo' => 'Gato',
                        'nome' => 'Mimi',
                        'raca' => 'Siamês',
                        'cor' => 'Branco e cinza',
                        'sexo' => 'Fêmea',
                        'imagem' => 'https://adotar.com.br/upload/2016-07/animais_imagem200048.jpg?w=700&format=webp',
                    ],
                    [
                        'tipo' => 'Cachorro',
                        'nome' => 'Qiqi',
                        'raca' => 'Pastor-Alemão',
                        'cor' => 'Cinza',
                        'sexo' => 'Fêmea',
                        'imagem' => 'https://i.pinimg.com/474x/f2/9d/ba/f29dba2b270a670bc0f604692762cf91.jpg',
                        //imagem do rex:'imagem' => 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQkpmLH_tdzgYVmAIk8_mQhWFY73z-Dwf7sxtsgfD5n_vBFqgFS',
                    ],
                    [
                        'tipo' => 'Gato',
                        'nome' => 'Bolinha',
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