@extends('site.layout')
@section('title','Animais Perdidos')
@section('conteudo')
    <h3 class="center">Todos Animais</h3>
    <x-listagem :animais="$animais" :info=1/>
@endsection