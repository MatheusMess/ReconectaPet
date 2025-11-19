@extends('site.layout')
@section('title','Casos Editados')
@section('conteudo')
    <h2 class="mb-4" id="titulo">Casos Editados</h2>
    
    <div class="row container">
        @if($animais->count() > 0)
            @foreach($animais as $animal)
            <div class="col s12 m3" style="height: 300px; margin-bottom: 50px;">
                <div class="card">
                    <div class="card-image">
                        {{-- Usando imagem real do banco --}}
                        <img height="175px" src="{{ $animal->imagem1 ?: asset('images/animais/noimg.jpg') }}" alt="{{ $animal->nome ?? 'Animal' }}">
                        
                        @if(!$animal->nome)
                            <span style="font-size:20px;" class="card-title"><b>(Sem coleira)</b></span>
                        @else
                            <span class="card-title"><b>{{ $animal->nome }}</b></span>
                        @endif
                        
                        {{-- Form para ver detalhes --}}
                        <form action="{{ route('site.detalheAnimal') }}" method="POST" class="halfway-fab">
                            @csrf
                            <input type="hidden" name="id" value="{{ $animal->id }}">
                            <button type="submit" class="btn-floating halfway-fab waves-effect waves-light cyan">
                                <i class="material-icons">visibility</i>
                            </button>
                        </form>
                    </div>
                    <div class="card-content">
                        <ul class="info">
                            <li><b>Situação: </b>{{ $animal->situacao }}</li>
                            <li><b>Animal: </b>{{ $animal->tipo }}</li>
                            <li><b>Sexo: </b>{{ $animal->sexo }}</li>
                            <li><b>Status: </b>{{ $animal->status }}</li>
                        </ul>
                    </div>
                </div>
            </div>
            @endforeach
        @else
            <div class="col s12">
                <p class="center">Nenhum caso editado no momento.</p>
            </div>
        @endif
    </div>

    <style>
        img{
            width: 100%;
            height: 175px;
            object-fit: cover; 
            object-position: center; 
        }
        .card{
            height: 100%;
        }
        .info li {
            margin-bottom: 5px;
        }
    </style>
@endsection