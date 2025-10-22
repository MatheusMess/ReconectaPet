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

    public function TodosAnimais()
    {
        $animais = Animal::get();

        return view('site.todosAnimais', ['animais' => $animais]);
    }

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
}
