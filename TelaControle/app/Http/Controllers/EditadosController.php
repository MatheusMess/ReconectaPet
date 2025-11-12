<?php

namespace App\Http\Controllers;

use App\Models\Animal;
use App\Models\Editados;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

class EditadosController extends Controller
{
    //detalhesEditado
    public function detalhesEditado(Request $request)
    {
        $animal_id = $request->input('id');

        $editado = Editados::where('animal_id', $animal_id)->first();

        $animal = Animal::where('id', $editado['animal_id'])->first();

        return view('site.detalhesCE', ['editado' => $editado, 'animal' => $animal]);
    }
}
