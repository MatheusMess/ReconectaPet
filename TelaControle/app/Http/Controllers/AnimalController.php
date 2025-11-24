<?php

namespace App\Http\Controllers;

use App\Models\Animal;
use App\Models\Usuario;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;

class AnimalController extends Controller
{
    // ===============================
    // LISTAGENS
    // ===============================

    public function listarPerdidos()
    {
        Log::info("🎯 MÉTODO listarPerdidos CHAMADO!");
        
        $animais = Animal::where('situacao', 'perdido')
                        ->where('status', 'ativo')
                        ->get();
        
        Log::info("🔍 Animais Perdidos - Total: " . $animais->count());
        foreach ($animais as $animal) {
            Log::info("🐕 Perdido: {$animal->id} - {$animal->nome} - Status: {$animal->status}");
        }
        
        return view('site.AnimaisPerdidos', compact('animais'));
    }

    public function listarEncontrados()
    {
        Log::info("🎯 MÉTODO listarEncontrados CHAMADO!");
        
        $animais = Animal::where('situacao', 'encontrado')
                        ->where('status', 'ativo')
                        ->get();
        
        Log::info("🔍 Animais Encontrados - Total: " . $animais->count());
        foreach ($animais as $animal) {
            Log::info("🐕 Encontrado: {$animal->id} - {$animal->nome} - Status: {$animal->status}");
        }
        
        return view('site.AnimaisEncontrados', compact('animais'));
    }

    public function listarNPerdidos()
    {
        Log::info("🎯 MÉTODO listarNPerdidos CHAMADO!");
        
        $animais = Animal::where('situacao', 'perdido')
                        ->where('status', 'pendente')
                        ->get();
        
        Log::info("🔍 Novos Perdidos - Total: " . $animais->count());
        
        return view('site.listaNovosPerdidos', compact('animais'));
    }

    public function listarNEncontrados()
    {
        Log::info("🎯 MÉTODO listarNEncontrados CHAMADO!");
        
        $animais = Animal::where('situacao', 'encontrado')
                        ->where('status', 'pendente')
                        ->get();
        
        Log::info("🔍 Novos Encontrados - Total: " . $animais->count());
        
        return view('site.listaNovosEncontrados', compact('animais'));
    }

    public function listarResolvidos()
    {
        Log::info("🎯 MÉTODO listarResolvidos CHAMADO!");
        
        $animais = Animal::where('status', 'resolvido')->get();
        
        Log::info("🔍 Casos Resolvidos - Total: " . $animais->count());
        
        return view('site.casosResolvidos', compact('animais'));
    }

    public function listarInativados()
    {
        Log::info("🎯 MÉTODO listarInativados CHAMADO!");
        
        $animais = Animal::where('status', 'inativo')->get();
        
        Log::info("🔍 Casos Inativados - Total: " . $animais->count());
        
        return view('site.CasosInativados', compact('animais'));
    }

    public function listarEditados()
    {
        Log::info("🎯 MÉTODO listarEditados CHAMADO!");
        
        $animais = Animal::whereIn('id', function($query) {
            $query->select('animal_id')
                  ->from('editados');
        })->get();

        Log::info("🔍 Casos Editados - Total: " . $animais->count());

        return view('site.casosEditados', compact('animais'));
    }

    // ===============================
    // TODOS ANIMAIS (COM FILTROS)
    // ===============================

    public function todosAnimais(Request $request)
    {
        Log::info("🎯 MÉTODO todosAnimais CHAMADO!");
        Log::info("📋 Filtros recebidos:", $request->all());

        $query = Animal::query();

        // aplica filtros
        if ($request->filled('situacao')) {
            $query->where('situacao', $request->situacao);
        }
        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }
        if ($request->filled('especie')) {
            $query->where('especie', $request->especie);
        }
        if ($request->filled('sexo')) {
            $query->where('sexo', $request->sexo);
        }

        $animais = $query->get();

        Log::info("🔍 Todos Animais - Total: " . $animais->count());

