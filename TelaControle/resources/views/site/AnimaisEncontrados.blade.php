@extends('site.layout')
@section('title','Animais Perdidos')
@section('conteudo')
    {{--@component('components.navegacao')--}}
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
                font-size: 19px;
                margin-left: 20px;
                margin-bottom: 20px;
            }
        }
        .card{
            height: 125%;
            margin: 10px;
            li{
                margin-top: 10px;
                dysplay: flex;
                align-items: center;
                width: 100%;
                justify-content: space-between;
            }
        }
    </style>
    {{-- @endcomponent--}}
    <div class="row container">
        @php
            $animais = [
                [
                    'tipo' => 'Cachorro',
                    'nome' => 'Bento',
                    'raca' => 'Vira-Lata',
                    'cor' => 'Tricolor',
                    'sexo' => 'Macho',
                    'imagem' => 'https://adotar.com.br/upload/2024-09/animais_imagem1155164.jpg?w=700&format=webp',
                ],
                [
                    'tipo' => 'Gato',
                    'nome' => 'Olivia',
                    'raca' => 'Sphynx',
                    'cor' => 'Bege',
                    'sexo' => 'Fêmea',
                    'imagem' => 'https://cdn2.thecatapi.com/images/MTY3NjU2Mg.jpg',
                ],
                [
                    'tipo' => 'Cachorro',
                    'nome' => 'Zeca',
                    'raca' => 'Beagle',
                    'cor' => 'Tricolor',
                    'sexo' => 'Macho',
                    'imagem' => 'https://images.dog.ceo/breeds/beagle/n02088364_11136.jpg',
                ],
                [
                    'tipo' => 'Cachorro',
                    'nome' => 'Kira',
                    'raca' => 'Corgi',
                    'cor' => 'Laranja e branco',
                    'sexo' => 'Fêmea',
                    'imagem' => 'https://images.dog.ceo/breeds/corgi-cardigan/n02113186_291.jpg',
                ],
            ];
        @endphp
        @foreach($animais as $animal)
        <div class="col s12 m3" style="height: 300px" >
            <div class="card">
                <div class="card-image">
                    <img height="200px"  src="{{ $animal['imagem'] }}">
                    <span class="card-title"><b>{{ $animal['nome'] }}</b></span>
                    <a class="btn-floating halfway-fab waves-effect waves-light red" href="http://reconectpet.test/dap"><i class="material-icons background-color: cyan">visibility</i></a>
                </div>
                <div class="card-content">
                    <ul class="info">
                        <li><b>Animal: </b>{{ $animal['tipo'] }}</li>
                        <li><b>Raça:   </b>{{ $animal['raca'] }}</li>
                        <li><b>Sexo:   </b>{{ $animal['sexo'] }}</li>
                        <li><b>Cor:    </b>{{ $animal['cor'] }}</li>
                    </ul>
                </div>
            </div>
        </div>
        @endforeach
    </div>
@endsection