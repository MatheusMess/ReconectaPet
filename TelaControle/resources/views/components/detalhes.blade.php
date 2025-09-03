<!--
    <div class="pai detalhes-pai">
    <div id="img" aria-hidden="true">
        <img src="{{ $animal['imagem1'] ?? asset('images/placeholder.png') }}" alt="{{ $animal['nome'] ?? 'Animal' }}">
        <img src="{{ $animal['imagem2'] ?? asset('images/placeholder.png') }}" alt="{{ $animal['nome'] ?? 'Animal' }}">
        <img src="{{ $animal['imagem3'] ?? asset('images/placeholder.png') }}" alt="{{ $animal['nome'] ?? 'Animal' }}">
        <img src="{{ $animal['imagem4'] ?? asset('images/placeholder.png') }}" alt="{{ $animal['nome'] ?? 'Animal' }}">
    </div>

    <div class="div2">
        <div id="detalhes">
            <h2 id="nome">{{ $animal['nome'] ?? '—' }}</h2>
            <ul>
                <li><strong>Tipo:</strong> {{ $animal['tipo'] ?? '—' }}</li>
                <li><strong>Raça:</strong> {{ $animal['raca'] ?? '—' }}</li>
                <li><strong>Cor:</strong> {{ $animal['cor'] ?? '—' }}</li>
                <li><strong>Sexo:</strong> {{ $animal['sexo'] ?? '—' }}</li>
                @if(!empty($animal['obs']))
                    <li><strong>Observações:</strong> {!! $animal['obs'] !!}</li>
                @endif
            </ul>
        </div>

        <div class="botoes-pai">
            @if($showResolveButtons)
                <form method="POST" action="{{ $animal['resolvido_url'] ?? '#' }}" class="botao" style="width:100%;">
                    @csrf
                    <button id="reso" class="btn-caso" >Aceitar</button>
                    <button id="aban" class="btn-caso" >Recusar </button>
                </form>
            @endif
        </div>
    </div>
</div>-->
    <div class="pai">
        <div id="img" class="white" style="border-radius: 50px">
            <div id="imgs">
                <img src="{{ $animal['imagem1'] ?? asset('images/placeholder.png') }}" alt="{{ $animal['nome'] ?? 'Animal' }}">
                <img src="{{ $animal['imagem2'] ?? asset('images/placeholder.png') }}" alt="{{ $animal['nome'] ?? 'Animal' }}">
                <img src="{{ $animal['imagem3'] ?? asset('images/placeholder.png') }}" alt="{{ $animal['nome'] ?? 'Animal' }}">
                <img src="{{ $animal['imagem4'] ?? asset('images/placeholder.png') }}" alt="{{ $animal['nome'] ?? 'Animal' }}">
            </div>
            <span id="nome" class="card-title">{{ $animal['nome']}}</span>
        </div>
        <div class="div2" >
            <div id="detalhes" class="white card-content" style="width: 100%;">
                <ul>
                    <li><b>Animal: </b>{{$animal['tipo']}}</li>
                    <li><b>Raça:   </b>{{$animal['raca']}}</li>
                    <li><b>Tamanho:</b>{{$animal['tam']}}</li>
                    <li><b>Sexo:   </b>{{$animal['sexo']}}</li>
                    <li><b>Cor:    </b>{{$animal['cor']}}</li>
                    <li><b>Detalhes da aparência:</b></li>
                    <p>{{$animal['aparencia']}}</p>
                    <li><b>Ultimo lugar visto:</b></li>
                    <p>{{$animal['ultimoLV']}}</p>
                </ul>
            </div>
            <div class="botao" >
                <button id="reso" class="btn-caso" >Aceitar</button>
                <button id="aban" class="btn-caso" >Recusar </button>
            </div>
        </div>
    </div>


<style>
    
    .pai{
        margin: 4%;
        background-color: aqua;
        width: 1050px;
        height: 650px;
        align-self: center;
        justify-self: center;
        border-radius: 50px;
        padding: 20px;
        display: flex;
        align-items: center;
        padding-left: 50px;
        margin-top: 20px;
    }
    img{
        margin: 10px;
        width: 150px;
        height: 150px;
        object-fit: cover; 
        object-position: center; 
        border-radius: 30px;
        display: inline-block;
        transition: width 0.3s, height 0.3s;
    }
    
    
    #detalhes{
        border-radius: 50px;
        width: 100%;
        height: 80%;
        align-items: center;
        display: flex;
        
        font-size: 20px;
        padding: 3%;
        margin-top: 20px;

    }
    #imgs{
        height: 60%;
        padding-top: 3%;
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        align-items: center;
        margin: 20px;
    }
    #img{
        width: 40%;
        height: 90%;
        align-items: center;
        justify-items: center;
        display: inline-block;
        flex-direction: column;
        font-size: 50px;
        
    }
    li{
        margin-top: 20px;
    }
    #nome{
        width: 100%;
        height: 20%;
        justify-content: center;
        align-self: center;
        margin-top: 10px;
        padding: 125px; 
    }
    .div2{
        height: 100%;
        width: 55%;
        display: flex;
        flex-direction: column;
        
        align-items: center;
        margin-left: 3%;
        margin-top: 20px;   
    }
    .botao{
        margin: 20px;
        width: 100%;
        display: flex; 
        justify-content: center;
        gap: 20px; 
    }
    #reso{
        background:rgba(0, 128, 0, 0.5);
    }
    #aban{
        background:rgba(255, 0, 0, 0.75);
    }
    #reso:hover{
        background: gold;
    }
    #aban:hover{
        background: gold;
    }
    .btn-caso{
        
        color:#333;
        border:none;
        border-radius:20px;
        padding:12px 32px;
        font-size:18px;
        font-weight:500;
        box-shadow:0 2px 8px rgba(0,0,0,0.08);
        cursor:pointer;
        transition:background 0.25s;
    }
    
</style>
