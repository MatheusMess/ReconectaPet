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

        $usuarios = [
            [
                'id' => 1,
                'nome' => 'Admin Teste',
                'email' => 'admin@teste.com',
                'tel' => '(15) 99999-9999',
                'cpf' => '000.000.000-00',
                'senha' => Hash::make('123456'), // Criptografa a senha
                'adm' => true,
            ],
            [
                'id' => 2,
                'nome' => 'Usuario Teste',
                'email' => 'usuario@teste.com',
                'tel' => '(15) 88888-8888',
                'cpf' => '111.111.111-11',
                'senha' => Hash::make('123456'), // Criptografa a senha
            ],
            [
                'id' => 3,
                'nome' => 'Usuario Teste 2',
                'email' => 'usuario2@teste.com',
                'tel' => '(15) 77777-7777',
                'cpf' => '222.222.222-22',
                'senha' => Hash::make('123456'), // Criptografa a senha
            ],
            [
                'id' => 4,
                'nome' => 'Usuario Teste 3',
                'email' => 'usuario3@teste.com',
                'tel' => '(15) 00000-0000',
                'cpf' => '333.333.333-33',
                'senha' => Hash::make('123456'), // Criptografa a senha
            ],
        ];
        foreach ($usuarios as $usuario) {
            $usuario ['created_at'] = now();
            $usuario ['updated_at'] = now();
            DB::table('usuarios')->insert($usuario);
        }
    }
}
