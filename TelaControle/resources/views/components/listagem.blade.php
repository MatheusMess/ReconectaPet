@props(['animais', 'info' => 1])

@php
    use Illuminate\Support\Str;
@endphp

<div class="row container pai">

    @foreach($animais as $animal)
    <div class="col s12 m3" style="height: 300px; margin-bottom: 180px;">
        <div class="card">

            {{-- IMAGEM --}}
            <div class="card-image">

                @php 
                    $images = $animal->imagens ?? [];
                    $img = $images[0] ?? null;

                    if (!$img || Str::contains($img, 'detalhes-do-animal')) {
                        $img = asset('images/animais/noimg.jpg');
                    }
                    elseif (!Str::startsWith($img, ['http://', 'https://'])) {
                        $img = asset($img);
                    }
                @endphp
                
                <img id="img" height="175px" 
                     src="{{ $img }}" 
                     alt="{{ $animal->nome ?? 'Animal' }}">

                @if(!$animal->nome)
                    <span style="font-size:20px;" class="card-title">
                        <b>(Sem nome)</b>
                    </span>
                @else
                    <span class="card-title">
                        <b>{{ $animal->nome }}</b>
                    </span>
                @endif

                {{-- DETALHES (GET) --}}
                <a href="{{ route('animal.detalhes.view', $animal->id) }}"
                   class="btn-floating halfway-fab waves-effect waves-light cyan">
                    <i class="material-icons">visibility</i>
                </a>

            </div>

            {{-- INFO --}}
            <div class="card-content">
                <ul class="info">

                    @if ($info === 1)
                        <li><b>Situação:</b> {{ $animal->situacao }}</li>
                        <li><b>Status:</b> {{ ucfirst($animal->status) }}</li>
                        <li><b>Animal:</b> {{ $animal->especie }}</li>
                        <li><b>Sexo:</b> {{ $animal->sexo }}</li>

                    @elseif ($info === 2)
                        <li><b>Animal:</b> {{ $animal->especie }}</li>
                        <li><b>Raça:</b> {{ $animal->raca }}</li>
                        <li><b>Sexo:</b> {{ $animal->sexo }}</li>
                        <li><b>Situação:</b> {{ $animal->situacao }}</li>

                    @else
                        <li><b>Animal:</b> {{ $animal->especie }}</li>
                        <li><b>Raça:</b> {{ $animal->raca }}</li>
                        <li><b>Sexo:</b> {{ $animal->sexo }}</li>
                        <li><b>Cor:</b> {{ $animal->cor }}</li>
                    @endif

                </ul>
            </div>

        </div>
    </div>
    @endforeach

</div>
