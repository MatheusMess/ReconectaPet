<?php

namespace App\Http\Controllers;

use App\Models\Animal;
use Illuminate\Http\Request;

class AnimalController extends Controller
{
    public function index()
    {
        $animais = Animal::all();
        return dd($animais);
    }

    //Lista os animais
    public function listarNEncontrados()
    {
        $animais = Animal::where('situacao', 'Encontrado')
                         ->where('status', 'pendente')
                         ->get();

        return view('site.listaNovosEncontrados', ['animais' => $animais]);
    }

    public function listarNPerdidos()
    {
        $animais = Animal::where('situacao', 'Perdido')
                         ->where('status', 'pendente')
                         ->get();

        return view('site.listaNovosPerdidos', ['animais' => $animais]);
    }
    /* 
    public function TodosAnimais()
    {
        $animais = Animal::get();

        return view('site.todosAnimais', ['animais' => $animais]);
    }*/

    public function listarEncontrados()
    {
        $animais = Animal::where('situacao', 'Encontrado')
                     ->where('status', 'ativo')
                     ->get();

        return view('site.AnimaisEncontrados', ['animais' => $animais]);
    }
    public function listarPerdidos()
    {
        $animais = Animal::where('situacao', 'Perdido')
                     ->where('status', 'ativo')
                     ->get();

        return view('site.AnimaisPerdidos', ['animais' => $animais]);
    }
    public function listarInativados()
    {
        $animais = Animal::where('status', 'inativo')
                     ->get();

        return view('site.CasosInativados', ['animais' => $animais]);
    }
    public function listarResolvidos()
    {
        $animais = Animal::where('status', 'resolvido')
                     ->get();

        return view('site.CasosResolvidos', ['animais' => $animais]);
    }

    //Detalhes de um animal específico recebido via POST.
    
    public function DNEncontrados(Request $request)
    {
        $animalId = $request->input('id');
        $animal = Animal::findOrFail($animalId);
        return view('site.DetalhesNovosEncontrados', ['animal' => $animal]);
    }
    public function DetalheAnimal(Request $request)
    {
        $animalId = $request->input('id');
        $animal = Animal::findOrFail($animalId);
        
        $caso = 0;
        /*
            caso [dap]  = 1
            caso [dae]  = 2
            caso [dcr]  = 3
            caso [dca]  = 4
            caso [dce]  = 5
            caso [dnae] = 6
            caso [dnap] = 7
        */

        if ($animal->situacao == 'Perdido') {
            if ($animal->status == 'ativo') {
                $caso = 1;
            }elseif ($animal->status == 'pendente') {
                $caso = 7;
            }elseif ($animal->status == 'resolvido') {
                $caso = 3;
            }elseif ($animal->status == 'inativo') {
                $caso = 4;
            }
        } elseif ($animal->situacao == 'Encontrado') {
            if ($animal->status == 'ativo') {
                $caso = 2;
            }elseif ($animal->status == 'pendente') {
                $caso = 6;
            }elseif ($animal->status == 'resolvido') {
                $caso = 3;
            }elseif ($animal->status == 'inativo') {
                $caso = 4;
            }
        }


        return view('site.detalheAnimal', ['animal' => $animal, 'caso' => $caso]);

    }

    /**
     * Lista todos os animais com filtros (situação, status, tipo, sexo).
     */
    public function todosAnimais(Request $request)
    {
        $query = Animal::query();

        // Aplica filtros somente se enviados
        if ($request->filled('situacao')) {
            $query->where('situacao', $request->input('situacao'));
        }

        if ($request->filled('status')) {
            $query->where('status', $request->input('status'));
        }

        if ($request->filled('animal')) {
            $query->where('tipo', $request->input('animal'));
        }

        if ($request->filled('sexo')) {
            // aceita valores 'M' ou 'F' conforme seu banco
            $query->where('sexo', $request->input('sexo'));
        }

        $animais = $query->get();

        // mantém os filtros para re-popular os selects na view
        $filters = $request->only(['situacao','status','animal','sexo']);
        $filters = array_merge(['situacao'=>'','status'=>'','animal'=>'','sexo'=>''], $filters);

        return view('site.todosAnimais', compact('animais','filters'));
    }

    protected function changeStatus(Request $request, string $status)
    {
        $data = $request->validate([
            'id' => 'required|integer|exists:animais,id',
        ]);

        $animal = Animal::findOrFail($data['id']);
        $animal->status = $status;
        $animal->save();

        return $this->DetalheAnimal($request);
    }

    public function aceitar(Request $request)
    {
        // aprovar caso pendente -> ativo
        return $this->changeStatus($request, 'ativo');
    }

    public function recusar(Request $request)
    {
        // recusar -> inativo (ou ajuste conforme necessidade)
        return $this->changeStatus($request, 'inativo');
    }

    public function resolver(Request $request)
    {
        // marcar como resolvido
        return $this->changeStatus($request, 'resolvido');
    }

    public function inativar(Request $request)
    {
        // inativar caso
        return $this->changeStatus($request, 'inativo');
    }

    public function reativar(Request $request)
    {
        // reativar caso -> ativo
        return $this->changeStatus($request, 'ativo');
    }
}
