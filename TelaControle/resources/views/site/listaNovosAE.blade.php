
@extends('site.layout')
@section('title','Lista')
@section('conteudo')
    <style>
        img{
            width: 150px;
            height: 150px;
            object-fit: cover; 
            object-position: center; 
            border-radius: 100px;
        }
        .img{
            object-fit: cover; 
            object-position: center; 
            height: 150px;
            width: 150px;
        }
        #item{
            display: flex;
            padding: 2%;
            border-radius: 100px;
            align-items: center;
            justify-items: center;
            ul{
                width: 100%;
                display: flex;
                justify-content: space-between;
            }
            li{
                width: 175px;
                font-size: 20px;
                margin-left: 20px;
                margin-bottom: 20px;
            }
        }
        #animal{
            
            
        }
    </style>
    <div class="container mt-4">
        <h2 class="mb-4">Novos Animais Encontrados</h2>
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
                        'nome' => 'Rex',
                        'raca' => 'Labrador',
                        'cor' => 'Preto',
                        'sexo' => 'Macho',
                        'imagem' => 'https://www.javer-keleb.com/wp-content/uploads/2014/04/Chocolate-255x300.jpg',
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
            @foreach($animais as $animal)
                <div  class="col-md-6 col-lg-4 mb-4">
                    <div id="item" class="card h-100">
                        <div class="img"><img src="{{ $animal['imagem'] }}" class="card-img-top" alt="Imagem do {{ $animal['tipo'] }}"></div>
                        <div class="card-body">
                            <h5 class="card-title">{{ $animal['nome'] }}</h5>
                            <ul class="list-unstyled mb-3">
                                <li><strong>Animal:</strong> {{ $animal['tipo'] }}</li>
                                <li><strong>Raça:</strong> {{ $animal['raca'] }}</li>
                                <li><strong>Cor:</strong> {{ $animal['cor'] }}</li>
                                <li><strong>Sexo:</strong> {{ $animal['sexo'] }}</li>
                            </ul>
                            <div class="d-flex justify-content-between">
                                <a href="http://reconectpet.test/dap" class="btn btn-info">Ver detalhes</a>
                                <button class="btn btn-success">Aceitar</button>
                                <button class="btn btn-danger">Recusar</button>
                            </div>
                        </div>
                    </div>
                </div>
            @endforeach
        </div>
    </div>
@endsection