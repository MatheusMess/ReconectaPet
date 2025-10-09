
@extends('site.layout')
@section('title','Lista de Novos Animais')
@section('conteudo')
    <div class="container mt-4">
        <h2 class="mb-4">Novos Animais Encontrados Pendentes de Aprovação</h2>
        <div class="row">
            {{-- Verifica se a variável $animais existe e não está vazia --}}
            @if(isset($animais) && $animais->count() > 0)
                {{-- O componente <x-lista> agora recebe os dados e é o único responsável por exibi-los --}}
                <x-lista :animais="$animais" :showActions="true" />
            @else
                <div class="col">
                    <p class="text-center">Nenhum novo animal encontrado para aprovação no momento.</p>
                </div>
            @endif
        </div>
    </div>
@endsection