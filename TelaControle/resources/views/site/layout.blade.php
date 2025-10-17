<!DOCTYPE html>
<html lang="pt-br">
    <head>
        <meta charset="UTF-8">
        <title>@yield('title')</title>
        <link rel="shortcut icon" type="image/x-icon" href="{{ asset('images/logoRP.ico') }}"></link>
        <style>
            *{
                margin: 0px;
                
            }
            body{
                background-color: rgb(13, 147, 170);
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
                li{
                    a{
                        color: gold;
                    }
                    a:hover{
                        color: #245A7C;
                    }
                }
                li:hover{
                    background-color: gold;
                    color: black
                }
                
            }
            #nav{
                width: 100%;
                height: 100%;
                background-color: #245A7C;
                a{
                    height: 100%;
                    align-self: top;
                    border-radius: 0%;
                }
            }
            
            #logo{
                border-radius: 0%;
                height: 125px;
                align-self: top;
            }
            </style>
            <!-- background-color: deepskyblue; -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    </head>
    <body >
        <nav class="nav">
            <div id="nav"class="nav-wrapper accent-2">
                <a href="#" class="brand-logo center"><!--<span class="black-text">Reconecta Pet</span>--> <img src="{{ asset('images/logo.jpg') }}" alt="Logo ReconectaPet" height="100px" id="logo"></a>
                <ul id="nav-mobile" class="right hide-on-med-and-down">
                    <li><a href="http://reconectapet.test/TelaControle/public/" ><b>Início</b></a></li>
                    <li><a href="ce"><b>Casos Editados</b></a></li>
                </ul>
            </div>
        </nav>
        @yield('conteudo')
        <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
    </body>
</html>
