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
        .pai2{
            margin: 4%;
            background-color: aqua;
            width: 1050px;
            height: 300px;
            align-self: center;
            justify-self: center;
            border-radius: 50px;
            padding: 3%;
            align-items: center;
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
        #txtM{
            width: 100%;
            height: 70%;
            font-size: 20px;
            padding: 2%;
        }
        li{
            margin-top: 20px;
        }
        #nome{
            height: 20%;
            align-self: flex-end;
            margin-top: 10px;
        }
        #motivo{
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
        #reativar{
            background:rgba(0, 128, 0, 0.5);
        }
        #reativar:hover{
            background:gold;
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
                <img src="https://cdn.shopify.com/s/files/1/0500/8965/6473/files/pexels-arina-krasnikova-7726295_480x480.jpg?v=1663249037">
                <img src="https://media.istockphoto.com/id/479483795/pt/foto/prateado-gato-malhado-pussy.jpg?s=170667a&w=0&k=20&c=1czp9zs7YlqGRlk-p1LaM--zWF9vNI5HjuDgPrrYYZI=">
                <img src="https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcSv4_S_4ZEVQE5fPCnWeaUHaYYsW3nmpYBlELXNE5XOUyE7Uhok">
                <img src="https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTX8aFA3Ef5nCoMdFOn829H85yOHhvUy0TzL8UK9sSNiCXhbhEZ">              
            </div>
            <span id="nome" class="card-title">Maya</span>
        </div>
        <div class="div2" >
            <div id="detalhes" class="white card-content" style="width: 100%;">
                <ul>
                    <li><b>Animal: </b>Gato</li>
                    <li><b>Raça:   </b>Vira-Lata</li>
                    <li><b>Tamanho:</b>Médio</li>
                    <li><b>Sexo:   </b>Fêmea</li>
                    <li><b>Cor:    </b>Tigrado Cinza</li>
                    <li><b>Detalhes da aparência:</b></li>
                    <p>Tem olhos amarelos quase verde e na parte do pescoço o pelo é branco</p>
                    <li><b>Ultimo lugar visto:</b></li>
                    <p>R. 30 de Fevereiro</p>
                </ul>
            </div>
            <div class="botao" >
                <button id="reativar" class="btn-caso" >Reativar Caso </button>
            </div>
        </div>
    </div>
    <div class="pai2">
        <span><h4>Motivo de abandono do caso:</h4></span>
        <div id="txtM" class="white" style="border-radius: 25px">
            <span id="motivo" class="card-title">Ela voltou para casa alguns minutos depois que foi adicionada como perdida</span>
        </div>
    </div>
@endsection