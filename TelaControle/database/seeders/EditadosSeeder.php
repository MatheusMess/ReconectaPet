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
        // Limpa a tabela
        DB::table('editados')->truncate();

        // tenta localizar alguns animais já existentes para referência
        $spike = Animal::where('nome', 'Spike')->first();
        $qiqi  = Animal::where('nome', 'Qiqi')->first();

        $spikeId = $spike ? $spike->id : 1;
        $qiqiId  = $qiqi  ? $qiqi->id  : 1;

        $editados = [
            // exemplo: edição proposta para Spike
            [
                'id' => $spikeId,
                // novos valores propostos (edição)
                'n_tipo' => 'Cachorro',
                'n_situacao' => 'Perdido',
                'n_nome' => 'Spikey',
                'n_raca' => 'Labrador Retriever',
                'n_cor' => 'Marrom escuro',
                'n_sexo' => 'Macho',
                'n_tam' => 'Grande',
                'n_imagem1' => 'https://exemplo.com/imagens/spike_nova1.jpg',
                'n_imagem2' => null,
                'n_imagem3' => null,
                'n_imagem4' => null,
                'n_aparencia' => 'Pelo mais curto na região do focinho',
                'n_lugar_visto' => 'Av. João Olímpio de Oliveira, Vila Asem',
                'n_lugar_encontrado' => null,

                'created_at' => now(),
                'updated_at' => now(),
            ],

            // exemplo: edição proposta para Qiqi
            [
                'id' => $qiqiId,
                // novos valores propostos
                'n_tipo' => 'Cachorro',
                'n_situacao' => 'Perdido',
                'n_nome' => 'Qiqi (proposto)',
                'n_raca' => 'Pastor-Alemão Misturado',
                'n_cor' => 'Cinza claro',
                'n_sexo' => 'Fêmea',
                'n_tam' => 'Grande',
                'n_imagem1' => 'https://exemplo.com/imagens/qiqi_nova1.jpg',
                'n_imagem2' => null,
                'n_imagem3' => null,
                'n_imagem4' => null,
                'n_aparencia' => 'Olhos azuis mais destacados',
                'n_lugar_visto' => 'Praça Dos Três Poderes - setor B',
                'n_lugar_encontrado' => null,

                'created_at' => now(),
                'updated_at' => now(),
            ],
        ];

        // insere
        DB::table('editados')->insert($editados);
    }
}