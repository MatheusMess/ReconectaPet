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
                'sexo' => 'Macho',
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
                'sexo' => 'Fêmea',
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
                'sexo' => 'Macho',
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
                //'nome' => '', // Sem nome
                'tipo' => 'Gato',
                'raca' => 'Siamês',
                'cor' => 'Preto e creme',
                'sexo' => 'Fêmea',
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
                //'nome' => '(sem coleira)',
                'raca' => 'Siamês',
                'cor' => 'Branco e cinza',
                'sexo' => 'Fêmea',
                'imagem1' => 'https://adotar.com.br/upload/2016-07/animais_imagem200048.jpg?w=700&format=webp',
                //'status' => 'pendente',
                'situacao' => 'Encontrado',
            ],
            [
                'user_id' => 1,
                'tipo' => 'Cachorro',
                'nome' => 'Max',
                'raca' => 'Labrador',
                'cor' => 'Preto',
                'sexo' => 'Macho',
                'tam' => 'Pequeno',
                'imagem1' => 'https://cdn.los-animales.org/fotos/419836998_7902153-filhote-de-labrador-preto.jpg',
                'imagem2' => 'https://img.olx.com.br/images/41/414426957817498.jpg',
                'imagem3' => 'https://i.pinimg.com/236x/ec/a2/46/eca246c74e7a971870cb8cd16cbcb1c5.jpg',
                'imagem4' => 'data:image/jpeg;base64,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',
                'aparencia' => 'Fihote com uma coleira azul com símbolo de osso',
                'lugar_encontrado' => 'Rua Sílvia de Oliveira da Silva',

                //'status' => 'pendente',
                'situacao' => 'Encontrado',
            ],
            [
                'user_id' => 1,
                'tipo' => 'Gato',
                //'nome' => '(sem coleira)',
                'raca' => 'Persa',
                'cor' => 'Cinza',
                'sexo' => 'Macho',
                'imagem1' => 'https://img.olx.com.br/images/25/252444316710330.jpg',
                //'status' => 'pendente',
                'situacao' => 'Encontrado',
            ],
            [
                'user_id' => 1,
                'tipo' => 'Cachorro',
                'nome' => 'Luna',
                'raca' => 'Akbash',
                'cor' => 'Branco',
                'sexo' => 'Fêmea',
                'imagem1' => 'https://cdn.pixabay.com/photo/2018/12/09/14/58/dog-3865029_1280.jpg',
                //'status' => 'pendente',
                'situacao' => 'Encontrado',
            ],
            [
                'user_id' => 1,
                'nome' => 'Qiqi',
                'tipo' => 'Cachorro',
                'raca' => 'Pastor-Alemão',
                'cor' => 'Cinza',
                'sexo' => 'Fêmea',
                'tam' => 'Grande',
                'imagem1' => 'https://i.pinimg.com/474x/f2/9d/ba/f29dba2b270a670bc0f604692762cf91.jpg',
                'imagem2' => 'https://mega.ibxk.com.br/2018/11/08/gafanhoto-08120353817089.jpg?ims=fit-in/800x500',
                'imagem3' => 'https://i.redd.it/izj5qxtyjuze1.jpeg',
                'imagem4' => 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQPhKXN4cGJl2MCAsyIozhLZBAnyDIBmYszyE1GAHIBlLYylcjU',
                'aparencia' => 'Orelhas peludas, olhos azuis, parecido com um lobo',
                'lugar_visto' => 'Praça Dos Três Poderes',
                //'status' => 'pendente',
                'situacao' => 'Perdido',
            ]

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
