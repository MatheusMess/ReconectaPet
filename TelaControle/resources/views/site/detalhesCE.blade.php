@extends('site.layout')
@section('title','Detalhes')
@section('conteudo')
    <div style="display:flex; gap:20px; align-items:flex-start; flex-wrap:wrap;">
        <div style="flex:1; min-width:320px;">
            <h3 id="titulo">Antes</h3>
            <x-detalhes :animal="$animal" :editado="$editado" :caso="12" />
        </div>

        <div style="flex:1; min-width:320px;">
            <h3 id="titulo">Depois</h3>
            <x-detalhes :animal="$animal" :editado="$editado" :caso="13" />
        </div>
    </div>
@endsection