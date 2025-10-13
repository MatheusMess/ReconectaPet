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

    
    //Lista os animais com situação "Encontrado" e status "ativo".
    public function listarNEncontrados()
    {
        $animais = Animal::where('situacao', 'Encontrado')
                         ->where('status', 'pendente')
                         ->get();

        return view('site.listaNovosEncontrados', ['animais' => $animais]);
    }

    /**
     * Mostra os detalhes de um animal específico recebido via POST.
     */
    public function DNEncontrados(Request $request)
    {
        /*// 1. Valida se o ID foi enviado na requisição
        $request->validate([
            'id' => 'required|integer|exists:animais,id'
        ]);
        */
        // 2. Pega o ID do input do formulário
        $animalId = $request->input('id');

        // 3. Busca o animal pelo ID
        $animal = Animal::findOrFail($animalId);

        // 4. Retorna a view de detalhes, passando o objeto $animal encontrado.
        return view('site.DetalhesNovosEncontrados', ['animal' => $animal]);
    }
}
