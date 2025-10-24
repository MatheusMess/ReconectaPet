@extends('site.layout')
@section('title','Animais Encontradosdos')
@section('conteudo')
    <x-listagem :animais="$animais" :info=0/>
@endsection