<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class UsuarioSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Limpa a tabela para evitar duplicatas
        DB::table('usuarios')->truncate();

        DB::table('usuarios')->insert([
            [
                'id' => 1,
                'nome' => 'Admin Teste',
                'email' => 'admin@teste.com',
                'tel' => '11999999999',
                'senha' => Hash::make('123456'), // Criptografa a senha
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'nome' => 'Usuario Teste',
                'email' => 'usuario@teste.com',
                'tel' => '11888888888',
                'senha' => Hash::make('123456'), // Criptografa a senha
                'created_at' => now(),
                'updated_at' => now(),
            ]
        ]);
    }
}
