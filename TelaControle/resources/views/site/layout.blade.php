<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title') - ReconectaPet</title>
    <link rel="shortcut icon" type="image/x-icon" href="{{ asset('images/logoRP.png') }}">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Bungee&display=swap" rel="stylesheet">
    <style>
        /* Reset e configurações globais */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background-color: rgb(13, 147, 170);
            font-family: 'Roboto', sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Header/Navegação */
        .nav {
            background: linear-gradient(135deg, #245A7C 0%, #1a4059 100%);
            width: 100%;
            min-height: 120px;
            padding: 15px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            position: relative;
            z-index: 1000;
        }

        .logo-container {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        #logo {
            width: 80px;
            height: 80px;
            object-fit: cover;
            object-position: center;
            border-radius: 8px;
            transition: transform 0.3s ease;
        }

        #logo:hover {
            transform: scale(1.05);
        }

        #titulo {
            color: gold;
            -webkit-text-stroke: 1.5px rgb(211, 75, 104);
            font-family: 'Bungee', Impact, sans-serif;
            font-size: 2rem;
            text-decoration: none;
            text-align: center;
            transition: all 0.3s ease;
        }

        #titulo:hover {
            color: #ffd700;
            transform: scale(1.05);
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 10px;
            list-style: none;
            margin: 0;
            padding: 0;
        }

        .nav-links li {
            border-radius: 25px;
            transition: all 0.3s ease;
        }

        .nav-links li:not(:hover) {
            background-color: transparent;
        }

        .nav-links li:not(:hover) a {
            color: gold;
            background: rgba(255, 215, 0, 0.1);
            border: 2px solid gold;
        }

        .nav-links li:hover {
            background-color: gold;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 215, 0, 0.3);
        }

        .nav-links li:hover a {
            color: #245A7C;
            font-weight: bold;
        }

        .nav-links a {
            display: block;
            padding: 10px 20px;
            text-decoration: none;
            font-weight: 600;
            border-radius: 25px;
            transition: all 0.3s ease;
        }

        /* Conteúdo principal */
        .main-content {
            flex: 1;
            padding: 20px;
            max-width: 1400px;
            margin: 0 auto;
            width: 100%;
        }

        /* Footer opcional */
        .footer {
            background: #245A7C;
            color: white;
            text-align: center;
            padding: 20px;
            margin-top: auto;
        }

        /* ===== FONTE MENOR APENAS PARA PÁGINA DE USUÁRIOS ===== */
        body.pagina-usuarios {
            font-size: 13px;
        }

        body.pagina-usuarios .main-content {
            font-size: 0.9rem;
        }

        body.pagina-usuarios .card {
            font-size: 0.85rem;
        }

        body.pagina-usuarios .card-title {
            font-size: 1rem;
        }

        body.pagina-usuarios .btn {
            font-size: 0.8rem;
            padding: 6px 12px;
        }

        body.pagina-usuarios h2#titulo {
            font-size: 1.6rem;
        }

        /* Responsividade */
        @media (max-width: 992px) {
            .nav {
                min-height: 100px;
                padding: 12px 15px;
            }

            #logo {
                width: 70px;
                height: 70px;
            }

            #titulo {
                font-size: 1.7rem;
                -webkit-text-stroke: 1px rgb(211, 75, 104);
            }

            .nav-links a {
                padding: 8px 16px;
                font-size: 0.9rem;
            }

            /* Ajuste responsivo para usuários */
            body.pagina-usuarios {
                font-size: 12px;
            }
        }

        @media (max-width: 768px) {
            .nav {
                flex-direction: column;
                gap: 15px;
                min-height: auto;
                padding: 20px 15px;
            }

            .logo-container {
                justify-content: center;
                text-align: center;
            }

            #titulo {
                font-size: 1.5rem;
            }

            .nav-links {
                justify-content: center;
                flex-wrap: wrap;
            }

            .nav-links li {
                margin: 5px;
            }

            .main-content {
                padding: 15px;
            }

            /* Ajuste responsivo para usuários */
            body.pagina-usuarios h2#titulo {
                font-size: 1.4rem;
            }
        }

        @media (max-width: 480px) {
            .nav {
                padding: 15px 10px;
            }

            #logo {
                width: 60px;
                height: 60px;
            }

            #titulo {
                font-size: 1.3rem;
                -webkit-text-stroke: 0.8px rgb(211, 75, 104);
            }

            .nav-links {
                gap: 5px;
            }

            .nav-links a {
                padding: 6px 12px;
                font-size: 0.85rem;
            }

            .main-content {
                padding: 10px;
            }

            /* Ajuste responsivo para usuários */
            body.pagina-usuarios {
                font-size: 11px;
            }

            body.pagina-usuarios .btn {
                font-size: 0.75rem;
                padding: 5px 10px;
            }
        }

        /* Animações suaves */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .main-content > * {
            animation: fadeIn 0.6s ease-out;
        }

        /* Scroll suave */
        html {
            scroll-behavior: smooth;
        }

        /* Melhorias de acessibilidade */
        @media (prefers-reduced-motion: reduce) {
            * {
                animation-duration: 0.01ms !important;
                animation-iteration-count: 1 !important;
                transition-duration: 0.01ms !important;
            }
            
            html {
                scroll-behavior: auto;
            }
        }

        /* Focus visível para acessibilidade */
        a:focus-visible,
        button:focus-visible {
            outline: 3px solid #ffd700;
            outline-offset: 2px;
        }
        <style>
    /* ... (todo o CSS anterior que já existe) ... */

    /* ===== CORREÇÃO PARA VAZAMENTO DOS CARDS ===== */
    .card-fix {
        background: white;
        border-radius: 15px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        overflow: hidden;
        margin-bottom: 20px;
    }

    .card-fix .card-body {
        padding: 20px;
    }

    .card-fix .card-title {
        font-size: 1.2rem;
        font-weight: 600;
        color: #245A7C;
        margin-bottom: 15px;
        border-bottom: 2px solid #f0f0f0;
        padding-bottom: 10px;
    }

    .card-fix .list-unstyled {
        margin-bottom: 0;
    }

    .card-fix .list-unstyled li {
        margin-bottom: 8px;
        padding: 5px 0;
        border-bottom: 1px solid #f8f9fa;
        word-wrap: break-word;
        overflow-wrap: break-word;
    }

    .card-fix .list-unstyled li:last-child {
        border-bottom: none;
        margin-bottom: 0;
    }

    .card-fix .img-container {
        height: 200px;
        overflow: hidden;
        border-bottom: 2px solid #f8f9fa;
    }

    .card-fix .img-container img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        object-position: center;
    }

    .card-fix .btn-container {
        display: flex;
        gap: 10px;
        margin-top: 15px;
        flex-wrap: wrap;
    }

    .card-fix .btn-container .btn {
        flex: 1;
        min-width: 120px;
        border: none;
        border-radius: 25px;
        padding: 8px 20px;
        font-weight: 500;
        transition: all 0.3s ease;
    }

    .card-fix .btn-det {
        background: linear-gradient(135deg, #245A7C 0%, #1a4059 100%);
        color: white;
    }

    .card-fix .btn-ace {
        background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        color: white;
    }

    .card-fix .btn-rej {
        background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
        color: white;
    }

    .card-fix .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
    }

    /* Para página de usuários */
    body.pagina-usuarios .card-fix {
        font-size: 0.85rem;
    }

    body.pagina-usuarios .card-fix .card-title {
        font-size: 1rem;
    }

    body.pagina-usuarios .card-fix .btn {
        font-size: 0.8rem;
        padding: 6px 16px;
    }

    /* Responsividade */
    @media (max-width: 768px) {
        .card-fix .btn-container {
            flex-direction: column;
        }
        
        .card-fix .btn-container .btn {
            width: 100%;
        }
        
        .card-fix .img-container {
            height: 180px;
        }
    }
