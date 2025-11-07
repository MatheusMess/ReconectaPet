
@extends('site.layout')
@section('title','Animais Encontrados')
@section('conteudo')
    <div class="container mt-4" id="titulo">
        <h2 class="mb-4" id="titulo">Novos Animais Perdidos</h2>
        <div class="row">
            {{-- Verifica se a coleção de animais não está vazia --}}
            @if($animais->count() > 0)
                {{-- Passa os dados recebidos do controller para o componente de lista --}}
                <x-lista :animais="$animais" :showActions="true" />
            @else
                <div class="col">
                    <p class="text-center">Nenhum animal encontrado no momento.</p>
                </div>
            @endif
        </div>
    </div>
@endsection
