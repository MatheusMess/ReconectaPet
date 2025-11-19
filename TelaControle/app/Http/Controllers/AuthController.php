<?php

namespace App\Http\Controllers;

use App\Models\Usuario;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Log;

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
            $usuario = Usuario::create([
                'nome' => $request->nome,
                'email' => $request->email,
                'tel' => $request->tel,
                'cpf' => $request->cpf,
                'senha' => Hash::make($request->password),
                'adm' => false,
            ]);

            Log::info('Usuário cadastrado com sucesso:', ['id' => $usuario->id, 'email' => $usuario->email]);

            return response()->json([
                'success' => true,
                'message' => 'Usuário cadastrado com sucesso',
                'user' => [
                    'id' => $usuario->id,
                    'nome' => $usuario->nome,
                    'email' => $usuario->email,
                    'tel' => $usuario->tel,
                    'cpf' => $usuario->cpf,
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

        if (!Hash::check($request->password, $usuario->senha)) {
            Log::warning('Senha incorreta para usuário: ' . $usuario->email);
            return response()->json([
                'success' => false,
                'message' => 'Credenciais inválidas'
            ], 401);
        }

        Log::info('Login bem-sucedido para: ' . $usuario->email);
        return response()->json([
            'success' => true,
            'message' => 'Login realizado com sucesso',
            'user' => [
                'id' => $usuario->id,
                'nome' => $usuario->nome,
                'email' => $usuario->email,
                'tel' => $usuario->tel,
                'cpf' => $usuario->cpf,
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

        $usuario->update($request->only(['nome', 'tel']));

        Log::info('Perfil atualizado com sucesso:', ['user_id' => $usuario->id]);

        return response()->json([
            'success' => true,
            'message' => 'Perfil atualizado com sucesso',
            'user' => [
                'id' => $usuario->id,
                'nome' => $usuario->nome,
                'email' => $usuario->email,
                'tel' => $usuario->tel,
                'cpf' => $usuario->cpf,
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
            ]
        ]);
    }
}