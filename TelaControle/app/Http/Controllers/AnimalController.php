<?php

namespace App\Http\Controllers;

use App\Models\Animal;
use Illuminate\Http\Request;

class AnimalController extends Controller
{
    //
    public function index()
    {
        $animais = Animal::all();
        return dd($animais);
    }
}
