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
<style>
    
    .img{
        object-fit: cover; 
        object-position: center; 
        height: 150px;
        width: 150px;
    }
    #item{
        display: flex;
        padding: 2%;
        border-radius: 100px;
        align-items: center;
        justify-items: center;
        ul{
            width: 100%;
            display: flex;
            justify-content: space-between;
        }
        li{
            width: 175px;
            font-size: 19px;
            margin-left: 20px;
            margin-bottom: 20px;
        }
    }
    .card{
        height: 440px;
        margin-top: 100px;
        margin: 10px;
        li{
            margin-top: 10px;
            dysplay: flex;
            align-items: center;
            width: 100%;
            justify-content: space-between;
        }
        img{
        width: 150px;
        height: 250px;
        object-fit: cover; 
        object-position: center; 
        border-radius: 100px;
    }
    }
    #teste{
        color: black;
    }
    #cardAnimal{
        margin-bottom: 200px;
    }
    #ic:hover{
        background-color: gold;
        transition: 0.2s;
    }
    #ic:not(:hover){
        transition: 0.2s;
    }

    /* Contorno escuro nas letras do nome (card-title) */
    .card-title {
        color: #fff; /* cor do texto */
        display: inline-block;
        font-weight: 700;
        -webkit-text-stroke: 1px rgba(0,0,0,0.88); /* contorno para WebKit */
        text-shadow:
            1px 1px 0 rgba(0,0,0,0.65),
            -1px -1px 0 rgba(0,0,0,0.65),
            1px -1px 0 rgba(0,0,0,0.65),
            -1px 1px 0 rgba(0,0,0,0.65); /* fallback para navegadores sem text-stroke */
        padding: 2px 6px;
        border-radius: 6px;
        -webkit-font-smoothing: antialiased;
        backface-visibility: hidden;
    }
</style>
