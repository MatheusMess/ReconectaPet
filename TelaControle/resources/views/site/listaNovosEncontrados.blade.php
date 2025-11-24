@extends('site.layout')
@section('title','Novos Animais Encontrados')

@section('conteudo')
    <div class="container mt-4">
        <h2 class="mb-4">Novos Animais Encontrados - Aguardando Aprovação</h2>
        <div class="row">
            @if($animais->count() > 0)
                @if (View::exists('components.listagem'))
                    <x-listagem :animais="$animais" :usuario="false" :showActions="true"/>
                @else
                    {{-- Fallback caso o componente não exista --}}
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
                                        
                                        {{-- Botões de ação para aprovação --}}
                                        <div class="card-action">
                                            <form action="{{ route('animal.aceitar') }}" method="POST" style="display: inline;">
                                                @csrf
                                                <input type="hidden" name="id" value="{{ $animal->id }}">
                                                <button type="submit" class="btn green">Aceitar</button>
                                            </form>
                                            <form action="{{ route('animal.recusar') }}" method="POST" style="display: inline;">
                                                @csrf
                                                <input type="hidden" name="id" value="{{ $animal->id }}">
                                                <button type="submit" class="btn red">Recusar</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        @endforeach
                    </div>
                @endif
            @else
                <div class="col-12 text-center">
                    <p class="text-muted">Nenhum animal encontrado aguardando aprovação.</p>
                </div>
            @endif
        </div>
    </div>
@endsection