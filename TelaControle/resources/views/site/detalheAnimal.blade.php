@extends('site.layout')
@section('title','Detalhes')
@section('conteudo')
    <x-detalhes :animal="$animal" :caso="$caso"/>
@endsection