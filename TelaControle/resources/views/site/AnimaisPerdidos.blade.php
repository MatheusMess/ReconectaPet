@extends('site.layout')
@section('title','Animais Perdidos')
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
                font-size: 19px;
                margin-left: 20px;
                margin-bottom: 20px;
            }
        }
        .card{
            height: 115%;
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
    <h3 class="center">Animais Perdidos</h3>
    <div class="row container">
        @php
            $animais = [
                [
                    'tipo' => 'Gato',
                    'nome' => 'Lua',
                    'raca' => 'Frajola',
                    'cor' => 'Branco e Preto',
                    'sexo' => 'Fêmea',
                    'imagem' => 'https://cdn.pixabay.com/photo/2020/04/27/23/52/black-cat-5102116_1280.jpg',
                ],
                [
                    'tipo' => 'Cachorro',
                    'nome' => 'Spike',
                    'raca' => 'Labrador',
                    'cor' => 'Marrom',
                    'sexo' => 'Macho',
                    'imagem' => 'https://adotar.com.br/upload/2023-04/animais_imagem979687.jpg?w=700&format=webp',
                ],
                [
                    'tipo' => 'Cacchorro',
                    'nome' => 'Laika',
                    'raca' => 'Vira-Lata',
                    'cor' => 'Preto/Branco',
                    'sexo' => 'Fêmea',
                    'imagem' => 'https://redacao.labmidia.com.br/wp-content/uploads/2024/09/raca-de-cachorro-para-fazenda-1.jpg',
                ],
                [
                    'tipo' => 'Cachorro',
                    'nome' => 'Shicha',
                    'raca' => 'dachshund',
                    'cor' => 'Preto',
                    'sexo' => 'Macho',
                    'imagem' => 'https://www.adoropets.com.br/wp-content/uploads/2018/04/dachshund-grama.jpg',
                ],
                [
                    'tipo' => ' ',
                    'nome' => 'Teste',
                    'raca' => ' ',
                    'cor' => ' ',
                    'sexo' => ' ',
                    'imagem' => 'https://wallpapers.com/images/featured/tudo-branco-f9i0iegpvjn3oxtd.jpg',
                ],[
                    'tipo' => ' ',
                    'nome' => 'Teste',
                    'raca' => ' ',
                    'cor' => ' ',
                    'sexo' => ' ',
                    'imagem' => 'https://wallpapers.com/images/featured/tudo-branco-f9i0iegpvjn3oxtd.jpg',
                ],[
                    'tipo' => ' ',
                    'nome' => 'Teste',
                    'raca' => ' ',
                    'cor' => ' ',
                    'sexo' => ' ',
                    'imagem' => 'https://wallpapers.com/images/featured/tudo-branco-f9i0iegpvjn3oxtd.jpg',
                ],[
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
        <div class="col s12 m3" style="height: 300px; margin-bottom: 80px;" >
            <div class="card">
                <div class="card-image">
                    <img height="200px"  src="{{ $animal['imagem'] }}">
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
                    <a class="btn-floating halfway-fab waves-effect waves-light red" href="dap"><i class="material-icons background-color: cyan">visibility</i></a>
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