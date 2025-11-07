<!DOCTYPE html>
<html lang="pt-br">
    <head>
        <meta charset="UTF-8">
        <title>@yield('title')</title>
        <link rel="shortcut icon" type="image/x-icon" href="{{ asset('images/logoRP.png') }}"></link>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Bungee&display=swap" rel="stylesheet">
        <style>
            *{
                margin: 0px;

            }
            body{
                background-color: rgb(13, 147, 170);
            }
            .nav{
                background-color: #245A7C;
                width: 100%;
                height: 200px;
                align-items: center;
                display: flex;
                align-content: flex-end;
                justify-content: space-around;
                #titulo{
                    font-size: 40px;
                    alaign-self: center;
                    justify-self: center;
                }
                ul{
                    align-self: flex-end;
                    justify-self: end;
                    display: flex;
                    li{
                        border-radius: 30px;
                        margin: 10px;
                    }
                }
                li:not(:hover){
                    background-color: #245A7C;
                    a{
                        color: gold;
                    }
                    transition: 200ms;
                }
                li:hover{
                    background-color: gold;
                    a{
                        color: #245A7C;
                    }
                    transition: 200ms;
                }

            }


            #logo{
                border-radius: 0%;
                width: 125px;
                height: 125px;
                object-fit: cover;
                object-position: center;
            }
            @import url('https://fonts.googleapis.com/css2?family=Passion+One:wght@700&display=swap');
            #titulo{
                color: gold;
                -webkit-text-stroke: 1.5px rgb(211, 75, 104);
                font-family: 'Bungee', Impact, sans-serif;
                justify-self: center;
            }
            </style>
            <!-- background-color: deepskyblue; -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    </head>
    <body >
        <div class="nav" id="nav">
            <img src="{{ asset('images/logoRP.png') }}" alt="Logo ReconectaPet" height="100px" id="logo" class="hide-on-med-and-down">
            <a id="titulo" href="http://reconectapet.test/TelaControle/public/" class="brand-logo center titulonav">RECONECTAPET</a>

            <ul id="nav-mobile" class="right">
                <li><a href="http://reconectapet.test/TelaControle/public/" ><b>Início</b></a></li>
                <li class="hide-on-med-and-down"><a href="usuarios"><b>Usuários</b></a></li>
            </ul>
        </div>
        @yield('conteudo')

        <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
    </body>
</html>
