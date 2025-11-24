<?php

namespace App\Http\Controllers;

use App\Models\Animal;
use App\Models\Editados;
use App\Models\Usuario;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class EditadosController extends Controller
{
    /**
     * LISTAR TODOS OS CASOS EDITADOS PENDENTES
     */
    public function listarEditados()
    {
        Log::info("🎯 MÉTODO listarEditados CHAMADO");
        
        $editados = Editados::with(['animal.user', 'user'])
                          ->pendentes()
                          ->get();
        
        Log::info("🔍 Casos Editados Pendentes - Total: " . $editados->count());
        
        return view('site.casosEditados', compact('editados'));
    }

    /**
     * EXIBIR TELA DE DETALHES DA EDIÇÃO (GET)
     */
    public function detalhesEditado($id)
    {
        Log::info("🎯 MÉTODO detalhesEditado CHAMADO - Edição ID: {$id}");
        
        $editado = Editados::with(['animal.user', 'user'])
                         ->findOrFail($id);
        
        $animal = $editado->animal;

        Log::info("🔍 Detalhes Edição - Animal: {$animal->id}, Edição: {$editado->id}");

        return view('site.detalhesCE', compact('editado', 'animal'));
    }

    /**
     * PROCESSAR DETALHES (POST) - para compatibilidade
     */
    public function detalhesCE(Request $request)
    {
        $animal_id = $request->input('id');
        
        Log::info("🎯 MÉTODO detalhesCE CHAMADO - Animal ID: {$animal_id}");
        
        $editado = Editados::with(['animal.user', 'user'])
                         ->where('animal_id', $animal_id)
                         ->pendentes()
                         ->first();
        
        if (!$editado) {
            if ($request->wantsJson()) {
                return response()->json(['error' => 'Edição não encontrada'], 404);
            }
            return redirect()->route('editados.listar')->with('error', 'Edição não encontrada.');
        }
        
        $animal = $editado->animal;

        if ($request->wantsJson()) {
            return response()->json([
                'editado' => $editado,
                'animal' => $animal
            ]);
        }

        return view('site.detalhesCE', compact('editado', 'animal'));
    }

    /**
     * APROVAR EDIÇÃO
     */
    public function aprovar($id)
    {
        Log::info("🎯 MÉTODO aprovar CHAMADO - Edição ID: {$id}");
        
        try {
            $editado = Editados::with('animal')->findOrFail($id);
            
            if (!$editado->isPendente()) {
                Log::warning("⚠️ EDIÇÃO JÁ PROCESSADA - ID: {$id}");
                return redirect()->route('editados.listar')
                               ->with('error', 'Esta edição já foi processada.');
            }

            $animalAtualizado = $editado->aplicarEdicoes();

            Log::info("✅ EDIÇÃO APROVADA - ID: {$id}, Animal: {$animalAtualizado->id}");

            return redirect()->route('editados.listar')
                           ->with('success', 'Edição aprovada e aplicada com sucesso!');

        } catch (\Exception $e) {
            Log::error('❌ ERRO AO APROVAR EDIÇÃO: ' . $e->getMessage());
            
            return redirect()->back()
                           ->with('error', 'Erro ao aprovar edição: ' . $e->getMessage());
        }
    }

    /**
     * REJEITAR EDIÇÃO
     */
    public function rejeitar($id)
    {
        Log::info("🎯 MÉTODO rejeitar CHAMADO - Edição ID: {$id}");
        
        try {
            $editado = Editados::findOrFail($id);
            
            if (!$editado->isPendente()) {
                Log::warning("⚠️ EDIÇÃO JÁ PROCESSADA - ID: {$id}");
                return redirect()->route('editados.listar')
                               ->with('error', 'Esta edição já foi processada.');
            }

            $this->limparImagensTemporarias($editado);
            
            $editado->rejeitar();

            Log::info("❌ EDIÇÃO REJEITADA - ID: {$id}");

            return redirect()->route('editados.listar')
                           ->with('success', 'Edição rejeitada com sucesso!');

        } catch (\Exception $e) {
            Log::error('❌ ERRO AO REJEITAR EDIÇÃO: ' . $e->getMessage());
            
            return redirect()->back()
                           ->with('error', 'Erro ao rejeitar edição: ' . $e->getMessage());
        }
    }

    /**
     * LIMPAR IMAGENS TEMPORÁRIAS - ✅ CORRIGIDO: Tipo do parâmetro
     */
    private function limparImagensTemporarias(Editados $editado)
    {
        try {
            Log::info("🗑️ Limpando imagens temporárias - Edição ID: {$editado->id}");
            
            // Lista de campos de imagem no modelo
            $camposImagem = ['n_imagem1', 'n_imagem2', 'n_imagem3', 'n_imagem4'];
            
            foreach ($camposImagem as $campo) {
                if ($editado->$campo) {
                    $caminhoImagem = public_path($editado->$campo);
                    
                    // Verifica se o arquivo existe e não é a imagem padrão
                    if (file_exists($caminhoImagem) && !str_contains($editado->$campo, 'noimg.jpg')) {
                        File::delete($caminhoImagem);
                        Log::info("🗑️ Imagem removida: {$editado->$campo}");
                    }
                    
                    // Limpa o campo no banco de dados
                    $editado->$campo = null;
                }
            }
            
            $editado->save();
            Log::info("✅ Imagens temporárias limpas com sucesso - Edição ID: {$editado->id}");
            
        } catch (\Exception $e) {
            Log::error('❌ ERRO AO LIMPAR IMAGENS TEMPORÁRIAS: ' . $e->getMessage());
        }
    }

    /**
     * ✅ MÉTODOS PARA API (Flutter)
     */

    /**
     * Listar todas as edições (API)
     */
    public function index()
    {
        Log::info("🎯 MÉTODO index (API) CHAMADO");
        
        try {
            $editados = Editados::with(['animal.user', 'user'])
                              ->pendentes()
                              ->get();

            return response()->json([
                'status' => 'success',
                'data' => $editados
            ], 200);

        } catch (\Exception $e) {
            Log::error('❌ ERRO API Listar Edições: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Erro ao carregar lista de edições.'
            ], 500);
        }
    }

    /**
     * Salvar edição proposta (API) - ✅ CORRIGIDO: Validação flexível para imagens
     */
    public function store(Request $request)
    {
        Log::info("🎯 MÉTODO store (API) CHAMADO");
        Log::info("📦 Dados recebidos:", $request->all());
        Log::info("📸 Arquivos recebidos:", $request->file() ? array_keys($request->file()) : []);

        try {
            // ✅ VALIDAÇÃO FLEXÍVEL - ACEITA TANTO ARQUIVOS QUANTO STRINGS
            $validated = $request->validate([
                'animal_id' => 'required|exists:animais,id',
                'user_id' => 'required|exists:usuarios,id',
                'n_nome' => 'nullable|string|max:255',
                'n_raca' => 'nullable|string|max:255',
                'n_cor' => 'nullable|string|max:255',
                'n_especie' => 'nullable|string|in:Cachorro,Gato',
                'n_sexo' => 'nullable|string|in:Macho,Fêmea',
                'n_descricao' => 'nullable|string',
                'n_situacao' => 'nullable|string|in:perdido,encontrado',
                'n_cidade' => 'nullable|string|max:255',
                'n_bairro' => 'nullable|string|max:255',
                'n_ultimo_local_visto' => 'nullable|string|max:255',
                'n_endereco_desaparecimento' => 'nullable|string|max:255',
                'n_data_desaparecimento' => 'nullable|string|max:255',
                'n_local_encontro' => 'nullable|string|max:255',
                'n_endereco_encontro' => 'nullable|string|max:255',
                'n_data_encontro' => 'nullable|string|max:255',
                'n_situacao_saude' => 'nullable|string',
                'n_contato_responsavel' => 'nullable|string|max:255',
                // ✅ CORREÇÃO: VALIDAÇÃO FLEXÍVEL PARA IMAGENS
                'n_imagem1' => 'nullable',
                'n_imagem2' => 'nullable',
                'n_imagem3' => 'nullable', 
                'n_imagem4' => 'nullable',
            ]);

            $userId = $request->user_id;

            // Verificar se já existe edição pendente
            $edicaoExistente = Editados::where('animal_id', $request->animal_id)
                                    ->pendentes()
                                    ->first();

            if ($edicaoExistente) {
                Log::warning("⚠️ EDIÇÃO PENDENTE JÁ EXISTE - Animal: {$request->animal_id}");
                return response()->json([
                    'status' => 'error',
                    'message' => 'Já existe uma edição pendente para este animal.'
                ], 400);
            }

            // ✅ PREPARAR DADOS DA EDIÇÃO
            $dadosEdicao = [
                'animal_id' => $request->animal_id,
                'user_id' => $userId,
                'n_nome' => $request->n_nome,
                'n_raca' => $request->n_raca,
                'n_cor' => $request->n_cor,
                'n_especie' => $request->n_especie,
                'n_sexo' => $request->n_sexo,
                'n_descricao' => $request->n_descricao,
                'n_situacao' => $request->n_situacao,
                'n_cidade' => $request->n_cidade,
                'n_bairro' => $request->n_bairro,
                'n_ultimo_local_visto' => $request->n_ultimo_local_visto,
                'n_endereco_desaparecimento' => $request->n_endereco_desaparecimento,
                'n_data_desaparecimento' => $request->n_data_desaparecimento,
                'n_local_encontro' => $request->n_local_encontro,
                'n_endereco_encontro' => $request->n_endereco_encontro,
                'n_data_encontro' => $request->n_data_encontro,
                'n_situacao_saude' => $request->n_situacao_saude,
                'n_contato_responsavel' => $request->n_contato_responsavel,
                'status' => 'pendente',
            ];

            // ✅✅✅ CORREÇÃO CRÍTICA - PROCESSAMENTO FLEXÍVEL DE IMAGENS
            $camposImagem = ['n_imagem1', 'n_imagem2', 'n_imagem3', 'n_imagem4'];
            
            foreach ($camposImagem as $campo) {
                // Verifica se é um arquivo de imagem
                if ($request->hasFile($campo) && $request->file($campo)->isValid()) {
                    Log::info("📸 Processando {$campo} como ARQUIVO: " . $request->file($campo)->getClientOriginalName());
                    
                    // ✅ PROCESSAR UPLOAD DE IMAGEM NOVA
                    $imagem = $request->file($campo);
                    $nomeArquivo = 'editado_' . time() . '_' . uniqid() . '_' . $campo . '.' . $imagem->getClientOriginalExtension();
                    
                    // ✅ SALVAR NO DISCO 'public' 
                    $caminho = $imagem->storeAs('editados', $nomeArquivo, 'public');
                    
                    // ✅ URL PÚBLICA CORRETA
                    $urlPublica = asset('storage/editados/' . $nomeArquivo);
                    $dadosEdicao[$campo] = $urlPublica;
                    
                    Log::info("✅ Nova imagem salva: {$urlPublica}");
                    
                } else {
                    // ✅ É UMA STRING (imagem antiga ou vazia)
                    $valor = $request->$campo;
                    
                    if (is_string($valor) && !empty(trim($valor))) {
                        // ✅ MANTER IMAGEM ANTIGA
                        $dadosEdicao[$campo] = $valor;
                        Log::info("🖼️ Mantendo imagem antiga para {$campo}: {$valor}");
                    } else {
                        // ✅ STRING VAZIA - REMOVER IMAGEM
                        $dadosEdicao[$campo] = null;
                        Log::info("🗑️ Removendo imagem para {$campo}");
                    }
                }
            }

            Log::info("📦 Dados finais para criar edição:", $dadosEdicao);

            $editado = Editados::create($dadosEdicao);

            Log::info("✅ EDIÇÃO SALVA COM SUCESSO - ID: {$editado->id}, Animal: {$request->animal_id}, User: {$userId}");

            return response()->json([
                'status' => 'success',
                'message' => 'Edição enviada para aprovação com sucesso!',
                'data' => $editado
            ], 201);

        } catch (\Exception $e) {
            Log::error('❌ ERRO AO SALVAR EDIÇÃO: ' . $e->getMessage());
            Log::error('📝 Stack trace: ' . $e->getTraceAsString());

            return response()->json([
                'status' => 'error',
                'message' => 'Erro ao salvar edição: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Mostrar detalhes da edição (API)
     */
    public function show($id)
    {
        Log::info("🎯 MÉTODO show (API) CHAMADO - Edição ID: {$id}");
        
        try {
            $editado = Editados::with(['animal.user', 'user'])
                             ->findOrFail($id);

            return response()->json([
                'status' => 'success',
                'data' => $editado
            ], 200);

        } catch (\Exception $e) {
            Log::error('❌ ERRO AO BUSCAR EDIÇÃO: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Edição não encontrada.'
            ], 404);
        }
    }

    /**
     * Listar minhas edições (API)
     */
    public function minhasEdicoes()
    {
        Log::info("🎯 MÉTODO minhasEdicoes (API) CHAMADO");
        
        try {
            $editados = Editados::with(['animal'])
                              ->orderBy('created_at', 'desc')
                              ->get();

            return response()->json([
                'status' => 'success',
                'data' => $editados
            ], 200);

        } catch (\Exception $e) {
            Log::error('❌ ERRO AO BUSCAR MINHAS EDIÇÕES: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Erro ao carregar edições.'
            ], 500);
        }
    }

    /**
     * Aprovar edição via API
     */
    public function aprovarApi($id)
    {
        Log::info("🎯 MÉTODO aprovarApi CHAMADO - Edição ID: {$id}");
        
        try {
            $editado = Editados::with('animal')->findOrFail($id);
            
            if (!$editado->isPendente()) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Esta edição já foi processada.'
                ], 400);
            }

            $animalAtualizado = $editado->aplicarEdicoes();

            Log::info("✅ EDIÇÃO APROVADA VIA API - ID: {$id}");

            return response()->json([
                'status' => 'success',
                'message' => 'Edição aprovada com sucesso!',
                'data' => $animalAtualizado
            ], 200);

        } catch (\Exception $e) {
            Log::error('❌ ERRO AO APROVAR EDIÇÃO VIA API: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Erro ao aprovar edição: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Rejeitar edição via API
     */
    public function rejeitarApi($id)
    {
        Log::info("🎯 MÉTODO rejeitarApi CHAMADO - Edição ID: {$id}");
        
        try {
            $editado = Editados::findOrFail($id);
            
            if (!$editado->isPendente()) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Esta edição já foi processada.'
                ], 400);
            }

            $this->limparImagensTemporarias($editado);
            $editado->rejeitar();

            Log::info("❌ EDIÇÃO REJEITADA VIA API - ID: {$id}");

            return response()->json([
                'status' => 'success',
                'message' => 'Edição rejeitada com sucesso!'
            ], 200);

        } catch (\Exception $e) {
            Log::error('❌ ERRO AO REJEITAR EDIÇÃO VIA API: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Erro ao rejeitar edição: ' . $e->getMessage()
            ], 500);
        }
    }
}