<?php

namespace App\Http\Controllers;

use App\Models\CasoPendente;
use Illuminate\Http\Request;

class CasoPendenteController extends Controller
{
    /**
     * Lista os novos animais encontrados que estão pendentes de aprovação.
     */
    public function indexEncontrados()
    {
        // 1. Busca todos os casos com status 'pendente'
        $casosPendentes = CasoPendente::where('status', 'pendente')->get();

        // 2. Extrai os dados do JSON e filtra apenas os 'Encontrado'
        $animais = $casosPendentes->map(function ($caso) {
            // Adiciona o ID do caso pendente para futuras ações (aprovar/recusar)
            $dados = $caso->dados_animal;
            $dados['id_caso_pendente'] = $caso->id;
            return $dados;
        })->filter(function ($animal) {
            return isset($animal['situacao']) && $animal['situacao'] === 'Encontrado';
        });

        // 3. Envia a coleção de animais para a view
        return view('site.listaNovosAE', ['animais' => $animais]);
    }
}