</style>
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
</head>
<body class="@if(request()->is('usuarios')) pagina-usuarios @endif">
    <header>
        <nav class="nav">
            <div class="logo-container">
                <img src="{{ asset('images/logoRP.png') }}" alt="Logo ReconectaPet" id="logo" class="hide-on-med-and-down">
                <a id="titulo" href="{{ url('/') }}" class="brand-logo">RECONECTAPET</a>
            </div>

            <ul class="nav-links">
                <li><a href="{{ url('/') }}"><b>Início</b></a></li>
                <li class="hide-on-med-and-down"><a href="{{ url('usuarios') }}"><b>Usuários</b></a></li>
            </ul>
        </nav>
    </header>

    <main class="main-content">
        @yield('conteudo')
    </main>

    {{-- Footer Opcional --}}
    {{-- <footer class="footer">
        <p>&copy; {{ date('Y') }} ReconectaPet. Todos os direitos reservados.</p>
    </footer> --}}

    <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
    
    <script>
        // Inicializar componentes do Materialize se necessário
        document.addEventListener('DOMContentLoaded', function() {
            // Inicializar tooltips, modais, etc. se estiver usando
            var elems = document.querySelectorAll('.tooltipped');
            M.Tooltip.init(elems);
        });

        // Adicionar classe de carregamento para animações
        document.body.classList.add('loaded');
    </script>
</body>
</html>