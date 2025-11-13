<?php

namespace App\Http\Controllers;

use App\Models\Animal;
use App\Http\Controllers\AnimalController;
use App\Models\Editados;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;

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

    public function aceitarEdicao(Request $request)
    {
        $id = $request->input('id');

        $basePasta= public_path("images/animais/".$id."/");
        $newPasta = $basePasta. 'new/';
        $oldPasta = $basePasta. 'old/';

        // Cria pasta old se não existir
        if (!File::exists($oldPasta)) {
            File::makeDirectory($oldPasta, 0755, true);
        }

        // Lista os nomes esperados das imagens
       $imagens = ['imagem1.png', 'imagem2.png', 'imagem3.png', 'imagem4.png'];

        foreach ($imagens as $img) {
            $atual = $basePasta . $img;
            $nova  = $newPasta  . $img;

            // Só continua se a imagem nova existe
            if (File::exists($nova)) {

                // Se a imagem atual NÃO existir, ou se for diferente da nova, move
                $imagemAlterada = !File::exists($atual) || md5_file($nova) !== md5_file($atual);

                if ($imagemAlterada) {
                    // Move a atual para "old", se existir
                    if (File::exists($atual)) {
                        File::move($atual, $oldPasta . $img);
                    }

                    // Move a nova para a pasta principal
                    File::move($nova, $basePasta . $img);
                }
            }
        }

        return (new AnimalController())->DetalheAnimal($request);
    }
}
