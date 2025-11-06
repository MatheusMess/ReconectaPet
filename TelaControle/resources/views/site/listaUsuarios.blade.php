
@extends('site.layout')
@section('title','Animais Encontrados')
@section('conteudo')
    <div class="container mt-4">
        <h2 class="mb-4" id="titulo">Animais Encontrados</h2>
        <div class="row">
            @foreach($animais as $animal)
            <div  class="col-md-6 col-lg-4 mb-4">
                <div id="item" class="card h-100">
                    <div class="img"><img src="{{ file_exists(public_path('images/animais/'.$animal['id'].'/imagem1.png')) ? asset('images/animais/'.$animal['id'].'/imagem1.png') : asset('images/animais/noimg.jpg') }}" class="card-img-top" alt="Imagem do {{ $animal['tipo'] }}"></div>
                    <div class="card-body">
                        <h5 class="card-title">{{ $animal['nome'] }}</h5>
                        <ul class="list-unstyled mb-3">
                            <li><strong>Animal:</strong> {{ $animal['tipo'] }}</li>
                            <li><strong>Raça:</strong> {{ $animal['raca'] }}</li>
                            <li><strong>Cor:</strong> {{ $animal['cor'] }}</li>
                            <li><strong>Sexo:</strong> {{ $animal['sexo'] }}</li>
                        </ul>
                        <div id="btns" class="d-flex justify-content-between">

                            {{-- SUBSTITUA O LINK <a> POR ESTE FORMULÁRIO --}}
                            <form action="{{ route('site.DNEncontrados') }}" method="POST" style="display: inline;">
                                @csrf  {{-- Token de segurança obrigatório do Laravel --}}
                                <input type="hidden" name="id" value="{{ $animal['id'] }}">
                                <button id="det" type="submit" class="btn btn-primary">Ver Detalhes</button>
                            </form>

                            @if($showActions)
                                <button id="ace" class="btn btn-accept " data-id="{{ $animal['id'] ?? '' }}">Aceitar</button>
                                <button id="rej" class="btn btn-reject" data-id="{{ $animal['id'] ?? '' }}">Recusar</button>
                            @endif
                        </div>
                    </div>
                </div>
            </div>
        @endforeach

        @include('components.css.CSSlista')
        </div>
    </div>
@endsection
