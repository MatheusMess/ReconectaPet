@extends('site.layout')
@section('title','Animais Perdidos')
@section('conteudo')
    <h3 class="center">Animais Perdidos</h3>
    <x-listagem :animais="$animais" :info=0/>
@endsection