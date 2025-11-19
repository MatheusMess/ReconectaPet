@extends('site.layout')
@section('title','Animais Encontrados')
@section('conteudo')
    <h3 class="center" id="titulo">Animais Encontrados</h3>
    <x-listagem :animais="$animais" :info="0"/>
@endsection