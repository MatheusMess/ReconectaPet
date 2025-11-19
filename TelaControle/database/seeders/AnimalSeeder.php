<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class AnimalSeeder extends Seeder
{
    public function run()
    {
        DB::table('animais')->insert([
            [
                'user_id' => 1,
                'nome' => 'Spike',
                'especie' => 'cachorro',
                'raca' => 'Labrador',
                'sexo' => 'macho',
                'porte' => 'grande',
                'idade' => '3 anos',
                'cor' => 'marrom',
                'situacao' => 'perdido',

                'descricao' => 'Cachorro Labrador marrom, muito dócil e ativo.',
                'caracteristicas' => 'Focinho mais claro, pelo escuro.',

                'imagens' => json_encode([
                    "https://adotar.com.br/upload/2023-04/animais_imagem979687.jpg?w=700&format=webp",
                    "https://cruzarcachorro.com.br/imagens/produto/1/2853.jpg",
                    "https://i.pinimg.com/736x/9c/67/38/9c6738bf74f94adf5ed0f9e4170cbf2d.jpg",
                    "https://adnchocolate.com.ar/wp-content/uploads/como-son-las-hembras-labrador.webp"
                ]),

                'foto' => null,

                'cidade' => null,
                'bairro' => null,
                'rua' => null,

                'ultimo_local_visto' => 'Av. João Olímpio de Oliveira',
                'endereco_desaparecimento' => 'Vila Asem',
                'data_desaparecimento' => '2025-11-15',

                'status' => 'ativo',
                'ativo' => true,
                'created_at' => now(),
                'updated_at' => now()
            ],

            [
                'user_id' => 1,
                'nome' => 'Luna',
                'especie' => 'gato',
                'raca' => 'Siamês',
                'sexo' => 'fêmea',
                'porte' => 'pequeno',
                'idade' => '1 ano',
                'cor' => 'bege e marrom',
                'situacao' => 'encontrado',

                'descricao' => 'Gata siamesa encontrada próxima ao centro.',
                'caracteristicas' => 'Olhos azuis, muito dócil.',

                'imagens' => json_encode([
                    "https://i.pinimg.com/736x/5b/1b/dc/5b1bdc29fae3c1ac34a2b90e1091cf07.jpg"
                ]),

                'foto' => null,

                'cidade' => 'Itapetininga',
                'bairro' => 'Centro',
                'rua' => 'Rua das Flores',

                'ultimo_local_visto' => null,
                'endereco_desaparecimento' => null,
                'data_desaparecimento' => null,

                'status' => 'ativo',
                'ativo' => true,
                'created_at' => now(),
                'updated_at' => now()
            ],
        ]);
    }
}
