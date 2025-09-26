@php
    // calcula base de detalhes a partir do caminho atual transformando o primeiro segmento:
    // se o segmento tiver 2 ou menos chars -> prefixa 'd' (ex: 'cr' -> 'dcr')
    // se tiver >2 chars -> substitui o primeiro char por 'd' (ex: 'nae' -> 'dae')
        $urlDetalhes = url('d' . trim(request()->path(), '/'));
@endphp

@foreach($animais as $animal)
    <div  class="col-md-6 col-lg-4 mb-4">
        <div id="item" class="card h-100">
            <div class="img"><img src="{{ $animal['imagem'] }}" class="card-img-top" alt="Imagem do {{ $animal['tipo'] }}"></div>
            <div class="card-body">
                <h5 class="card-title">{{ $animal['nome'] }}</h5>
                <ul class="list-unstyled mb-3">
                    <li><strong>Animal:</strong> {{ $animal['tipo'] }}</li>
                    <li><strong>Raça:</strong> {{ $animal['raca'] }}</li>
                    <li><strong>Cor:</strong> {{ $animal['cor'] }}</li>
                    <li><strong>Sexo:</strong> {{ $animal['sexo'] }}</li>
                </ul>
                <div id="btns" class="d-flex justify-content-between">
                    
                    <a id="det" href="{{ $urlDetalhes }}" class="btn btn-info">Ver detalhes</a>
                    
                    @if($showActions)
                        <button id="ace" class="btn btn-accept " data-id="{{ $animal['id'] ?? '' }}">Aceitar</button>
                        <button id="rej" class="btn btn-reject" data-id="{{ $animal['id'] ?? '' }}">Recusar</button>
                    @endif
                </div>
            </div>
        </div>
    </div>
@endforeach

<style>
    img{
        width: 150px;
        height: 150px;
        object-fit: cover; 
        object-position: center; 
        border-radius: 100px;
    }
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
            width: 200px;
            font-size: 20px;
            margin-left: 30px;
            margin-bottom: 20px;
        }
    }
    #btnsbutton{
        button{
        background-color: rgb(16, 196, 228);}
    }
    #det{
        background-color: rgb(16, 196, 228);
    }
    #det:hover{
        background-color: gold;
        cursor: pointer;
    }  
    #ace{
        background-color: rgb(16, 196, 228);
    }
    #ace:hover{
        background:rgba(0, 128, 0);
        cursor: pointer;
    }  
    #rej{
        background-color: rgb(16, 196, 228);
    }
    #rej:hover{
        background:rgb(230, 38, 38);
        cursor: pointer;
    }
</style>
