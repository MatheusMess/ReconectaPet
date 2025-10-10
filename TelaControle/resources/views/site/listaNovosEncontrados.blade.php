
@extends('site.layout')
@section('title','Animais Encontrados')
@section('conteudo')
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

    <div class="container mt-4">
        <h2 class="mb-4">Animais Encontrados</h2>
        <div class="row">
            {{-- Verifica se a coleção de animais não está vazia --}}
            @if($animais->count() > 0)
                {{-- Passa os dados recebidos do controller para o componente de lista --}}
                {{-- showActions=false para não mostrar botões de aprovar/recusar --}}
                <x-lista :animais="$animais" :showActions="false" />
            @else
                <div class="col">
                    <p class="text-center">Nenhum animal encontrado no momento.</p>
                </div>
            @endif
        </div>
    </div>
@endsection