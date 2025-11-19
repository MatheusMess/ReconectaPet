@extends('site.layout')
@section('title','Detalhes do Animal')
@section('conteudo')
    <x-detalhes :animal="$animal" :caso="$caso"/>
@endsection