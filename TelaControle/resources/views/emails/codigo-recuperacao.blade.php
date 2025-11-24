<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Código de Recuperação</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #ffffff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .header {
            text-align: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
            border-radius: 10px 10px 0 0;
            color: white;
        }
        .code {
            font-size: 32px;
            font-weight: bold;
            text-align: center;
            letter-spacing: 8px;
            background: #f8f9fa;
            padding: 20px;
            margin: 20px 0;
            border-radius: 8px;
            color: #333;
        }
        .footer {
            text-align: center;
            margin-top: 30px;
            color: #666;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🔐 Recuperação de Senha</h1>
        </div>
        
        <p>Olá{{ $nomeUsuario ? ', ' . $nomeUsuario : '' }}!</p>
        
        <p>Recebemos uma solicitação para redefinir sua senha no <strong>ReconectaPet</strong>.</p>
        
        <p>Use o código abaixo para continuar com a recuperação:</p>
        
        <div class="code">
            {{ $codigo }}
        </div>
        
        <p><strong>Este código expira em 15 minutos.</strong></p>
        
        <p>Se você não solicitou esta recuperação, ignore este email.</p>
        
        <div class="footer">
            <p>ReconectaPet - Encontrando seu pet perdido</p>
            <p>© {{ date('Y') }} ReconectaPet. Todos os direitos reservados.</p>
        </div>
    </div>
</body>
</html>