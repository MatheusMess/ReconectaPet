@extends('site.layout')
@section('title','Todos Animais')

@section('conteudo')

<h3 id="titulo" class="center">Todos Animais</h3>

@php
    $f = array_merge(
        [
            'status' => '',
            'situacao' => '',
            'especie' => '',
            'sexo' => '',
        ],
        $filters ?? []
    );
@endphp

<div class="filtro-wrapper">
    <form id="filtro" action="{{ route('todos.animais') }}" method="GET" class="row" style="margin-bottom:20px;">

        {{-- Situação --}}
        <div class="input-field col s12 m3 itens_filtro">
            <select name="situacao">
                <option value="" {{ $f['situacao']=='' ? 'selected' : '' }}>Todos</option>
                <option value="perdido" {{ $f['situacao']=='perdido' ? 'selected' : '' }}>Perdido</option>
                <option value="encontrado" {{ $f['situacao']=='encontrado' ? 'selected' : '' }}>Encontrado</option>
            </select>
            <label><b>Situação</b></label>
        </div>

        {{-- Status --}}
        <div class="input-field col s12 m3 itens_filtro">
            <select name="status">
                <option value="" {{ $f['status']=='' ? 'selected' : '' }}>Todos</option>
                <option value="ativo" {{ $f['status']=='ativo' ? 'selected' : '' }}>Ativo</option>
                <option value="pendente" {{ $f['status']=='pendente' ? 'selected' : '' }}>Pendente</option>
                <option value="inativo" {{ $f['status']=='inativo' ? 'selected' : '' }}>Inativo</option>
                <option value="resolvido" {{ $f['status']=='resolvido' ? 'selected' : '' }}>Resolvido</option>
                <option value="recusado" {{ $f['status']=='recusado' ? 'selected' : '' }}>Recusado</option>
            </select>
            <label><b>Status</b></label>
        </div>

        {{-- Espécie --}}
        <div class="input-field col s12 m3 itens_filtro">
            <select name="especie">
                <option value="" {{ $f['especie']=='' ? 'selected' : '' }}>Todos</option>
                <option value="Cachorro" {{ $f['especie']=='Cachorro' ? 'selected' : '' }}>Cachorro</option>
                <option value="Gato" {{ $f['especie']=='Gato' ? 'selected' : '' }}>Gato</option>
                <option value="Outro" {{ $f['especie']=='Outro' ? 'selected' : '' }}>Outro</option>
            </select>
            <label><b>Animal</b></label>
        </div>

        {{-- Sexo --}}
        <div class="input-field col s12 m2 itens_filtro">
            <select name="sexo">
                <option value="" {{ $f['sexo']=='' ? 'selected' : '' }}>Todos</option>
                <option value="Macho" {{ $f['sexo']=='Macho' ? 'selected' : '' }}>Macho</option>
                <option value="Fêmea" {{ $f['sexo']=='Fêmea' ? 'selected' : '' }}>Fêmea</option>
            </select>
            <label><b>Sexo</b></label>
        </div>

        {{-- Botões --}}
        <div class="col s12 m1" style="display:flex;align-items:center;">
            <button type="submit" class="btn">Filtrar</button>
        </div>

        <div class="col s12 m1" style="display:flex;align-items:center;">
            <a href="{{ route('todos.animais') }}" class="btn">Limpar</a>
        </div>

    </form>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        var elems = document.querySelectorAll('select');
        M.FormSelect.init(elems, { coverSelect: false, constrainWidth: false });
    });
</script>

@if (View::exists('components.listagem'))
    <x-listagem :animais="$animais" :info="1"/>
@else
    <div class="row container pai">
        @foreach($animais as $animal)
            @php
                $images = $animal->imagens ?? [];
                $img = $images[0] ?? null;
                if (!$img || Str::contains($img, 'detalhes-do-animal')) {
                    $img = asset('images/animais/noimg.jpg');
                } elseif (!Str::startsWith($img, ['http://','https://'])) {
                    $img = asset($img);
                }
            @endphp

            <div class="col s12 m3" style="height:300px;margin-bottom:180px;">
                <div class="card">
                    <div class="card-image">
                        <img height="175px" src="{{ $img }}" alt="{{ $animal->nome ?? 'Animal' }}">
                        <span class="card-title"><b>{{ $animal->nome ?? '(Sem nome)' }}</b></span>

                        <a href="{{ route('animal.detalhes.view', $animal->id) }}"
                           class="btn-floating halfway-fab waves-effect waves-light cyan">
                           <i class="material-icons">visibility</i>
                        </a>
                    </div>

                    <div class="card-content">
                        <ul class="info">
                            <li><b>Situação:</b> {{ $animal->situacao }}</li>
                            <li><b>Status:</b> {{ ucfirst($animal->status) }}</li>
                            <li><b>Animal:</b> {{ $animal->especie }}</li>
                            <li><b>Sexo:</b> {{ $animal->sexo }}</li>
                        </ul>
                    </div>
                </div>
            </div>
        @endforeach
    </div>
@endif

@endsection
