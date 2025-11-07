<?php

namespace App\Http\Controllers;

use App\Models\Usuario;
use Illuminate\Http\Request;

class UsuarioController extends Controller
{
    public function listar()
    {
        $usuarios = Usuario::all();
        return view('site.listaUsuarios', ['usuarios' => $usuarios]);
    }
}
