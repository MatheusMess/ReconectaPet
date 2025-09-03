@extends('site.layout')
@section('title','Detalhes')
@section('conteudo')
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
    <div class="pai">
        <div id="img" class="white" style="border-radius: 50px">
            <div id="imgs">
                <img src="https://i.pinimg.com/474x/f2/9d/ba/f29dba2b270a670bc0f604692762cf91.jpg">
                <img src="https://cruzarcachorro.com.br/imagens/produto/1/2853.jpg">
                <img src="https://i.pinimg.com/736x/9c/67/38/9c6738bf74f94adf5ed0f9e4170cbf2d.jpg">
                <img src="https://adnchocolate.com.ar/wp-content/uploads/como-son-las-hembras-labrador.webp">              
            </div>
            <span id="nome" class="card-title">Qiqi</span>
        </div>
        <div class="div2" >
            <div id="detalhes" class="white card-content" style="width: 100%;">
                <ul>
                    <li><b>Animal: </b>Cacchorro</li>
                    <li><b>Raça:   </b>Pastor-Alemão</li>
                    <li><b>Tamanho:</b>Grande</li>
                    <li><b>Sexo:   </b>Fêmea</li>
                    <li><b>Cor:    </b>Cinza</li>
                    <li><b>Detalhes da aparência:</b></li>
                    <p>pelo marrom escuro quase preto, o focinho é mais claro que o pelo</p>
                    <li><b>Ultimo lugar visto:</b></li>
                    <p>Av. João Olímpio de Oliveira, Vila Asem, Itapetininga - SP</p>
                </ul>
            </div>
            <div class="botao" >
                <button id="reso" class="btn-caso" >Aceitar</button>
                <button id="aban" class="btn-caso" >Recusar </button>
            </div>
        </div>
    </div>
    @php
$animal = [
    'id' => 123,
    'tipo' => 'Gato',
    'nome' => 'Mimi',
    'raca' => 'Siamês',
    'cor' => 'Branco',
    'sexo' => 'Fêmea',
    'tam' => 'Grande',
    'imagem1' => 'https://i.pinimg.com/474x/f2/9d/ba/f29dba2b270a670bc0f604692762cf91.jpg',
    'imagem2' => 'https://i.pinimg.com/474x/f2/9d/ba/f29dba2b270a670bc0f604692762cf91.jpg',
    'imagem3' => 'https://i.pinimg.com/474x/f2/9d/ba/f29dba2b270a670bc0f604692762cf91.jpg',
    'imagem4' => 'https://i.pinimg.com/474x/f2/9d/ba/f29dba2b270a670bc0f604692762cf91.jpg',
    'aparencia' => 'Orelhas peludas, olhos azuis, parecido com um lobo',
    'ultimoLV' => 'Rua aleatória, 123 - Bairro Exemplo',
];
@endphp
    <x-detalhes :animal="$animal" :show-resolve-buttons="true" />
@endsection