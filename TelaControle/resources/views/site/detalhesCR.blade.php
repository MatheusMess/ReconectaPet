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
            margin-top: 15px;
        }
        #nome{
            height: 20%;
            align-self: flex-end;
            margin-top: 10px;
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
        #reativar{
            background:rgba(255, 0, 0, 0.75);
        }
        
        #reativar:hover{
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
                <img src="https://assets.brasildefato.com.br/2024/09/image_processing20210113-1654-11x5azn-750x533.jpeg">
                <img src="https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQ20-xvTBxtn2DUGCP5yMeum9c4mTjcxaBIcjJlNiAO79-ZLZer">
                <img src="https://fotos.amomeupet.org/uploads/fotos/1731164068_672f77a4e7588_hd.jpg">
                <img src="https://preview.redd.it/leo-the-beagle-v0-3dvjpseinazd1.jpg?width=640&crop=smart&auto=webp&s=f91bece5eef3db5592d70d64b174a6af3d5497ee">              
            </div>
            <span id="nome" class="card-title">Muttley</span>
        </div>
        <div class="div2" >
            <div id="detalhes" class="white card-content" style="width: 100%;">
                <ul>
                    <li><b>Animal: </b>Cacchorro</li>
                    <li><b>Raça:   </b>Vira-Lata</li>
                    <li><b>Tamanho:</b>Grande</li>
                    <li><b>Sexo:   </b>Macho</li>
                    <li><b>Cor:    </b>Caramelo</li>
                    <li><b>Detalhes da aparência:</b></li>
                    <p>Ele é magro e a cor da barriga é branco</p>
                    <li><b>Ultimo lugar visto:</b></li>
                    <p>Rua Exemplo da Silva</p>
                    <li><b>Lugar encontrado:</b></li>
                    <p>Rua Exemplo de Oliveira</p>
                </ul>
            </div>
            <div class="botao" >
                <button id="reativar" class="btn-caso" >Reativar Caso </button>
            </div>
        </div>
    </div>
@endsection