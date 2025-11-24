@if($caso >=10)
    <style>
        /* estilos combinados (unificados dos dois blocos originais) */

        /* container principal */
        .pai{
            margin: 4%;
            background-color: rgb(16, 196, 228);
            width: 1050px;
            height: 650px;
            align-self: center;
            justify-self: center;
            border-radius: 50px;
            padding: 40px;
            display: flex;
            align-items: center;
            padding-left: 50px;
            margin-top: 20px;
            transform: scale(0.85);
            transform-origin: top center;
            transition: transform 180ms ease;
        }

        /* imagens */
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

        /* área de detalhes */
        #detalhes{
            border-radius: 50px;
            width: 100%;
            height: 80%;
            align-items: center;
            display: flex;

            font-size: 20px;
            padding: 3%;
            li{
                margin-top: 15px;
            }
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
            height: 100%;
            align-items: center;
            justify-items: center;
            display: inline-block;
            flex-direction: column;
            font-size: 50px;
            border-radius: 50px;
        }

        li{
            margin-top: 15px;
        }

        /* destaque vermelho / verde */
        .alterado1, .changed-before {
            background: rgba(255,0,0,0.18);
            border: 3px solid red;
        }
        .alterado2, .changed-after {
            background: rgba(0,128,0,0.18);
            border: 3px solid green;
        }

        /* layout secundário */
        .div2{
            width: 55%;
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-left: 3%;
            height: 100%;
        }

        .botao{
            margin: 20px;
            width: 100%;
            display: flex;
            justify-content: center;
            gap: 20px;
        }

        #reso{
            background:rgb(31, 151, 31)
        }
        #aban{
            background:rgb(206, 39, 39);
        }
        #reso:hover, #aban:hover{
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

        /* ajustes de responsividade (mantidos e combinados) */
        @media (max-width: 1600px) {
            .pai { transform: scale(0.7); }
        }
        @media (max-width: 1400px) {
            .pai { transform: scale(0.65); }
        }
        @media (max-width: 1300px) {
            .pai { transform: scale(0.60); }
            .pai { transform: none; flex-direction: column; align-items: stretch; }
        }
        @media (max-width: 1000px) {
            .pai { transform: scale(0.55); transform: none; flex-direction: column; align-items: stretch; }
        }

        /* regras alternativas para a versão sem "antes/depois" */
        .white { background: white; }

        .caso{
            margin-top: 0%;
            margin-left: 35px;
            font-size: 25px;
            justify-self: flex-start;
            padding-bottom: 20px
        }
        #caso{
            color: gold;
            -webkit-text-stroke: 1.2px rgb(0, 0, 0);

        }
        #nome{
            width: 100%;
            height: 30px;
            margin-top: 10px;
            margin-bottom: 0%;
            margin-left: 35px;
        }
        #snome{
            width: 100%;
            height: 50px;
            font-size: 30px;
            margin-left: 35px;
        }
    </style>
@else
    <style>

        .pai{
            margin: 4%;
            background-color: rgb(16, 196, 228);
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
            li{
                margin-top: 15px;
            }
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

        .caso{
            margin-top: 0%;
            margin-left: 35px;
            font-size: 25px;
            justify-self: flex-start;
            padding-bottom: 20px
        }
        #caso{
            color: gold;
            -webkit-text-stroke: 1.2px rgb(0, 0, 0);

        }
        #nome{
            width: 100%;
            height: 50px;
            margin-top: 10px;
            margin-bottom: 0%;
            margin-left: 35px;
        }
        #snome{
            width: 100%;
            height: 50px;
            font-size: 30px;
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
            background:rgb(31, 151, 31);
        }
        #aban{
            background:rgb(206, 39, 39);
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
@endif
