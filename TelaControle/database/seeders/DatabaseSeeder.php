<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $this->call([
            UsuarioSeeder::class, // PRIMEIRO - cria usuarios
            AnimalSeeder::class,  // SEGUNDO - cria animais
            EditadosSeeder::class, // TERCEIRO - cria editados
        ]);
    }
}