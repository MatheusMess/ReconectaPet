<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class AnimalSeeder extends Seeder
{
    public function run()
    {
        // Primeiro, garantir que existe pelo menos um usuário
        $user = DB::table('usuarios')->first();
        
        if (!$user) {
            // Criar um usuário admin se não existir
            $userId = DB::table('usuarios')->insertGetId([
                'nome' => 'Administrador',
                'email' => 'admin@reconectapet.com',
                'tel' => '(15) 99999-9999',
                'cpf' => '123.456.789-00',
                'senha' => Hash::make('123456'),
                'adm' => true,
                'banido' => false,
                'created_at' => now(),
                'updated_at' => now()
            ]);
        } else {
            $userId = $user->id;
        }

        DB::table('animais')->insert([
            // ✅ ANIMAL 1 - PERDIDO (todas as colunas alinhadas)
            [
                'user_id' => $userId,
                'nome' => 'Spike',
                'especie' => 'Cachorro',
                'raca' => 'Labrador',
                'sexo' => 'Macho',
                'porte' => 'grande',
                'idade' => 3,
                'cor' => 'marrom',
                'situacao' => 'perdido',
                'caracteristicas' => 'Focinho mais claro, pelo escuro.',
                'descricao' => 'Cachorro Labrador marrom, muito dócil e ativo.',
                'imagens' => json_encode([
                    "https://adotar.com.br/upload/2023-04/animais_imagem979687.jpg?w=700&format=webp"
                ]),
                'foto' => null,
                'cidade' => 'Itapetininga',
                'bairro' => 'Vila Asem',
                'rua' => null,
                'ultimo_local_visto' => 'Av. João Olímpio de Oliveira',
                'endereco_desaparecimento' => 'Vila Asem',
                'data_desaparecimento' => '2025-11-15',
                'local_encontro' => null,
                'endereco_encontro' => null,
                'data_encontro' => null,
                'situacao_saude' => null,
                'contato_responsavel' => null,
                'status' => 'ativo',
                'ativo' => true,
                'created_at' => now(),
                'updated_at' => now()
            ],
            
            // ✅ ANIMAL 2 - ENCONTRADO (todas as colunas alinhadas)
            [
                'user_id' => $userId,
                'nome' => 'Luna',
                'especie' => 'Gato',
                'raca' => 'Siamês',
                'sexo' => 'Fêmea',
                'porte' => 'pequeno',
                'idade' => 1,
                'cor' => 'bege e marrom',
                'situacao' => 'encontrado',
                'caracteristicas' => 'Olhos azuis, muito dócil.',
                'descricao' => 'Gata siamesa encontrada próxima ao centro.',
                'imagens' => json_encode([
                    "https://adotar.com.br/upload/2023-04/animais_imagem979687.jpg?w=700&format=webp"
                ]),
                'foto' => null,
                'cidade' => 'Itapetininga',
                'bairro' => 'Centro',
                'rua' => null,
                'ultimo_local_visto' => null,
                'endereco_desaparecimento' => null,
                'data_desaparecimento' => null,
                'local_encontro' => 'Praça Central',
                'endereco_encontro' => 'Rua das Flores, 123',
                'data_encontro' => '2025-11-18',
                'situacao_saude' => 'Saudável',
                'contato_responsavel' => '(15) 99999-9999',
                'status' => 'ativo',
                'ativo' => true,
                'created_at' => now(),
                'updated_at' => now()
            ],

            // ✅ ANIMAL 3 - PERDIDO PENDENTE
            [
                'user_id' => $userId,
                'nome' => 'Bolinha',
                'especie' => 'Cachorro',
                'raca' => 'Poodle',
                'sexo' => 'Fêmea',
                'porte' => 'pequeno',
                'idade' => 4,
                'cor' => 'branco',
                'situacao' => 'perdido',
                'caracteristicas' => 'Pelo encaracolado, coleira rosa.',
                'descricao' => 'Poodle branco muito brincalhão.',
                'imagens' => json_encode([
                    "https://www.petlove.com.br/images/breeds/193221/profile/original/poodle-p.jpg?1532539271"
                ]),
                'foto' => null,
                'cidade' => 'Itapetininga',
                'bairro' => 'Vila Maria',
                'rua' => null,
                'ultimo_local_visto' => 'Praça da Matriz',
                'endereco_desaparecimento' => 'Vila Maria',
                'data_desaparecimento' => '2025-11-16',
                'local_encontro' => null,
                'endereco_encontro' => null,
                'data_encontro' => null,
                'situacao_saude' => null,
                'contato_responsavel' => null,
                'status' => 'pendente',
                'ativo' => true,
                'created_at' => now(),
                'updated_at' => now()
            ],

            // ✅ ANIMAL 4 - ENCONTRADO PENDENTE
            [
                'user_id' => $userId,
                'nome' => 'Mimi',
                'especie' => 'Gato',
                'raca' => 'Persa',
                'sexo' => 'Fêmea',
                'porte' => 'pequeno',
                'idade' => 2,
                'cor' => 'cinza',
                'situacao' => 'encontrado',
                'caracteristicas' => 'Pelo longo, muito calma.',
                'descricao' => 'Gata persa encontrada no jardim.',
                'imagens' => json_encode([
                    "https://www.petlove.com.br/images/breeds/193223/profile/original/persa-p.jpg?1532539111"
                ]),
                'foto' => null,
                'cidade' => 'Itapetininga',
                'bairro' => 'Jardim Europa',
                'rua' => null,
                'ultimo_local_visto' => null,
                'endereco_desaparecimento' => null,
                'data_desaparecimento' => null,
                'local_encontro' => 'Jardim Europa',
                'endereco_encontro' => 'Rua das Rosas, 789',
                'data_encontro' => '2025-11-19',
                'situacao_saude' => 'Saudável',
                'contato_responsavel' => '(15) 97777-7777',
                'status' => 'pendente',
                'ativo' => true,
                'created_at' => now(),
                'updated_at' => now()
            ]
        ]);
    }
}