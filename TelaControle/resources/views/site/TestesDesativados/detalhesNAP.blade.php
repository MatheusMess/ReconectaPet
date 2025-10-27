@extends('site.layout')
@section('title','Detalhes')
@section('conteudo')
        @php
        $animal = [
            'nome' => 'Qiqi',
            'tipo' => 'Cachorro',
            'raca' => 'Pastor-Alemão',
            'cor' => 'Cinza',
            'sexo' => 'Fêmea',
            'tam' => 'Grande',
            'imagem1' => 'https://i.pinimg.com/474x/f2/9d/ba/f29dba2b270a670bc0f604692762cf91.jpg',
            'imagem2' => 'https://mega.ibxk.com.br/2018/11/08/gafanhoto-08120353817089.jpg?ims=fit-in/800x500',
            'imagem3' => 'https://i.redd.it/izj5qxtyjuze1.jpeg',
            'imagem4' => 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQPhKXN4cGJl2MCAsyIozhLZBAnyDIBmYszyE1GAHIBlLYylcjU',
            'aparencia' => 'Orelhas peludas, olhos azuis, parecido com um lobo',
            'LugarV' => 'Praça Dos Três Poderes',
            'LugarE' => ''
        ];
    @endphp
    <h3 class="center">Novo Animal Perdido</h3>
    <x-detalhes :animal="$animal" :caso="7"/>

@endsection