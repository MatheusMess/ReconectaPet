<?php

namespace App\Http\Controllers;

use App\Models\Usuario;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class UsuarioController extends Controller
{
    /**
     * Lista todos os usuários
     */
    public function listar()
    {
        $usuarios = Usuario::all();
        return view('site.listaUsuarios', ['usuarios' => $usuarios]);
    }

    /**
     * Mostra detalhes de um usuário específico (POST)
     */
    public function detalhes(Request $request)
    {
        $usuario = Usuario::findOrFail($request->id);
        return view('site.detalhesUsuario', compact('usuario'));
    }

    /**
     * Mostra detalhes de um usuário específico (GET)
     */
    public function viewDetalhes($id)
    {
        $usuario = Usuario::findOrFail($id);
        return view('site.detalhesUsuario', compact('usuario'));
    }

    /**
     * Banir usuário
     */
    public function banir(Request $request)
    {
        try {
            $usuario = Usuario::findOrFail($request->id);
            
            // ✅ USAR CAMPO 'banido' EM VEZ DE 'status'
            $usuario->banido = true;
            $usuario->save();

            Log::info("🚫 USUÁRIO BANIDO - ID: {$usuario->id} - Nome: {$usuario->nome}");

            return back()->with('success', 'Usuário banido com sucesso!');

        } catch (\Exception $e) {
            Log::error('❌ ERRO AO BANIR USUÁRIO: ' . $e->getMessage());
            return back()->with('error', 'Erro ao banir usuário.');
        }
    }

    /**
     * Desbanir usuário
     */
    public function desbanir(Request $request)
    {
        try {
            $usuario = Usuario::findOrFail($request->id);
            
            // ✅ USAR CAMPO 'banido' EM VEZ DE 'status'
            $usuario->banido = false;
            $usuario->save();

            Log::info("✅ USUÁRIO DESBANIDO - ID: {$usuario->id} - Nome: {$usuario->nome}");

            return back()->with('success', 'Usuário desbanido com sucesso!');

        } catch (\Exception $e) {
            Log::error('❌ ERRO AO DESBANIR USUÁRIO: ' . $e->getMessage());
            return back()->with('error', 'Erro ao desbanir usuário.');
        }
    }

    /**
     * Tornar usuário administrador
     */
    public function tornarAdmin(Request $request)
    {
        try {
            $usuario = Usuario::findOrFail($request->id);
            
            $usuario->adm = true;
            $usuario->save();

            Log::info("👑 USUÁRIO TORNADO ADMIN - ID: {$usuario->id} - Nome: {$usuario->nome}");

            return back()->with('success', 'Usuário promovido a administrador!');

        } catch (\Exception $e) {
            Log::error('❌ ERRO AO TORNAR ADMIN: ' . $e->getMessage());
            return back()->with('error', 'Erro ao promover usuário.');
        }
    }

    /**
     * Remover privilégios de administrador
     */
    public function removerAdmin(Request $request)
    {
        try {
            $usuario = Usuario::findOrFail($request->id);
            
            $usuario->adm = false;
            $usuario->save();

            Log::info("👤 ADMIN REMOVIDO - ID: {$usuario->id} - Nome: {$usuario->nome}");

            return back()->with('success', 'Privilégios de administrador removidos!');

        } catch (\Exception $e) {
            Log::error('❌ ERRO AO REMOVER ADMIN: ' . $e->getMessage());
            return back()->with('error', 'Erro ao remover privilégios.');
        }
    }

    /**
     * API - Listar usuários
     */
    public function apiListar()
    {
        try {
            $usuarios = Usuario::all();

            return response()->json([
                'status' => 'success',
                'message' => 'Lista de usuários carregada com sucesso.',
                'data' => $usuarios
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Erro ao carregar lista de usuários.',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * API - Buscar usuário por ID
     */
    public function apiShow($id)
    {
        $usuario = Usuario::find($id);

        if (!$usuario) {
            return response()->json([
                'status' => 'error',
                'message' => 'Usuário não encontrado.'
            ], 404);
        }

        return response()->json([
            'status' => 'success',
            'data' => $usuario
        ], 200);
    }
}