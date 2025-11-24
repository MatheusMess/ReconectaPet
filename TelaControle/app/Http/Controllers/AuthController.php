<?php

namespace App\Http\Controllers;

use App\Models\Usuario;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Log;
use App\Mail\CodigoRecuperacaoMail;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Cache;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        Log::info('=== TENTATIVA DE CADASTRO ===');
        Log::info('Dados recebidos:', $request->all());

        $validator = Validator::make($request->all(), [
            'nome' => 'required|string|max:255',
            'email' => 'required|email|unique:usuarios,email',
            'tel' => 'required|string|max:20',
            'cpf' => 'required|string|max:14|unique:usuarios,cpf',
            'password' => 'required|min:6',
        ]);

        if ($validator->fails()) {
            Log::error('Validação falhou:', $validator->errors()->toArray());
            return response()->json([
                'success' => false,
                'message' => 'Dados inválidos',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            // ✅ GARANTIR que novo usuário não seja criado como banido
            $usuario = Usuario::create([
                'nome' => $request->nome,
                'email' => $request->email,
                'tel' => $request->tel,
                'cpf' => $request->cpf,
                'senha' => Hash::make($request->password),
                'adm' => false,
                'banido' => false, // ✅ SEMPRE false no cadastro
            ]);

            Log::info('Usuário cadastrado com sucesso:', [
                'id' => $usuario->id, 
                'email' => $usuario->email,
                'banido' => $usuario->banido
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Usuário cadastrado com sucesso',
                'user' => [
                    'id' => $usuario->id,
                    'nome' => $usuario->nome,
                    'email' => $usuario->email,
                    'tel' => $usuario->tel,
                    'cpf' => $usuario->cpf,
                    'banido' => $usuario->banido, // ✅ INCLUIR status de banimento
                ]
            ], 201);

        } catch (\Exception $e) {
            Log::error('Erro ao cadastrar usuário:', ['error' => $e->getMessage()]);
            return response()->json([
                'success' => false,
                'message' => 'Erro interno do servidor'
            ], 500);
        }
    }

    public function login(Request $request)
    {
        Log::info('=== TENTATIVA DE LOGIN ===');
        Log::info('Dados recebidos:', $request->all());

        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required',
        ]);

        if ($validator->fails()) {
            Log::error('Validação falhou:', $validator->errors()->toArray());
            return response()->json([
                'success' => false,
                'message' => 'Dados inválidos',
                'errors' => $validator->errors()
            ], 422);
        }

        $usuario = Usuario::where('email', $request->email)->first();

        if (!$usuario) {
            Log::warning('Usuário não encontrado para email: ' . $request->email);
            return response()->json([
                'success' => false,
                'message' => 'Credenciais inválidas'
            ], 401);
        }

        // ✅ VERIFICAÇÃO DE BANIMENTO - IMPEDIR LOGIN SE BANIDO
        if ($usuario->banido) {
            Log::warning('Tentativa de login de usuário banido:', [
                'email' => $usuario->email,
                'id' => $usuario->id
            ]);
            return response()->json([
                'success' => false,
                'message' => '🚫 ACESSO BLOQUEADO. Sua conta foi banida do sistema. Entre em contato com o suporte para mais informações.'
            ], 403); // 403 Forbidden
        }

        if (!Hash::check($request->password, $usuario->senha)) {
            Log::warning('Senha incorreta para usuário: ' . $usuario->email);
            return response()->json([
                'success' => false,
                'message' => 'Credenciais inválidas'
            ], 401);
        }

        Log::info('Login bem-sucedido para: ' . $usuario->email, [
            'banido' => $usuario->banido
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Login realizado com sucesso',
            'user' => [
                'id' => $usuario->id,
                'nome' => $usuario->nome,
                'email' => $usuario->email,
                'tel' => $usuario->tel,
                'cpf' => $usuario->cpf,
                'banido' => $usuario->banido, // ✅ INCLUIR status de banimento
            ]
        ]);
    }

    public function logout(Request $request)
    {
        Log::info('=== LOGOUT ===');
        return response()->json([
            'success' => true,
            'message' => 'Logout realizado com sucesso'
        ]);
    }

    public function checkEmail(Request $request)
    {
        Log::info('=== VERIFICAÇÃO DE EMAIL ===');
        Log::info('Email verificado:', ['email' => $request->email]);

        $exists = Usuario::where('email', $request->email)->exists();
        
        return response()->json([
            'exists' => $exists
        ]);
    }

    public function updateProfile(Request $request)
    {
        Log::info('=== ATUALIZAÇÃO DE PERFIL ===');
        Log::info('Dados recebidos:', $request->all());

        $validator = Validator::make($request->all(), [
            'nome' => 'sometimes|string|max:255',
            'tel' => 'sometimes|string|max:20',
        ]);

        if ($validator->fails()) {
            Log::error('Validação falhou:', $validator->errors()->toArray());
            return response()->json([
                'success' => false,
                'message' => 'Dados inválidos',
                'errors' => $validator->errors()
            ], 422);
        }

        // Para funcionar sem autenticação por enquanto
        if (!$request->has('user_id')) {
            return response()->json([
                'success' => false,
                'message' => 'ID do usuário é obrigatório'
            ], 400);
        }

        $usuario = Usuario::find($request->user_id);

        if (!$usuario) {
            return response()->json([
                'success' => false,
                'message' => 'Usuário não encontrado'
            ], 404);
        }

        // ✅ VERIFICAR SE USUÁRIO ESTÁ BANIDO ANTES DE ATUALIZAR
        if ($usuario->banido) {
            Log::warning('Tentativa de atualização de perfil de usuário banido:', [
                'user_id' => $usuario->id
            ]);
            return response()->json([
                'success' => false,
                'message' => '🚫 Conta banida. Não é possível atualizar o perfil.'
            ], 403);
        }

        $usuario->update($request->only(['nome', 'tel']));

        Log::info('Perfil atualizado com sucesso:', [
            'user_id' => $usuario->id,
            'banido' => $usuario->banido
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Perfil atualizado com sucesso',
            'user' => [
                'id' => $usuario->id,
                'nome' => $usuario->nome,
                'email' => $usuario->email,
                'tel' => $usuario->tel,
                'cpf' => $usuario->cpf,
                'banido' => $usuario->banido, // ✅ INCLUIR status de banimento
            ]
        ]);
    }

    public function getUser(Request $request)
    {
        Log::info('=== BUSCAR USUÁRIO ===');

        // Para funcionar sem autenticação por enquanto
        if (!$request->has('user_id')) {
            return response()->json([
                'success' => false,
                'message' => 'ID do usuário é obrigatório'
            ], 400);
        }

        $usuario = Usuario::find($request->user_id);

        if (!$usuario) {
            return response()->json([
                'success' => false,
                'message' => 'Usuário não encontrado'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'user' => [
                'id' => $usuario->id,
                'nome' => $usuario->nome,
                'email' => $usuario->email,
                'tel' => $usuario->tel,
                'cpf' => $usuario->cpf,
                'banido' => $usuario->banido, // ✅ INCLUIR status de banimento
            ]
        ]);
    }

    // ✅ MÉTODO: Verificar status da conta (para verificação em tempo real)
    public function checkAccountStatus(Request $request)
    {
        Log::info('=== VERIFICAÇÃO DE STATUS DA CONTA ===');

        if (!$request->has('user_id')) {
            return response()->json([
                'success' => false,
                'message' => 'ID do usuário é obrigatório'
            ], 400);
        }

        $usuario = Usuario::find($request->user_id);

        if (!$usuario) {
            return response()->json([
                'success' => false,
                'message' => 'Usuário não encontrado'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'user' => [
                'id' => $usuario->id,
                'nome' => $usuario->nome,
                'email' => $usuario->email,
                'tel' => $usuario->tel,
                'cpf' => $usuario->cpf,
                'banido' => $usuario->banido,
            ]
        ]);
    }

    // ========== MÉTODOS DE RECUPERAÇÃO DE SENHA COM CACHE REAL ==========

    /**
     * Solicitar recuperação de senha
     */
    public function solicitarRecuperacaoSenha(Request $request)
    {
        Log::info('=== SOLICITAÇÃO DE RECUPERAÇÃO DE SENHA ===');
        Log::info('Email solicitado:', ['email' => $request->email]);

        $validator = Validator::make($request->all(), [
            'email' => 'required|email|exists:usuarios,email',
        ]);

        if ($validator->fails()) {
            Log::error('Validação falhou:', $validator->errors()->toArray());
            return response()->json([
                'success' => false,
                'message' => 'Email não encontrado',
            ], 422);
        }

        try {
            $usuario = Usuario::where('email', $request->email)->first();

            // ✅ VERIFICAR SE USUÁRIO ESTÁ BANIDO
            if ($usuario->banido) {
                Log::warning('Tentativa de recuperação de senha de usuário banido:', [
                    'email' => $usuario->email
                ]);
                return response()->json([
                    'success' => false,
                    'message' => '🚫 Conta banida. Não é possível recuperar senha.'
                ], 403);
            }

            // ✅ GERAR CÓDIGO DE 6 DÍGITOS
            $codigo = str_pad(random_int(0, 999999), 6, '0', STR_PAD_LEFT);
            
            // ✅ SALVAR NO CACHE POR 15 MINUTOS (EXPIRA DE VERDADE)
            $chaveCache = "codigo_recuperacao_{$usuario->email}";
            Cache::put($chaveCache, [
                'codigo' => $codigo,
                'tentativas' => 0,
                'criado_em' => now()->toDateTimeString()
            ], now()->addMinutes(15)); // ⏰ 15 MINUTOS REAIS!
            
            Log::info('Código gerado e salvo no cache:', [
                'email' => $usuario->email,
                'codigo' => $codigo,
                'expira_em' => now()->addMinutes(15)->toDateTimeString()
            ]);

            // ✅ ENVIAR EMAIL COM O CÓDIGO
            Mail::to($usuario->email)->send(new CodigoRecuperacaoMail($codigo, $usuario->nome));

            Log::info('Email de recuperação enviado com sucesso para: ' . $usuario->email);

            return response()->json([
                'success' => true,
                'message' => 'Código de recuperação enviado para seu email. Expira em 15 minutos.',
                // 'codigo' => $codigo, // ⚠️ REMOVER EM PRODUÇÃO - só para testes
            ]);

        } catch (\Exception $e) {
            Log::error('Erro ao solicitar recuperação:', ['error' => $e->getMessage()]);
            return response()->json([
                'success' => false,
                'message' => 'Erro ao enviar email de recuperação'
            ], 500);
        }
    }

    /**
     * Verificar código de recuperação
     */
    public function verificarCodigoRecuperacao(Request $request)
    {
        Log::info('=== VERIFICAÇÃO DE CÓDIGO DE RECUPERAÇÃO ===');
        Log::info('Dados:', ['email' => $request->email, 'codigo' => $request->codigo]);

        $validator = Validator::make($request->all(), [
            'email' => 'required|email|exists:usuarios,email',
            'codigo' => 'required|string|size:6',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Dados inválidos',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $usuario = Usuario::where('email', $request->email)->first();
            $chaveCache = "codigo_recuperacao_{$usuario->email}";
            $dadosCodigo = Cache::get($chaveCache);

            // ✅ VERIFICAR SE CÓDIGO EXISTE NO CACHE
            if (!$dadosCodigo) {
                return response()->json([
                    'success' => false,
                    'message' => 'Código expirado ou não solicitado. Solicite um novo código.'
                ], 400);
            }

            // ✅ VERIFICAR SE CÓDIGO CONFERE
            if ($dadosCodigo['codigo'] !== $request->codigo) {
                // Incrementar tentativas
                $tentativas = $dadosCodigo['tentativas'] + 1;
                Cache::put($chaveCache, [
                    'codigo' => $dadosCodigo['codigo'],
                    'tentativas' => $tentativas,
                    'criado_em' => $dadosCodigo['criado_em']
                ], now()->addMinutes(15));
                
                if ($tentativas >= 3) {
                    Cache::forget($chaveCache); // 🔒 Bloqueia após 3 tentativas
                    return response()->json([
                        'success' => false,
                        'message' => 'Muitas tentativas incorretas. Código invalidado. Solicite um novo.'
                    ], 400);
                }
                
                return response()->json([
                    'success' => false,
                    'message' => 'Código incorreto. Tentativas restantes: ' . (3 - $tentativas)
                ], 400);
            }

            // ✅ Código válido - marcar como verificado no cache
            Cache::put("codigo_verificado_{$usuario->email}", true, now()->addMinutes(30));
            
            // ✅ Limpar código usado
            Cache::forget($chaveCache);

            Log::info('Código verificado com sucesso para: ' . $usuario->email);

            return response()->json([
                'success' => true,
                'message' => 'Código verificado com sucesso'
            ]);

        } catch (\Exception $e) {
            Log::error('Erro ao verificar código:', ['error' => $e->getMessage()]);
            return response()->json([
                'success' => false,
                'message' => 'Erro interno do servidor'
            ], 500);
        }
    }

    /**
     * Redefinir senha
     */
    public function redefinirSenha(Request $request)
    {
        Log::info('=== REDEFININDO SENHA ===');
        Log::info('Dados:', ['email' => $request->email]);

        $validator = Validator::make($request->all(), [
            'email' => 'required|email|exists:usuarios,email',
            'password' => 'required|min:6',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Dados inválidos',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $usuario = Usuario::where('email', $request->email)->first();
            $chaveVerificacao = "codigo_verificado_{$usuario->email}";
            
            // ✅ VERIFICAR SE CÓDIGO FOI VERIFICADO (no cache)
            if (!Cache::get($chaveVerificacao)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Código não verificado. Complete a verificação primeiro.'
                ], 400);
            }

            $usuario->senha = Hash::make($request->password);
            $usuario->save();

            // ✅ LIMPAR CACHE
            Cache::forget($chaveVerificacao);

            Log::info('Senha redefinida com sucesso para: ' . $usuario->email);

            return response()->json([
                'success' => true,
                'message' => 'Senha redefinida com sucesso'
            ]);

        } catch (\Exception $e) {
            Log::error('Erro ao redefinir senha:', ['error' => $e->getMessage()]);
            return response()->json([
                'success' => false,
                'message' => 'Erro interno do servidor'
            ], 500);
        }
    }

    /**
     * Método para testar o cache (opcional - para desenvolvimento)
     */
    public function debugCache(Request $request)
    {
        $email = $request->email;
        $chaveCache = "codigo_recuperacao_{$email}";
        $dados = Cache::get($chaveCache);
        
        return response()->json([
            'cache_key' => $chaveCache,
            'cache_data' => $dados,
            'exists' => !is_null($dados)
        ]);
    }
}