        return view('site.todosAnimais', [
            'animais' => $animais,
            'filters' => $request->all()
        ]);
    }

    // ===============================
    // DETALHES GET
    // ===============================

    public function viewDetalhe($id)
    {
        Log::info("🎯 MÉTODO viewDetalhe CHAMADO - ID: {$id}");
        
        $animal = Animal::findOrFail($id);
        $caso = $this->calcularCaso($animal);

        Log::info("🔍 Detalhe Animal - ID: {$animal->id} - Nome: {$animal->nome}");

        return view('site.detalheAnimal', compact('animal', 'caso'));
    }

    public function viewDNEncontrados($id)
    {
        Log::info("🎯 MÉTODO viewDNEncontrados CHAMADO - ID: {$id}");
        
        $animal = Animal::findOrFail($id);
        $caso = 6;
        
        return view('site.DetalhesNovosEncontrados', compact('animal', 'caso'));
    }

    public function viewDNPerdidos($id)
    {
        Log::info("🎯 MÉTODO viewDNPerdidos CHAMADO - ID: {$id}");
        
        $animal = Animal::findOrFail($id);
        $caso = 7;
        
        return view('site.DetalhesNovosPerdidos', compact('animal', 'caso'));
    }

    // ===============================
    // DETALHES (POST) - MANTIDOS PARA COMPATIBILIDADE
    // ===============================

    public function DetalheAnimal(Request $request)
    {
        Log::info("🎯 MÉTODO DetalheAnimal CHAMADO - ID: {$request->id}");
        
        $animal = Animal::findOrFail($request->id);
        $caso = $this->calcularCaso($animal);
        
        // ✅ REDIRECIONAR para a rota GET após processar
        return redirect()->route('animal.detalhes.view', ['id' => $request->id])
                       ->with('animal', $animal)
                       ->with('caso', $caso);
    }

    public function DNEncontrados(Request $request)
    {
        Log::info("🎯 MÉTODO DNEncontrados CHAMADO - ID: {$request->id}");
        
        $animal = Animal::findOrFail($request->id);
        $caso = 6;
        
        // ✅ REDIRECIONAR para a rota GET após processar
        return redirect()->route('site.DNEncontrados.view', ['id' => $request->id])
                       ->with('animal', $animal)
                       ->with('caso', $caso);
    }

    public function DNPerdidos(Request $request)
    {
        Log::info("🎯 MÉTODO DNPerdidos CHAMADO - ID: {$request->id}");
        
        $animal = Animal::findOrFail($request->id);
        $caso = 7;
        
        // ✅ REDIRECIONAR para a rota GET após processar
        return redirect()->route('site.DNPerdidos.view', ['id' => $request->id])
                       ->with('animal', $animal)
                       ->with('caso', $caso);
    }

    public function detalhesCE(Request $request)
    {
        Log::info("🎯 MÉTODO detalhesCE CHAMADO - ID: {$request->id}");
        
        $animal = Animal::findOrFail($request->id);
        
        // ✅ REDIRECIONAR para a rota GET após processar
        return redirect()->route('detalhes.ce.view', ['id' => $request->id])
                       ->with('animal', $animal);
    }

    // ===============================
    // AÇÕES SOBRE CASOS - CORRIGIDOS
    // ===============================

    public function aceitar(Request $request)
    {
        Log::info("🎯 MÉTODO aceitar CHAMADO - ID: {$request->id}");
        
        $animal = Animal::findOrFail($request->id);
        
        Log::info("✅ ACEITANDO ANIMAL - ID: {$animal->id}, STATUS ANTIGO: {$animal->status}");
        
        $animal->status = 'ativo';
        $animal->save();
        
        $animal->refresh();
        Log::info("✅ ANIMAL ACEITO - ID: {$animal->id}, STATUS NOVO: {$animal->status}");
        
        // ✅ REDIRECIONAR para página anterior específica
        return $this->redirecionarAposAcao($request, 'Caso aceito com sucesso!');
    }

    public function recusar(Request $request)
    {
        Log::info("🎯 MÉTODO recusar CHAMADO - ID: {$request->id}");
        
        $animal = Animal::findOrFail($request->id);
        $animal->status = 'recusado';
        $animal->save();

        Log::info("❌ ANIMAL RECUSADO - ID: {$animal->id}");

        // ✅ REDIRECIONAR para página anterior específica
        return $this->redirecionarAposAcao($request, 'Caso recusado com sucesso!');
    }

    public function resolver(Request $request)
    {
        Log::info("🎯 MÉTODO resolver CHAMADO - ID: {$request->id}");
        
        $animal = Animal::findOrFail($request->id);
        $animal->status = 'resolvido';
        $animal->save();

        Log::info("✅ CASO RESOLVIDO - ID: {$animal->id}");

        // ✅ REDIRECIONAR para página anterior específica
        return $this->redirecionarAposAcao($request, 'Caso resolvido com sucesso!');
    }

    public function inativar(Request $request)
    {
        Log::info("🎯 MÉTODO inativar CHAMADO - ID: {$request->id}");
        
        $animal = Animal::findOrFail($request->id);
        $animal->status = 'inativo';
        $animal->save();

        Log::info("⏸️ CASO INATIVADO - ID: {$animal->id}");

        // ✅ REDIRECIONAR para página anterior específica
        return $this->redirecionarAposAcao($request, 'Caso inativado com sucesso!');
    }

    public function reativar(Request $request)
    {
        Log::info("🎯 MÉTODO reativar CHAMADO - ID: {$request->id}");
        
        $animal = Animal::findOrFail($request->id);
        $animal->status = 'ativo';
        $animal->save();

        Log::info("🔄 CASO REATIVADO - ID: {$animal->id}");

        // ✅ REDIRECIONAR para página anterior específica
        return $this->redirecionarAposAcao($request, 'Caso reativado com sucesso!');
    }

    // ===============================
    // AUXILIAR
    // ===============================

    private function calcularCaso(Animal $animal)
    {
        $caso = 0;
        
        if ($animal->situacao == 'perdido') {
            if ($animal->status == 'ativo') $caso = 1;
            if ($animal->status == 'pendente') $caso = 7;
            if ($animal->status == 'resolvido') $caso = 3;
            if ($animal->status == 'inativo') $caso = 4;
        }

        if ($animal->situacao == 'encontrado') {
            if ($animal->status == 'ativo') $caso = 2;
            if ($animal->status == 'pendente') $caso = 6;
            if ($animal->status == 'resolvido') $caso = 3;
            if ($animal->status == 'inativo') $caso = 4;
        }

        Log::info("🔢 Calculando caso - Animal: {$animal->id}, Situação: {$animal->situacao}, Status: {$animal->status} -> Caso: {$caso}");

        return $caso;
    }

    /**
     * Redireciona para a página correta após uma ação
     */
    private function redirecionarAposAcao(Request $request, $mensagemSucesso)
    {
        // Verifica de qual página veio a requisição
        $paginaAnterior = url()->previous();
        
        // Se veio de uma página de detalhes, redireciona para a lista correspondente
        if (str_contains($paginaAnterior, 'detalhes-do-animal') || 
            str_contains($paginaAnterior, 'dn-animais') ||
            str_contains($paginaAnterior, 'detalhes-ce')) {
            
            // Extrai informações da URL anterior para determinar para onde redirecionar
            if (str_contains($paginaAnterior, 'perdidos')) {
                return redirect()->route('site.listaNPerdidos')->with('success', $mensagemSucesso);
            } elseif (str_contains($paginaAnterior, 'encontrados')) {
                return redirect()->route('site.listaNEncontrados')->with('success', $mensagemSucesso);
            } elseif (str_contains($paginaAnterior, 'casos-resolvidos')) {
                return redirect()->route('CasosResolvidos')->with('success', $mensagemSucesso);
            } elseif (str_contains($paginaAnterior, 'casos-inativados')) {
                return redirect()->route('CasosInativados')->with('success', $mensagemSucesso);
            } elseif (str_contains($paginaAnterior, 'casos-editados')) {
                return redirect()->route('CasosEditados')->with('success', $mensagemSucesso);
            } else {
                // Redireciona padrão para todos os animais
                return redirect()->route('todos.animais')->with('success', $mensagemSucesso);
            }
        }
        
        // Redireciona para a página anterior com mensagem de sucesso
        return redirect()->back()->with('success', $mensagemSucesso);
    }

    // ===============================
    // API - MÉTODOS CORRIGIDOS
    // ===============================

    /**
     * ✅ API: Listar todos animais (para Flutter) - MÉTODO index()
     */
    public function index()
    {
        Log::info("🎯 MÉTODO index CHAMADO - API Todos Animais");
        
        try {
            // ✅✅✅ CORREÇÃO: USAR 'tel' EM VEZ DE 'telefone'
            $animais = Animal::with(['user' => function($query) {
                $query->select('id', 'nome', 'tel', 'email'); // ← CORREÇÃO AQUI
            }])->where('status', 'ativo')->get();

            Log::info("🔍 API Index - Total: " . $animais->count());

            return response()->json([
                'status' => 'success',
                'message' => 'Lista de animais carregada com sucesso.',
                'data' => $animais
            ], 200);

        } catch (\Exception $e) {
            Log::error('❌ ERRO API Index: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Erro ao carregar lista de animais.',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * ✅ API: Listar animais perdidos
     */
    public function apiPerdidos()
    {
        Log::info("🎯 MÉTODO apiPerdidos CHAMADO");
        
        try {
            $animais = Animal::with(['user' => function($query) {
                $query->select('id', 'nome', 'tel', 'email');
            }])->where('situacao', 'perdido')
              ->where('status', 'ativo')
              ->get();

            Log::info("🔍 API Perdidos - Total: " . $animais->count());

            return response()->json([
                'status' => 'success',
                'message' => 'Animais perdidos carregados com sucesso.',
                'data' => $animais
            ], 200);

        } catch (\Exception $e) {
            Log::error('❌ ERRO API Perdidos: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Erro ao carregar animais perdidos.',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * ✅ API: Listar animais encontrados
     */
    public function apiEncontrados()
    {
        Log::info("🎯 MÉTODO apiEncontrados CHAMADO");
        
        try {
            $animais = Animal::with(['user' => function($query) {
                $query->select('id', 'nome', 'tel', 'email');
            }])->where('situacao', 'encontrado')
              ->where('status', 'ativo')
              ->get();

            Log::info("🔍 API Encontrados - Total: " . $animais->count());

            return response()->json([
                'status' => 'success',
                'message' => 'Animais encontrados carregados com sucesso.',
                'data' => $animais
            ], 200);

        } catch (\Exception $e) {
            Log::error('❌ ERRO API Encontrados: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Erro ao carregar animais encontrados.',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * ✅ API: Listar animais pendentes
     */
    public function apiPendentes()
    {
        Log::info("🎯 MÉTODO apiPendentes CHAMADO");
        
        try {
            $animais = Animal::with(['user' => function($query) {
                $query->select('id', 'nome', 'tel', 'email');
            }])->where('status', 'pendente')->get();

            Log::info("🔍 API Pendentes - Total: " . $animais->count());

            return response()->json([
                'status' => 'success',
                'message' => 'Animais pendentes carregados com sucesso.',
                'data' => $animais
            ], 200);

        } catch (\Exception $e) {
            Log::error('❌ ERRO API Pendentes: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Erro ao carregar animais pendentes.',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * ✅ API: Listar animais por situação
     */
    public function apiPorSituacao($situacao)
    {
        Log::info("🎯 MÉTODO apiPorSituacao CHAMADO - Situação: {$situacao}");
        
        try {
            $animais = Animal::with(['user' => function($query) {
                $query->select('id', 'nome', 'tel', 'email');
            }])->where('situacao', $situacao)
              ->where('status', 'ativo')
              ->get();

            Log::info("🔍 API Por Situação - {$situacao}: " . $animais->count());

            return response()->json([
                'status' => 'success',
                'message' => "Animais {$situacao}s carregados com sucesso.",
                'data' => $animais
            ], 200);

        } catch (\Exception $e) {
            Log::error('❌ ERRO API Por Situação: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Erro ao carregar animais.',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * ✅ API: Buscar animais (search)
     */
    public function search(Request $request)
    {
        Log::info("🎯 MÉTODO search CHAMADO");
        Log::info("🔍 Parâmetros de busca:", $request->all());
        
        try {
            $query = Animal::with(['user' => function($query) {
                $query->select('id', 'nome', 'tel', 'email');
            }])->where('status', 'ativo');

            if ($request->has('nome') && $request->nome) {
                $query->where('nome', 'like', '%' . $request->nome . '%');
            }

            if ($request->has('especie') && $request->especie) {
                $query->where('especie', $request->especie);
            }

            if ($request->has('cidade') && $request->cidade) {
                $query->where('cidade', 'like', '%' . $request->cidade . '%');
            }

            if ($request->has('bairro') && $request->bairro) {
                $query->where('bairro', 'like', '%' . $request->bairro . '%');
            }

            $animais = $query->get();

            Log::info("🔍 API Search - Resultados: " . $animais->count());

            return response()->json([
                'status' => 'success',
                'message' => 'Busca realizada com sucesso.',
                'data' => $animais,
                'count' => $animais->count()
            ], 200);

        } catch (\Exception $e) {
            Log::error('❌ ERRO API Search: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Erro ao realizar busca.',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function apiTodosAnimais()
    {
        Log::info("🎯 MÉTODO apiTodosAnimais CHAMADO");
        
        try {
            // ✅✅✅ CORREÇÃO: USAR 'tel' EM VEZ DE 'telefone'
            $animais = Animal::with(['user' => function($query) {
                $query->select('id', 'nome', 'tel', 'email'); // ← CORREÇÃO AQUI
            }])->where('status', 'ativo')->get();

            Log::info("🔍 API Todos Animais - Total: " . $animais->count());

            return response()->json([
                'status' => 'success',
                'message' => 'Lista de animais carregada com sucesso.',
                'data' => $animais
            ], 200);

        } catch (\Exception $e) {
            Log::error('❌ ERRO API Todos Animais: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Erro ao carregar lista de animais.',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function show($id)
    {
        Log::info("🎯 MÉTODO show CHAMADO - ID: {$id}");
        
        // ✅✅✅ CORREÇÃO: USAR 'tel' EM VEZ DE 'telefone'
        $animal = Animal::with(['user' => function($query) {
            $query->select('id', 'nome', 'tel', 'email'); // ← CORREÇÃO AQUI
        }])->find($id);

        if (!$animal) {
            Log::warning("⚠️ ANIMAL NÃO ENCONTRADO - ID: {$id}");
            
            return response()->json([
                'status' => 'error',
                'message' => 'Animal não encontrado.'
            ], 404);
        }

        Log::info("🔍 API Show Animal - ID: {$animal->id} - Nome: {$animal->nome}");

        return response()->json([
            'status' => 'success',
            'data' => $animal
        ], 200);
    }

    public function store(Request $request)
    {
        Log::info('🎯 MÉTODO STORE CHAMADO - Recebendo dados do Flutter');
        Log::info('Dados recebidos:', $request->all());
        Log::info('Arquivos recebidos:', $request->file() ? array_keys($request->file()) : []);

        try {
            // ✅ VALIDAÇÃO BÁSICA
            $request->validate([
                'nome' => 'required|string|max:255',
                'descricao' => 'required|string',
                'raca' => 'required|string|max:255',
                'cor' => 'required|string|max:255',
                'especie' => 'required|string|in:Cachorro,Gato',
                'sexo' => 'required|string|in:Macho,Fêmea',
                'cidade' => 'required|string|max:255',
                'bairro' => 'required|string|max:255',
                'user_id' => 'required',
                'situacao' => 'required|string|in:perdido,encontrado',
            ]);

            // ✅ PREPARAR DADOS DO REQUEST
            $data = [
                'nome' => $request->nome,
                'descricao' => $request->descricao,
                'raca' => $request->raca,
                'cor' => $request->cor,
                'especie' => $request->especie,
                'sexo' => $request->sexo,
                'cidade' => $request->cidade,
                'bairro' => $request->bairro,
                'user_id' => $request->user_id,
                'situacao' => $request->situacao,
                'status' => 'pendente',
            ];

            // ✅ CAMPOS ESPECÍFICOS PARA PERDIDOS
            if ($request->has('ultimo_local_visto')) {
                $data['ultimo_local_visto'] = $request->ultimo_local_visto;
            }
            if ($request->has('endereco_desaparecimento')) {
                $data['endereco_desaparecimento'] = $request->endereco_desaparecimento;
            }
            if ($request->has('data_desaparecimento')) {
                $data['data_desaparecimento'] = $request->data_desaparecimento;
            }

            // ✅ CAMPOS ESPECÍFICOS PARA ENCONTRADOS
            if ($request->has('local_encontro')) {
                $data['local_encontro'] = $request->local_encontro;
            }
            if ($request->has('endereco_encontro')) {
                $data['endereco_encontro'] = $request->endereco_encontro;
            }
            if ($request->has('data_encontro')) {
                $data['data_encontro'] = $request->data_encontro;
            }
            if ($request->has('situacao_saude')) {
                $data['situacao_saude'] = $request->situacao_saude;
            }

            // ✅✅✅ CORREÇÃO CRÍTICA - PROCESSAR IMAGENS
            $imagensArray = [];
            
            if ($request->hasFile('imagens')) {
                Log::info('📸 Processando imagens do Flutter...');
                
                foreach ($request->file('imagens') as $key => $imagem) {
                    if ($imagem->isValid()) {
                        Log::info("📸 Imagem {$key}: " . $imagem->getClientOriginalName() . " - Tamanho: " . $imagem->getSize());
                        
                        // ✅✅✅ CORREÇÃO: SALVAR NO DISCO 'public' CORRETAMENTE
                        $nomeArquivo = 'animal_' . time() . '_' . $key . '.' . $imagem->getClientOriginalExtension();
                        
                        // ✅✅✅ MÉTODO CORRETO - usar store com disco 'public'
                        $caminho = $imagem->store('animais', 'public');
                        
                        // ✅✅✅ URL PÚBLICA CORRETA
                        $urlPublica = asset('storage/animais/' . basename($caminho));
                        $imagensArray[] = $urlPublica;
                        
                        Log::info("✅ Imagem salva: {$urlPublica}");
                        Log::info("📁 Caminho físico: {$caminho}");
                    } else {
                        Log::warning("❌ Imagem inválida: " . $imagem->getClientOriginalName());
                    }
                }
            } else {
                Log::info('📭 Nenhuma imagem recebida do Flutter');
            }

            // ✅ SALVAR IMAGENS
            if (!empty($imagensArray)) {
                $data['imagens'] = json_encode($imagensArray);
                Log::info('🖼️  Imagens salvas: ' . json_encode($imagensArray));
            } else {
                // ✅ Imagem padrão com URL completa
                $data['imagens'] = json_encode([asset('images/animais/noimg.jpg')]);
                Log::info('🖼️  Usando imagem padrão');
            }

            Log::info('📦 Dados finais para salvar:', $data);

            // ✅ CRIAR ANIMAL
            $animal = Animal::create($data);

            // ✅✅✅ CARREGAR DADOS DO USUÁRIO PARA RETORNAR (COM CORREÇÃO)
            $animal->load(['user' => function($query) {
                $query->select('id', 'nome', 'tel', 'email'); // ← CORREÇÃO AQUI
            }]);

            Log::info("✅ ANIMAL CRIADO COM SUCESSO! ID: {$animal->id} - STATUS: {$animal->status} - SITUAÇÃO: {$animal->situacao}");

            return response()->json([
                'status' => 'success',
                'message' => 'Animal cadastrado com sucesso! Aguardando aprovação.',
                'data' => $animal
            ], 201);

        } catch (\Exception $e) {
            Log::error('💥 ERRO NO STORE: ' . $e->getMessage());
            Log::error('💥 ARQUIVO: ' . $e->getFile());
            Log::error('💥 LINHA: ' . $e->getLine());
            Log::error('💥 TRACE: ' . $e->getTraceAsString());

            return response()->json([
                'status' => 'error',
                'message' => 'Erro interno: ' . $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine()
            ], 500);
        }
    }

    public function update(Request $request, $id)
    {
        Log::info("🎯 MÉTODO update CHAMADO - ID: {$id}");
        
        $animal = Animal::find($id);

        if (!$animal) {
            Log::warning("⚠️ ANIMAL NÃO ENCONTRADO PARA UPDATE - ID: {$id}");
            
            return response()->json([
                'status' => 'error',
                'message' => 'Animal não encontrado.'
            ], 404);
        }

        try {
            $animal->update($request->all());

            // ✅✅✅ CARREGAR DADOS DO USUÁRIO PARA RETORNAR (COM CORREÇÃO)
            $animal->load(['user' => function($query) {
                $query->select('id', 'nome', 'tel', 'email'); // ← CORREÇÃO AQUI
            }]);

            Log::info("✅ ANIMAL ATUALIZADO - ID: {$animal->id}");

            return response()->json([
                'status' => 'success',
                'message' => 'Animal atualizado com sucesso.',
                'data' => $animal
            ], 200);

        } catch (\Exception $e) {
            Log::error('❌ ERRO AO ATUALIZAR ANIMAL: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Erro ao atualizar o animal.',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function destroy($id)
    {
        Log::info("🎯 MÉTODO destroy CHAMADO - ID: {$id}");
        
        $animal = Animal::find($id);

        if (!$animal) {
            Log::warning("⚠️ ANIMAL NÃO ENCONTRADO PARA DELETE - ID: {$id}");
            
            return response()->json([
                'status' => 'error',
                'message' => 'Animal não encontrado.'
            ], 404);
        }

        try {
            $animal->delete();

            Log::info("🗑️ ANIMAL EXCLUÍDO - ID: {$id}");

            return response()->json([
                'status' => 'success',
                'message' => 'Animal removido com sucesso.'
            ], 200);

        } catch (\Exception $e) {
            Log::error('❌ ERRO AO EXCLUIR ANIMAL: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Erro ao remover o animal.',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function animaisPorSituacao($situacao)
    {
        Log::info("🎯 MÉTODO animaisPorSituacao CHAMADO - Situação: {$situacao}");
        
        // ✅✅✅ CORREÇÃO: USAR 'tel' EM VEZ DE 'telefone'
        $animais = Animal::with(['user' => function($query) {
            $query->select('id', 'nome', 'tel', 'email'); // ← CORREÇÃO AQUI
        }])->where('situacao', $situacao)
          ->where('status', 'ativo')
          ->get();

        Log::info("🔍 Animais por Situação - {$situacao}: " . $animais->count());

        return response()->json([
            'status' => 'success',
            'data' => $animais
        ], 200);
    }

    public function animaisPorUsuario($userId)
    {
        Log::info("🎯 MÉTODO animaisPorUsuario CHAMADO - User ID: {$userId}");
        
        // ✅✅✅ CORREÇÃO: USAR 'tel' EM VEZ DE 'telefone'
        $animais = Animal::with(['user' => function($query) {
            $query->select('id', 'nome', 'tel', 'email'); // ← CORREÇÃO AQUI
        }])->where('user_id', $userId)->get();

        Log::info("🔍 Animais por Usuário - User {$userId}: " . $animais->count());

        return response()->json([
            'status' => 'success',
            'data' => $animais
        ], 200);
    }

    // ✅ APROVAR ANIMAL
    public function aprovarAnimal($id)
    {
        Log::info("🎯 MÉTODO aprovarAnimal CHAMADO - ID: {$id}");
        
        try {
            $animal = Animal::findOrFail($id);
            
            if ($animal->status == 'pendente') {
                $animal->status = 'ativo';
                $animal->save();
                
                // ✅✅✅ CARREGAR DADOS DO USUÁRIO PARA RETORNAR (COM CORREÇÃO)
                $animal->load(['user' => function($query) {
                    $query->select('id', 'nome', 'tel', 'email'); // ← CORREÇÃO AQUI
                }]);
                
                Log::info("✅ ANIMAL APROVADO - ID: {$animal->id} - TIPO: {$animal->situacao}");
                
                return response()->json([
                    'status' => 'success',
                    'message' => 'Animal aprovado com sucesso.',
                    'data' => $animal
                ], 200);
            } else {
                Log::warning("⚠️ ANIMAL JÁ ESTÁ ATIVO - ID: {$animal->id}");
                
                return response()->json([
                    'status' => 'error',
                    'message' => 'Animal não pode ser aprovado (já está ativo ou resolvido).'
                ], 400);
            }
        } catch (\Exception $e) {
            Log::error('❌ ERRO AO APROVAR ANIMAL: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Erro ao aprovar animal.'
            ], 500);
        }
    }

    // ✅ REJEITAR ANIMAL
    public function rejeitarAnimal($id)
    {
        Log::info("🎯 MÉTODO rejeitarAnimal CHAMADO - ID: {$id}");
        
        try {
            $animal = Animal::findOrFail($id);
            
            if ($animal->status == 'pendente') {
                $animal->status = 'recusado';
                $animal->save();
                
                // ✅✅✅ CARREGAR DADOS DO USUÁRIO PARA RETORNAR (COM CORREÇÃO)
                $animal->load(['user' => function($query) {
                    $query->select('id', 'nome', 'tel', 'email'); // ← CORREÇÃO AQUI
                }]);
                
                Log::info("❌ ANIMAL REJEITADO - ID: {$animal->id} - TIPO: {$animal->situacao}");
                
                return response()->json([
                    'status' => 'success',
                    'message' => 'Animal rejeitado com sucesso.',
                    'data' => $animal
                ], 200);
            } else {
                Log::warning("⚠️ ANIMAL NÃO PODE SER REJEITADO - ID: {$animal->id}");
                
                return response()->json([
                    'status' => 'error',
                    'message' => 'Animal não pode ser rejeitado (já está ativo ou resolvido).'
                ], 400);
            }
        } catch (\Exception $e) {
            Log::error('❌ ERRO AO REJEITAR ANIMAL: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Erro ao rejeitar animal.'
            ], 500);
        }
    }

    // ✅ ATUALIZAR STATUS DO ANIMAL
    public function atualizarStatusAnimal(Request $request, $animalId)
    {
        Log::info("🎯 MÉTODO atualizarStatusAnimal CHAMADO - ID: {$animalId}");
        Log::info("🔄 Novo status: {$request->status}");
        
        try {
            $request->validate([
                'status' => 'required|string|in:pendente,ativo,recusado,resolvido,inativo'
            ]);

            $animal = Animal::findOrFail($animalId);
            $animal->status = $request->status;
            $animal->save();

            // ✅✅✅ CARREGAR DADOS DO USUÁRIO PARA RETORNAR (COM CORREÇÃO)
            $animal->load(['user' => function($query) {
                $query->select('id', 'nome', 'tel', 'email'); // ← CORREÇÃO AQUI
            }]);

            Log::info("🔄 STATUS ATUALIZADO - Animal: {$animal->id} -> {$request->status}");

            return response()->json([
                'status' => 'success',
                'message' => 'Status do animal atualizado com sucesso.',
                'data' => $animal
            ], 200);

        } catch (\Exception $e) {
            Log::error('❌ ERRO AO ATUALIZAR STATUS: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Erro ao atualizar status do animal.'
            ], 500);
        }
    }

    /**
     * Mostra detalhes do caso editado: recebe id via POST, carrega animal + edição proposta.
     */
    public function detalhesEditado(Request $request)
    {
        Log::info("🎯 MÉTODO detalhesEditado CHAMADO - ID: {$request->id}");
        
        $data = $request->validate([
            'id' => 'required|integer|exists:animais,id',
        ]);

        $id = $data['id'];

        // animal original (modelo Eloquent)
        $animalModel = Animal::findOrFail($id);
        // converte para array para o componente trabalhar (compatível com exemplos)
        $animal = $animalModel->toArray();

        // busca edição proposta (se existir)
        $edit = DB::table('editados')->where('animal_id', $id)->first();

        if ($edit) {
            // mescla campos N* retornados da tabela editados
            $editArr = (array)$edit;
            foreach ($editArr as $k => $v) {
                $animal[$k] = $v;
            }
        } else {
            // garante que existam chaves N* vazias para o componente
            $keys = ['n_nome','n_tipo','n_raca','n_cor','n_sexo','n_tam','n_imagem1','n_imagem2','n_imagem3','n_imagem4','n_aparencia','n_lugar_visto','n_lugar_encontrado'];
            foreach ($keys as $k) {
                if (!array_key_exists($k, $animal)) $animal[$k] = '';
            }
        }

        Log::info("🔍 Detalhes Editado - Animal ID: {$id}");

        // retorna a view que mostra antes/depois (site.detalhesCE espera $animal)
        return view('site.detalhesCE', ['animal' => $animal]);
    }
}