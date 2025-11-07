<div class="row container pai">
    @foreach($animais as $animal)
    <div class="col s12 m3" style="height: 300px; margin-bottom: 180px;" >
        <div class="card">
            <div class="card-image">
                {{-- Principal imagem do animal (imagem1) --}}
                <img id="img" height="175px" src="{{ file_exists(public_path('images/animais/'.$animal['id'].'/imagem1.png')) ? asset('images/animais/'.$animal['id'].'/imagem1.png') : asset('images/animais/noimg.jpg') }}"alt="{{ $animal['nome'] ?? 'Animal' }}">

                {{-- "Sem coleira" caso o animal seja registrado sem nome --}}
                @if(!$animal->nome)
                    <span style="font-size:20px;" class="card-title"><b>(Sem coleira)</b></span>
                @else
                    <span class="card-title"><b><b>{{ $animal->nome }}</b></b></span>
                @endif

                {{-- Ver Detalhes --}}
                <form action="{{ route('site.detalheAnimal') }}" method="POST" class="halfway-fab">
                    @csrf   {{-- Token de segurança obrigatório do Laravel --}}
                    <input type="hidden" name="id" value="{{ $animal->id }}">
                    <button id="ic" type="submit" class="btn-floating halfway-fab waves-effect waves-light cyan">
                        <i id="ic" class="material-icons">visibility</i>
                    </button>
                </form>
            </div>
            <div class="card-content">
                <ul class="info">
                    @if ($info === 1)    {{--Todos animais--}}
                        <li><b>Situação: </b>{{ $animal['situacao'] }}</li>
                        <li><b>Status: </b>{{ $animal['status'] }}</li>
                        <li><b>Animal: </b>{{ $animal['tipo'] }}</li>
                        <li><b>Sexo:   </b>{{ $animal['sexo'] }}</li>
                    @elseif ($info === 2){{--Mesmo status--}}
                        <li><b>Animal: </b>{{ $animal->tipo }}</li>
                        <li><b>Raça:   </b>{{ $animal->raca }}</li>
                        <li><b>Sexo:   </b>{{ $animal->sexo }}</li>
                        <li><b>Situação: </b>{{ $animal['situacao'] }}</li>
                    @else                {{--Mesma situação e status--}}
                        <li><b>Animal: </b>{{ $animal->tipo }}</li>
                        <li><b>Raça:   </b>{{ $animal->raca }}</li>
                        <li><b>Sexo:   </b>{{ $animal->sexo }}</li>
                        <li><b>Cor:    </b>{{ $animal->cor }}</li>
                    @endif
                </ul>
            </div>
        </div>
    </div>
    @endforeach
</div>
@include('components.css.CSSlistagem')
