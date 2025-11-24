<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class EditadosSeeder extends Seeder
{
    public function run()
    {
        DB::table('editados')->insert([
            [
                'animal_id' => 1, // ID do animal Spike
                'n_nome' => 'Spike Atualizado',
                'n_tipo' => 'Cachorro',
                'n_situacao' => 'Perdido',
                'n_raca' => 'Labrador Retriever',
                'n_sexo' => 'Macho',
                'n_tam' => 'Grande',
                'n_cor' => 'Marrom claro',
                'n_aparencia' => 'Cachorro Labrador marrom claro, muito dócil e ativo. Focinho mais claro, pelo escuro. Possui coleira azul.',
                'n_lugar_visto' => 'Av. João Olímpio de Oliveira, Vila Asem - próximo ao mercado',
                'n_lugar_encontrado' => null,
                'n_imagem1' => null,
                'n_imagem2' => null,
                'n_imagem3' => null,
                'n_imagem4' => null,
                'created_at' => now(),
                'updated_at' => now()
            ],
        ]);
    }
}