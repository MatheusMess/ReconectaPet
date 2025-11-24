<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class UsuarioSeeder extends Seeder
{
    public function run()
    {
        DB::table('usuarios')->insert([
            [
                'nome' => 'Administrador',
                'email' => 'admin@example.com',
                'tel' => '(15) 99999-9999',
                'cpf' => '123.456.789-00',
                'senha' => Hash::make('password'),
                'adm' => true,
                'email_verified_at' => now(),
                'created_at' => now(),
                'updated_at' => now()
            ],
            [
                'nome' => 'Usuário Comum',
                'email' => 'usuario@example.com',
                'tel' => '(15) 98888-8888',
                'cpf' => '987.654.321-00',
                'senha' => Hash::make('password'),
                'adm' => false,
                'email_verified_at' => now(),
                'created_at' => now(),
                'updated_at' => now()
            ],
        ]);
    }
}