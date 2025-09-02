<!DOCTYPE html>
<html lang="pt-br">
    <head>
        <meta charset="UTF-8">
        <title>@yield('title')</title>
        <link rel="shortcut icon" type="image/x-icon" href="../components/images/logoRP.ico"></link>
        <style>
            *{
                margin: 0px;
                
            }
            body{
                background-color: rgb(0, 170, 170);
            }
            .nav{
                width: 100%;
                height: 200px;
                align-content: center;
                display: flex-box;
                align-content: flex-end;
                div{
                    align-content:center;
                }
                ul{
                    align-self: flex-end;
                    justify-self: flex-end;
                }
                li:hover{
                    background-color: gold;
                }
            }
            #nav{
                width: 100%;
            }
        
        </style>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    </head>
    <body >
        <nav class="nav">
            <div id="nav"class="nav-wrapper cyan accent-2">
            <a href="#" class="brand-logo center"><span class="black-text">Reconecta Pet</span> </a>
            <ul id="nav-mobile" class="right hide-on-med-and-down">
                <li><a href="http://reconectpet.test/" class="black-text">Início</a></li>
                <li><a href="http://reconectpet.test/ap" class="black-text">Animais Perdidos</a></li>
                <li><a href="" class="black-text">Animais Encontrados</a></li>
                <li><a href="cr" class="black-text">Casos Resolvidos</a></li>
                <li><a href="ca" class="black-text">Casos Abandonados</a></li>
            </ul>
            </div>
        </nav>
        @yield('conteudo')
        <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
    </body>
</html>
