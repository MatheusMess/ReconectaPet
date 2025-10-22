@extends('site.layout')
@section('title','Animais Perdidos')
@section('conteudo')
{{--    
{{--@component('components.navegacao')-}}
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
        #ic:hover{
            background-color: gold;
        }
        .card{
            height: 110%;
            margin: 10px;
            li{
                margin-top: 10px;
                dysplay: flex;
                align-items: center;
                width: 100%;
                justify-content: space-between;
            }
        }
        #teste{
            color: black;
        }
    </style>
    {{-- @endcomponent-}}
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
                    'nome' => '',
                    'raca' => 'Siamês',
                    'cor' => 'Preto e creme',
                    'sexo' => 'Fêmea',
                    'imagem' => 'https://adotar.com.br/upload/2024-04/animais_imagem1112099.jpg?w=700&format=webp',
                ],
                [
                    'tipo' => 'Cachorro',
                    'nome' => 'Zeca',
                    'raca' => 'Beagle',
                    'cor' => 'Tricolor',
                    'sexo' => 'Macho',
                    'imagem' => 'https://love.doghero.com.br/wp-content/uploads/2016/10/Beagle-6-1024x768.jpg',
                ],
                [
                    'tipo' => 'Cachorro',
                    'nome' => '',
                    'raca' => 'Labrador',
                    'cor' => 'Branco',
                    'sexo' => 'Fêmea',
                    'imagem' => 'https://cdn.jornaldaparaiba.com.br/wp-content/uploads/2024/01/racas-de-cachorro-labrador-retriever.jpg?xid=650493',
                ],
                [
                    'tipo' => ' ',
                    'nome' => 'Teste',
                    'raca' => ' ',
                    'cor' => ' ',
                    'sexo' => ' ',
                    'imagem' => 'https://wallpapers.com/images/featured/tudo-branco-f9i0iegpvjn3oxtd.jpg',
                ],
                [
                    'tipo' => ' ',
                    'nome' => 'Teste',
                    'raca' => ' ',
                    'cor' => ' ',
                    'sexo' => ' ',
                    'imagem' => 'https://wallpapers.com/images/featured/tudo-branco-f9i0iegpvjn3oxtd.jpg',
                ],
                [
                    'tipo' => ' ',
                    'nome' => 'Teste',
                    'raca' => ' ',
                    'cor' => ' ',
                    'sexo' => ' ',
                    'imagem' => 'https://wallpapers.com/images/featured/tudo-branco-f9i0iegpvjn3oxtd.jpg',
                ],
                [
                    'tipo' => ' ',
                    'nome' => 'Teste',
                    'raca' => ' ',
                    'cor' => ' ',
                    'sexo' => ' ',
                    'imagem' => 'https://wallpapers.com/images/featured/tudo-branco-f9i0iegpvjn3oxtd.jpg',
                ],
            ];
        @endphp
        @foreach($animais as $animal)
        <div class="col s12 m3" style="height: 300px; margin-bottom: 50px;" >
            <div class="card">
                <div class="card-image">
                    <img height="175px"  src="{{ $animal['imagem'] }}">
                    
                    @if(!$animal['nome'])
                        <span style="font-size:20px;" class="card-title"><b>(Sem coleira)</b></span>
                    @endif
                    @if($animal['nome']=="Teste")
                        <span id="teste"class="card-title"><b><b>{{ $animal['nome'] }}</b></b></span>
                        @else
                        @if($animal['nome'])
                            <span class="card-title"><b>{{ $animal['nome'] }}</b></span>
                        @endif
                    @endif
                    <a id="ic" class="btn-floating halfway-fab" href="dae"><i id="ic" class="material-icons cyan">visibility</i></a>
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
    </div>--}}
        <x-listagem :animais="$animais" :info=0/>
@endsection