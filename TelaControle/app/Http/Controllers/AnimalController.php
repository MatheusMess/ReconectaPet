<?php

namespace App\Http\Controllers;

use App\Models\Animal;
use Illuminate\Http\Request;

class AnimalController extends Controller
{
    // ===============================
    // LISTAGENS
    // ===============================

    public function listarPerdidos()
    {
        $animais = Animal::where('situacao', 'perdido')
                        ->where('status', 'ativo')
                        ->get();
        return view('site.AnimaisPerdidos', compact('animais'));
    }

    public function listarEncontrados()
    {
        $animais = Animal::where('situacao', 'encontrado') // CORRIGIDO: era $Animais
                        ->where('status', 'ativo')
                        ->get();
        return view('site.AnimaisEncontrados', compact('animais'));
    }

    public function listarNPerdidos()
    {
        $animais = Animal::where('situacao', 'perdido')
                        ->where('status', 'pendente')
                        ->get();
        return view('site.listaNovosPerdidos', compact('animais'));
    }

    public function listarNEncontrados()
    {
        $animais = Animal::where('situacao', 'encontrado')
                        ->where('status', 'pendente')
                        ->get();
        return view('site.listaNovosEncontrados', compact('animais'));
    }

    public function listarResolvidos()
    {
        $animais = Animal::where('status', 'resolvido')->get();
        return view('site.casosResolvidos', compact('animais'));
    }

    public function listarInativados()
    {
        $animais = Animal::where('status', 'inativo')->get();
        return view('site.CasosInativados', compact('animais'));
    }

    public function listarEditados()
    {
        $animais = Animal::where('status', 'editado')->get();
        return view('site.casosEditados', compact('animais'));
    }

    // ===============================
    // TODOS ANIMAIS (COM FILTROS)
    // ===============================

    public function todosAnimais(Request $request)
    {
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
        $animal = Animal::findOrFail($id);
        $caso = $this->calcularCaso($animal);

        return view('site.detalheAnimal', compact('animal', 'caso'));
    }

    // ===============================
    // DETALHES (POST)
    // ===============================

    public function DetalheAnimal(Request $request)
    {
        $animal = Animal::findOrFail($request->id);
        $caso = $this->calcularCaso($animal);
        return view('site.detalheAnimal', compact('animal', 'caso'));
    }

    public function DNEncontrados(Request $request)
    {
        $animal = Animal::findOrFail($request->id);
        $caso = 6;
        return view('site.DetalhesNovosEncontrados', compact('animal', 'caso'));
    }

    public function DNPerdidos(Request $request)
    {
        $animal = Animal::findOrFail($request->id);
        $caso = 7;
        return view('site.DetalhesNovosPerdidos', compact('animal', 'caso'));
    }

    public function detalhesCE(Request $request)
    {
        $animal = Animal::findOrFail($request->id);
        return view('site.detalhesCE', compact('animal'));
    }

    // ===============================
    // AÇÕES SOBRE CASOS
    // ===============================

    public function aceitar(Request $request)
    {
        $animal = Animal::findOrFail($request->id);
        $animal->status = 'ativo';
        $animal->save();

        return back()->with('success', 'Caso aceito com sucesso!');
    }

    public function recusar(Request $request)
    {
        $animal = Animal::findOrFail($request->id);
        $animal->status = 'recusado';
        $animal->save();

        return back()->with('success', 'Caso recusado com sucesso!');
    }

    public function resolver(Request $request)
    {
        $animal = Animal::findOrFail($request->id);
        $animal->status = 'resolvido';
        $animal->save();

        return back()->with('success', 'Caso resolvido com sucesso!');
    }

    public function inativar(Request $request)
    {
        $animal = Animal::findOrFail($request->id);
        $animal->status = 'inativo';
        $animal->save();

        return back()->with('success', 'Caso inativado com sucesso!');
    }

    public function reativar(Request $request)
    {
        $animal = Animal::findOrFail($request->id);
        $animal->status = 'ativo';
        $animal->save();

        return back()->with('success', 'Caso reativado com sucesso!');
    }

    // ===============================
    // AUXILIAR
    // ===============================

    private function calcularCaso(Animal $animal)
    {
        if ($animal->situacao == 'perdido') {
            if ($animal->status == 'ativo') return 1;
            if ($animal->status == 'pendente') return 7;
            if ($animal->status == 'resolvido') return 3;
            if ($animal->status == 'inativo') return 4;
        }

        if ($animal->situacao == 'encontrado') {
            if ($animal->status == 'ativo') return 2;
            if ($animal->status == 'pendente') return 6;
            if ($animal->status == 'resolvido') return 3;
            if ($animal->status == 'inativo') return 4;
        }

        return 0;
    }

    // ===============================
    // API
    // ===============================

    public function apiTodosAnimais()
    {
        try {
            $animais = Animal::where('status', 'ativo')->get();

            return response()->json([
                'status' => 'success',
                'message' => 'Lista de animais carregada com sucesso.',
                'data' => $animais
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Erro ao carregar lista de animais.',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function show($id)
    {
        $animal = Animal::find($id);

        if (!$animal) {
            return response()->json([
                'status' => 'error',
                'message' => 'Animal não encontrado.'
            ], 404);
        }

        return response()->json([
            'status' => 'success',
            'data' => $animal
        ], 200);
    }

    public function store(Request $request)
    {
        $request->validate([
            'nome' => 'required|string',
            'especie' => 'required|string',
            'situacao' => 'required|string|in:perdido,encontrado',
            'status' => 'sometimes|string|in:pendente,ativo'
        ]);

        try {
            $data = $request->all();
            if (!isset($data['status'])) {
                $data['status'] = 'pendente';
            }

            $animal = Animal::create($data);

            return response()->json([
                'status' => 'success',
                'message' => 'Animal cadastrado com sucesso.',
                'data' => $animal
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Erro ao cadastrar o animal.',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function update(Request $request, $id)
    {
        $animal = Animal::find($id);

        if (!$animal) {
            return response()->json([
                'status' => 'error',
                'message' => 'Animal não encontrado.'
            ], 404);
        }

        try {
            $animal->update($request->all());

            return response()->json([
                'status' => 'success',
                'message' => 'Animal atualizado com sucesso.',
                'data' => $animal
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Erro ao atualizar o animal.',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function destroy($id)
    {
        $animal = Animal::find($id);

        if (!$animal) {
            return response()->json([
                'status' => 'error',
                'message' => 'Animal não encontrado.'
            ], 404);
        }

        try {
            $animal->delete();

            return response()->json([
                'status' => 'success',
                'message' => 'Animal removido com sucesso.'
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Erro ao remover o animal.',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function animaisPorSituacao($situacao)
    {
        $animais = Animal::where('situacao', $situacao)
                        ->where('status', 'ativo')
                        ->get();

        return response()->json([
            'status' => 'success',
            'data' => $animais
        ], 200);
    }

    public function animaisPorUsuario($userId)
    {
        $animais = Animal::where('user_id', $userId)->get();

        return response()->json([
            'status' => 'success',
            'data' => $animais
        ], 200);
    }
}