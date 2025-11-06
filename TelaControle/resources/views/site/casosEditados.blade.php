
@extends('site.layout')
@section('title','Lista')
@section('conteudo')
        <h2 class="mb-4" id="titulo">Casos Editados</h2>
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
    {{-- @endcomponent--}}
    <div class="row container">
        @php
            $animais = [
                [
                    'tipo' => 'Cachorro',
                    'situacao' => 'Perdido',
                    'nome' => 'Luna',
                    'raca' => 'Akbash',
                    'cor' => 'Branco',
                    'sexo' => 'Fêmea',
                    'imagem' => 'https://cdn.pixabay.com/photo/2018/12/09/14/58/dog-3865029_1280.jpg',
                ],
                [
                    'tipo' => 'Cachorro',
                    'situacao' => 'Encontrado',
                    'nome' => 'Max',
                    'raca' => 'Labrador',
                    'cor' => 'Preto',
                    'sexo' => 'Macho',
                    'imagem' => 'https://cdn.los-animales.org/fotos/419836998_7902153-filhote-de-labrador-preto.jpg',
                ],
                [
                    'tipo' => 'Cachorro',
                    'situacao' => 'Perdido',
                    'nome' => 'Zeca',
                    'raca' => 'Beagle',
                    'cor' => 'Tricolor',
                    'sexo' => 'Macho',
                    'imagem' => 'https://love.doghero.com.br/wp-content/uploads/2016/10/Beagle-6-1024x768.jpg',
                ],
                [
                    'tipo' => 'Cachorro',
                    'situacao' => 'Encontrado',
                    'nome' => '',
                    'raca' => 'Labrador',
                    'cor' => 'Branco',
                    'sexo' => 'Fêmea',
                    'imagem' => 'https://cdn.jornaldaparaiba.com.br/wp-content/uploads/2024/01/racas-de-cachorro-labrador-retriever.jpg?xid=650493',
                ],
                [
                    'tipo' => ' ',
                    'situacao' => ' ',
                    'nome' => 'Teste',
                    'raca' => ' ',
                    'cor' => ' ',
                    'sexo' => ' ',
                    'imagem' => 'https://wallpapers.com/images/featured/tudo-branco-f9i0iegpvjn3oxtd.jpg',
                ],
                [
                    'tipo' => ' ',
                    'situacao' => ' ',
                    'nome' => 'Teste',
                    'raca' => ' ',
                    'cor' => ' ',
                    'sexo' => ' ',
                    'imagem' => 'https://wallpapers.com/images/featured/tudo-branco-f9i0iegpvjn3oxtd.jpg',
                ],
                [
                    'tipo' => ' ',
                    'situacao' => ' ',
                    'nome' => 'Teste',
                    'raca' => ' ',
                    'cor' => ' ',
                    'sexo' => ' ',
                    'imagem' => 'https://wallpapers.com/images/featured/tudo-branco-f9i0iegpvjn3oxtd.jpg',
                ],
                [
                    'tipo' => ' ',
                    'situacao' => ' ',
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
                    <a id="ic" class="btn-floating halfway-fab" href="dce"><i id="ic" class="material-icons cyan">visibility</i></a>
                </div>
                <div class="card-content">
                    <ul class="info">
                        <li><b>Situação: </b>{{ $animal['situacao'] }}</li>
                        <li><b>Animal: </b>{{ $animal['tipo'] }}</li>
                        <li><b>Sexo:   </b>{{ $animal['sexo'] }}</li>
                    </ul>
                </div>
            </div>
        </div>
        @endforeach
    </div>

@endsection