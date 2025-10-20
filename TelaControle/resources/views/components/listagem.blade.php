@foreach($animais as $animal)
<div class="col s12 m3" style="height: 300px; margin-bottom: 50px;" >
    <div class="card">
        <div class="card-image">
            {{-- Usa a imagem do banco de dados --}}
            <img height="175px" src="{{ $animal->imagem1 }}">
            
            {{-- Lógica para exibir o nome ou "Sem coleira" --}}
            @if(!$animal->nome)
                <span style="font-size:20px;" class="card-title"><b>(Sem coleira)</b></span>
            @else
                <span class="card-title"><b>{{ $animal->nome }}</b></span>
            @endif

            {{-- Formulário para o botão "Ver Detalhes" --}}
            <form action="{{ route('site.detalheAnimal') }}" method="POST" class="halfway-fab">
                @csrf
                <input type="hidden" name="id" value="{{ $animal->id }}">
                <button type="submit" class="btn-floating waves-effect waves-light cyan">
                    <i class="material-icons">visibility</i>
                </button>
            </form>
        </div>
        <div class="card-content">
            <ul class="info">
                {{-- Usa os dados do banco de dados --}}
                <li><b>Animal: </b>{{ $animal->tipo }}</li>
                <li><b>Raça:   </b>{{ $animal->raca }}</li>
                <li><b>Sexo:   </b>{{ $animal->sexo }}</li>
                <li><b>Cor:    </b>{{ $animal->cor }}</li>
            </ul>
        </div>
    </div>
</div>
@endforeach