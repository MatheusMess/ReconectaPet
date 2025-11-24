@extends('site.layout')
@section('title','Detalhes - Animal Perdido')
@section('conteudo')
    <h3 id="titulo">Novo Animal Perdido</h3>
    <x-detalhes :animal="$animal" :caso="7"/>
@endsection