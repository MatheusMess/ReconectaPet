@extends('site.layout')
@section('title','Animais Encontrados')
@section('conteudo')
    <div class="container mt-4">
        <h2 class="mb-4" id="titulo">Novos Animais Encontrados</h2> {{-- Corrigido o título --}}
        <div class="row">
            @if($animais->count() > 0)
                <x-lista :informacoes="$animais" :showActions="true" />
            @else
                <div class="col">
                    <p class="text-center">Nenhum animal encontrado no momento.</p>
                </div>
            @endif
        </div>
    </div>
@endsection