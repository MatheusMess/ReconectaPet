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

            // Dados básicos do animal
            $table->string('nome')->nullable();
            $table->string('especie');
            $table->string('raca')->nullable();
            $table->string('sexo')->nullable();
            $table->string('porte')->nullable();
            $table->integer('idade')->nullable();
            $table->string('cor')->nullable();

            // Situação REAL do animal
            // (perdido, encontrado, desaparecido, resgatado, adocao, adotado)
            $table->enum('situacao', [
                'perdido',
                'encontrado',
            ])->default('perdido');

            // Descrição geral
            $table->text('caracteristicas')->nullable();
            $table->text('descricao')->nullable();

            // Lista de imagens (para Flutter)
            $table->json('imagens')->nullable();

            // Campo legado (se quiser manter)
            $table->string('foto')->nullable();

            // Localização
            $table->string('cidade')->nullable();
            $table->string('bairro')->nullable();
            $table->string('rua')->nullable();

            // Dados específicos de animais perdidos
            $table->string('ultimo_local_visto')->nullable();
            $table->string('endereco_desaparecimento')->nullable();
            $table->date('data_desaparecimento')->nullable();

            // Status do REGISTRO no sistema - CORRIGIDO
            // (não confundir com situacao do animal)
            $table->enum('status', [
                'ativo',
                'inativo',      // ← CORRIGIDO: 'arquivado' → 'inativo'
                'resolvido',
                'pendente'
            ])->default('ativo');

            // Soft delete manual
            $table->boolean('ativo')->default(true);

            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('animais');
    }
};