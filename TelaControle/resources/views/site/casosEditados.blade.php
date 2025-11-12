@extends('site.layout')
@section('title','Lista')
@section('conteudo')
    <h2 class="mb-4" id="titulo">Casos Editados</h2>
    <x-listagem :animais="$animais" :info=3/>
@endsection
