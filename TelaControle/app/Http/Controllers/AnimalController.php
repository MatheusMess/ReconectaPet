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

    /**
     * Lista os animais com situação "Encontrado" e status "ativo".
     */
    public function listarNEncontrados()
    {
        // 1. Busca no banco de dados usando o Model 'Animal'
        $animais = Animal::where('situacao', 'Encontrado')
                         ->where('status', 'ativo')
                         ->get();

        // 2. Retorna a view 'listaEncontrados' e passa a variável 'animais' para ela
        return view('site.listaNovosEncontrados', ['animais' => $animais]);
    }
}
