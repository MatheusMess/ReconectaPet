<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use App\Models\Animal;

class EditadosSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('editados')->truncate();

        // Tenta localizar alguns animais já existentes para referência
        $spike = Animal::where('nome', 'Spike')->first();
        $qiqi  = Animal::where('nome', 'Qiqi')->first();

        if (!$spike || !$qiqi) {
            $this->command->error('Animais Spike ou Qiqi não encontrados! Execute AnimalSeeder primeiro.');
            return;
        }

        $editados = [
            // exemplo: edição proposta para Spike
            [
                'id' => $spike->id,
                // novos valores propostos (edição) - USANDO CAMPOS CORRETOS
                'n_tipo' => 'Cachorro',
                'n_nome' => 'Spikey',
                'n_raca' => 'Labrador Retriever',
                'n_cor' => 'Marrom escuro',
                'n_sexo' => 'Macho',
                'n_tam' => 'Grande',
                'n_aparencia' => 'Pelo mais curto na região do focinho',
                'n_lugar_visto' => 'Av. João Olímpio de Oliveira, Vila Asem',
                'n_imagem1' => 'https://exemplo.com/imagens/spike_nova1.jpg',
                'n_imagem2' => null,
                'n_imagem3' => null,
                'n_imagem4' => null,

                'created_at' => now(),
                'updated_at' => now(),
            ],

            // exemplo: edição proposta para Qiqi
            [
                'id' => $qiqi->id,
                // novos valores propostos - USANDO CAMPOS CORRETOS
                'n_tipo' => 'Cachorro',
                'n_nome' => 'Qiqi (proposto)',
                'n_raca' => 'Pastor-Alemão Misturado',
                'n_cor' => 'Cinza claro',
                'n_sexo' => 'Fêmea',
                'n_tam' => 'Grande',
                'n_aparencia' => 'Olhos azuis mais destacados',
                'n_lugar_visto' => 'Praça Dos Três Poderes - setor B',
                'n_imagem1' => 'https://exemplo.com/imagens/qiqi_nova1.jpg',
                'n_imagem2' => null,
                'n_imagem3' => null,
                'n_imagem4' => null,

                'created_at' => now(),
                'updated_at' => now(),
            ],
        ];

        // insere
        DB::table('editados')->insert($editados);
    }
}