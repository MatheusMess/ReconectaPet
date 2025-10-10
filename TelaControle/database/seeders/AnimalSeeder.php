<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash; // Usado para senhas, se necessário
use App\Models\Animal; // Importa o Model Animal

class AnimalSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Limpa a tabela antes de inserir para evitar duplicatas ao rodar o seeder novamente
        DB::table('animais')->truncate();

        // Dados extraídos dos seus arquivos Blade
        $animais = [
            // --- De casosResolvidos.blade.php ---
            [
                'user_id' => 1,
                'tipo' => 'Cachorro',
                'nome' => 'Muttley',
                'raca' => 'Vira-Lata',
                'cor' => 'Caramelo',
                'sexo' => 'M',
                'imagem1' => 'https://assets.brasildefato.com.br/2024/09/image_processing20210113-1654-11x5azn-750x533.jpeg',
                'status' => 'resolvido',
                'situacao' => 'Encontrado', // Assumindo que resolvidos foram encontrados
            ],
            [
                'user_id' => 1,
                'tipo' => 'Gato',
                'nome' => 'Mel',
                'raca' => 'Maine Coon',
                'cor' => 'Cinza',
                'sexo' => 'F',
                'imagem1' => 'https://cdn2.thecatapi.com/images/MTY3ODIyMQ.jpg',
                'status' => 'resolvido',
                'situacao' => 'Encontrado',
            ],
            // --- De detalhesAP.blade.php (Animal Perdido) ---
            [
                'user_id' => 2,
                'nome' => 'Spike',
                'tipo' => 'Cachorro',
                'raca' => 'Labrador',
                'cor' => 'Marrom',
                'sexo' => 'M',
                'tam' => 'Grande',
                'imagem1' => 'https://adotar.com.br/upload/2023-04/animais_imagem979687.jpg?w=700&format=webp',
                'imagem2' => 'https://cruzarcachorro.com.br/imagens/produto/1/2853.jpg',
                'imagem3' => 'https://i.pinimg.com/736x/9c/67/38/9c6738bf74f94adf5ed0f9e4170cbf2d.jpg',
                'imagem4' => 'https://adnchocolate.com.ar/wp-content/uploads/como-son-las-hembras-labrador.webp',
                'aparencia' => 'pelo marrom escuro quase preto, o focinho é mais claro que o pelo',
                'lugar_visto' => 'Av. João Olímpio de Oliveira, Vila Asem, Itapetininga - SP',
                'status' => 'ativo',
                'situacao' => 'Perdido',
            ],
            // --- De detalhesAE.blade.php (Animal Encontrado) ---
            [
                'user_id' => 2,
                'nome' => '', // Sem nome
                'tipo' => 'Gato',
                'raca' => 'Siamês',
                'cor' => 'Preto e creme',
                'sexo' => 'F',
                'tam' => 'Medio',
                'imagem1' => 'https://adotar.com.br/upload/2024-04/animais_imagem1112099.jpg?w=700&format=webp',
                'imagem2' => 'https://adotar.com.br/upload/2024-04/animais_imagem1112078.jpeg?w=700&format=webp',
                'imagem3' => 'https://adotar.com.br/upload/2024-04/animais_imagem1112079.jpeg?w=700&format=webp',
                'imagem4' => 'https://adotar.com.br/upload/2024-04/animais_imagem1112076.jpeg?w=115&format=webp',
                'aparencia' => 'entre a parte clara e a parte escura tem um tom de marrom com cinza',
                'lugar_encontrado' => 'Rua Olívia da Silva de Oliveira',
                'status' => 'ativo',
                'situacao' => 'Encontrado',
            ],
            // --- De listaNovosAP.blade.php (Animais Perdidos) ---
            [
                'user_id' => 1,
                'tipo' => 'Gato',
                'nome' => 'Mimi',
                'raca' => 'Siamês',
                'cor' => 'Branco e cinza',
                'sexo' => 'F',
                'imagem1' => 'https://adotar.com.br/upload/2016-07/animais_imagem200048.jpg?w=700&format=webp',
                'status' => 'ativo',
                'situacao' => 'Perdido',
            ],
            // Adicionei os outros animais da sua lista aqui
        ];

        // Itera sobre o array e insere cada animal no banco de dados
        foreach ($animais as $animalData) {
            // Adiciona timestamps automaticamente
            $animalData['created_at'] = now();
            $animalData['updated_at'] = now();
            DB::table('animais')->insert($animalData);
        }
    }
}
