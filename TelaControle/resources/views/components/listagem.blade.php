<div class="row container">
    @foreach($animais as $animal)
    <div class="col s12 m3" style="height: 300px; margin-bottom: 180px;" >
        <div class="card">
            <div class="card-image">
                {{-- Usa a imagem do banco de dados --}}
                <img height="175px" src="{{ asset('images/animais/'.$animal['id'].'/imagem1.png') ?? asset('images/animais/noimg.jpg') }}" alt="{{ $animal['nome'] ?? 'Animal' }}">
                
                {{-- Lógica para exibir o nome ou "Sem coleira" --}}
                @if(!$animal->nome)
                    <span style="font-size:20px;" class="card-title"><b>b(Sem coleira)</b></span>
                @else
                    <span class="card-title"><b><b>{{ $animal->nome }}</b></b></span>
                @endif
                
                {{-- Formulário para o botão "Ver Detalhes" --}}
                <form action="{{ route('site.detalheAnimal') }}" method="POST" class="halfway-fab">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal->id }}">
                    <button id="ic" type="submit" class="btn-floating halfway-fab waves-effect waves-light cyan">
                        <i id="ic" class="material-icons">visibility</i>
                    </button>
                </form>
            </div>
            <div class="card-content">
                <ul class="info">
                    @if ($info === 1)
                        <li><b>Situação: </b>{{ $animal['situacao'] }}</li>
                        <li><b>Status: </b>{{ $animal['status'] }}</li>
                        <li><b>Animal: </b>{{ $animal['tipo'] }}</li>
                        <li><b>Sexo:   </b>{{ $animal['sexo'] }}</li>
                    @elseif ($info === 2)
                        <li><b>Animal: </b>{{ $animal->tipo }}</li>
                        <li><b>Raça:   </b>{{ $animal->raca }}</li>
                        <li><b>Sexo:   </b>{{ $animal->sexo }}</li>
                        <li><b>Situação: </b>{{ $animal['situacao'] }}</li>
                    @else
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