@extends('site.layout')
@section('title','Animais Perdidos') {{-- Corrigido o título --}}
@section('conteudo')
    <div class="container mt-4" id="titulo">
        <h2 class="mb-4" id="titulo">Novos Animais Perdidos</h2>
        <div class="row">
            @if($animais->count() > 0)
                <x-lista :informacoes="$animais" :showActions="true" />
            @else
                <div class="col">
                    <p class="text-center">Nenhum animal perdido no momento.</p>
                </div>
            @endif
        </div>
    </div>
@endsection