<div class="pai">
    <div id="img" class="white" style="border-radius: 50px">
        <div id="imgs">
            <img src="{{ $animal['imagem1'] ?? asset('images/placeholder.png') }}" alt="{{ $animal['nome'] ?? 'Animal' }}">
            <img src="{{ $animal['imagem2'] ?? asset('images/placeholder.png') }}" alt="{{ $animal['nome'] ?? 'Animal' }}">
            <img src="{{ $animal['imagem3'] ?? asset('images/placeholder.png') }}" alt="{{ $animal['nome'] ?? 'Animal' }}">
            <img src="{{ $animal['imagem4'] ?? asset('images/placeholder.png') }}" alt="{{ $animal['nome'] ?? 'Animal' }}">
        </div>
        @if(!$animal['nome'])
            <span id="snome" class="center">(Sem coleira)</span>
        @endif
        @if($animal['nome'])
            <span id="nome" class="center">{{ $animal['nome']}}</span>
        @endif
        
    </div>
    <!--
    caso [dap] = 1
    caso [dae] = 2
    caso [dcr] = 3
    caso [dca] = 4
    caso [dce]  = 5
    caso [dnae] = 6
    caso [dnap] = 7
    -->
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
                @switch($caso)
                    @case(1)
                        <li><b>Ultimo lugar visto:</b></li>
                        <p>{{$animal['LugarV']}}</p>
                        @break
                    @case(2)
                        <li><b>Lugar encontrado:</b></li>
                        <p>{{$animal['LugarE']}}</p>
                        @break
                    @case(3)
                        <li><b>Ultimo lugar visto:</b></li>
                        <p>{{$animal['LugarV']}}</p>
                        <li><b>Lugar encontrado:</b></li>
                        <p>{{$animal['LugarE']}}</p>
                        @break
                    @case(4)
                        <li><b>Ultimo lugar visto:</b></li>
                        <p>{{$animal['LugarV']}}</p>
                        <li><b>Lugar encontrado:</b></li>
                        <p>{{$animal['LugarE']}}</p>
                        @break
                    @case(5)
                        <li><b>Ultimo lugar visto:</b></li>
                        <p>{{$animal['LugarV']}}</p>
                        <li><b>Lugar encontrado:</b></li>
                        <p>{{$animal['LugarE']}}</p>
                        @break
                    @case(6)
                        <li><b>Lugar encontrado:</b></li>
                        <p>{{$animal['LugarE']}}</p>
                        @break
                    @case(7)
                        <li><b>Ultimo lugar visto:</b></li>
                        <p>{{$animal['LugarV']}}</p>
                        @break
                    @default
                @endswitch
            </ul>
        </div>
        <div class="botao" >
            @if($aceitar)
                <button id="reso" class="btn-caso" >Aceitar</button>
            @endif

            @if($recusar)
                <button id="aban" class="btn-caso" >Recusar</button>
            @endif
            
            @if($resolvido)
                <button id="reso" class="btn-caso" >Resolvido</button>
            @endif

            @if($abandonar)
                <button id="aban" class="btn-caso" >Abandonar</button>
            @endif

            @if($rcr)
                <button id="aban" class="btn-caso" >Reativar Caso</button>
            @endif

            @if($rca)
                <button id="reso" class="btn-caso" >Reativar Caso</button>
            @endif
            
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
        margin-top: 15px;
    }
    #nome{
        width: 100%;
        height: 20%;
        margin-top: 10px;
        padding: 30px;
    }
    #snome{
        width: 100%;
        height: 20%;
        font-size: 30px; 
        padding: 30px;
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
