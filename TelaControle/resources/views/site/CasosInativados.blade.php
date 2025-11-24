@extends('site.layout')
@section('title','Casos Inativados')
@section('conteudo')
    <h2 class="mb-4" id="titulo">Casos Inativados</h2>
    <x-listagem :animais="$animais" :info=2 />
@endsection