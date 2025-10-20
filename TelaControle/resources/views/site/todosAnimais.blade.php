@extends('site.layout')
@section('title','Animais Perdidos')
@section('conteudo')
    <style>
        img{
            width: 150px;
            height: 250px;
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
            height: 440px;
            margin-top: 100px;
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
        #cardAnimal{
            margin-bottom: 190px;
        }
    </style>
    <h3 class="center">Animais Perdidos</h3>
    <div class="row container">
        @foreach($animais as $animal)
        <div id="cardAnimal" class="col s12 m3" style="height: 300px;" >
            <div class="card">
                <div class="card-image">
                    <img height="200px"  src="{{ $animal['imagem1'] }}">
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
                    <form action="{{ route('site.detalheAnimal') }}" method="POST">
                        @csrf
                        <input type="hidden" name="id" value="{{ $animal['id'] }}">
                        <button id="det" type="submit" class="btn-floating halfway-fab waves-effect waves-light cyan"><i class="material-icons background-color: cyan">visibility</i></button>
                    </form>
                </div>
                <div class="card-content">
                    <ul class="info">
                        <li><b>Situação: </b>{{ $animal['situacao'] }}</li>
                        <li><b>Status: </b>{{ $animal['status'] }}</li>
                        <li><b>Animal: </b>{{ $animal['tipo'] }}</li>
                        <li><b>Sexo:   </b>{{ $animal['sexo'] }}</li>
                    </ul>
                </div>
            </div>
        </div>
        @endforeach
    </div>
@endsection