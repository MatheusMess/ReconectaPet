<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('animais', function (Blueprint $table) {
            $table->id();

            // Usuário dono do anúncio
            $table->foreignId('user_id')
                ->constrained('usuarios')
                ->onDelete('cascade');

            // Dados básicos do animal (COM TODOS OS CAMPOS)
            $table->string('nome');
            $table->string('especie'); // Cachorro, Gato
            $table->string('raca');
            $table->string('sexo'); // Macho, Fêmea
            $table->string('porte')->nullable(); // ← DA SEGUNDA
            $table->integer('idade')->nullable(); // ← DA SEGUNDA
            $table->string('cor');

            // Situação REAL do animal
            $table->enum('situacao', ['perdido', 'encontrado'])->default('perdido');

            // Descrição geral (COMBINANDO AMBOS)
            $table->text('caracteristicas')->nullable(); // ← DA SEGUNDA
            $table->text('descricao')->nullable();

            // Imagens
            $table->json('imagens')->nullable(); // Array de imagens em JSON
            $table->string('foto')->nullable(); // ← Campo legado da segunda

            // Localização (COMPLETA)
            $table->string('cidade');
            $table->string('bairro');
            $table->string('rua')->nullable(); // ← DA SEGUNDA

            // Dados específicos de animais perdidos (DA PRIMEIRA + SEGUNDA)
            $table->string('ultimo_local_visto')->nullable();
            $table->string('endereco_desaparecimento')->nullable();
            $table->date('data_desaparecimento')->nullable(); // ← CORRIGIDO: date em vez de string

            // Dados específicos de animais encontrados (DA PRIMEIRA)
            $table->string('local_encontro')->nullable();
            $table->string('endereco_encontro')->nullable();
            $table->date('data_encontro')->nullable(); // ← CORRIGIDO: date em vez de string
            $table->string('situacao_saude')->nullable();
            $table->string('contato_responsavel')->nullable();

            // Status do REGISTRO no sistema
            $table->enum('status', [
                'ativo',
                'inativo',
                'resolvido',
                'pendente',
                'recusado'
            ])->default('pendente'); // ← Mantive 'pendente' da primeira como padrão

            // Soft delete manual
            $table->boolean('ativo')->default(true); // ← DA SEGUNDA

            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('animais');
    }
};