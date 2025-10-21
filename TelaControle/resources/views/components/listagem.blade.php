<div class="row container">
    @foreach($animais as $animal)
    <div class="col s12 m3" style="height: 300px; margin-bottom: 180px;" >
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
                    <button id="ic" type="submit" class="btn-floating halfway-fab waves-effect waves-light cyan">
                        <i id="ic" class="material-icons">visibility</i>
                    </button>
                </form>
            </div>
            <div class="card-content">
                <ul class="info">
                    @if ($todos)
                        <li><b>Situação: </b>{{ $animal['situacao'] }}</li>
                        <li><b>Status: </b>{{ $animal['status'] }}</li>
                        <li><b>Animal: </b>{{ $animal['tipo'] }}</li>
                        <li><b>Sexo:   </b>{{ $animal['sexo'] }}</li>
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
</style>
