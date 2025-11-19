@extends('site.layout')
@section('title','Lista de Usuários') {{-- Corrigido o título --}}
@section('conteudo')
    <div class="container mt-4">
        <h2 class="mb-4" id="titulo">Usuários</h2> {{-- Corrigido o título --}}
        <div class="row">
            @if($usuarios->count() > 0)
                <x-lista :informacoes="$usuarios" :usuario="true" />
            @else
                <div class="col">
                    <p class="text-center">Nenhum usuário cadastrado.</p>
                </div>
            @endif
        </div>
    </div>
@endsection