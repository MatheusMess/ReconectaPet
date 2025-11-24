<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('editados', function (Blueprint $table) {
            $table->id();
            
            // Referência ao animal original
            $table->foreignId('animal_id')
                ->constrained('animais')
                ->onDelete('cascade');
            
            // ✅ QUEM fez a edição
            $table->foreignId('user_id')
                ->constrained('usuarios')
                ->onDelete('cascade');

            // ✅ CAMPOS CORRESPONDENTES A TABELA ANIMAIS:
            
            // Campos básicos do animal
            $table->string('n_nome')->nullable();
            $table->string('n_raca')->nullable();
            $table->string('n_cor')->nullable();
            $table->enum('n_especie', ['Cachorro', 'Gato'])->nullable(); // ✅ ADICIONADO
            $table->enum('n_sexo', ['Macho', 'Fêmea'])->nullable();
            $table->text('n_descricao')->nullable(); // ✅ ADICIONADO (equivale a 'aparencia')
            
            // Situação e tipo (compatível com animais)
            $table->enum('n_situacao', ['perdido', 'encontrado'])->nullable(); // ✅ CORRIGIDO
            $table->string('n_status')->nullable(); // ✅ ADICIONADO
            
            // Localização
            $table->string('n_cidade')->nullable(); // ✅ ADICIONADO
            $table->string('n_bairro')->nullable(); // ✅ ADICIONADO

            // ✅ CAMPOS ESPECÍFICOS PARA PERDIDOS:
            $table->string('n_ultimo_local_visto')->nullable(); // ✅ CORRIGIDO (equivale a lugar_visto)
            $table->string('n_endereco_desaparecimento')->nullable(); // ✅ ADICIONADO
            $table->string('n_data_desaparecimento')->nullable(); // ✅ ADICIONADO

            // ✅ CAMPOS ESPECÍFICOS PARA ENCONTRADOS:
            $table->string('n_local_encontro')->nullable(); // ✅ CORRIGIDO (equivale a lugar_encontrado)
            $table->string('n_endereco_encontro')->nullable(); // ✅ ADICIONADO
            $table->string('n_data_encontro')->nullable(); // ✅ ADICIONADO
            $table->string('n_situacao_saude')->nullable(); // ✅ ADICIONADO

            // ✅ IMAGENS - mantendo sua estrutura atual
            $table->string('n_imagem1')->nullable();
            $table->string('n_imagem2')->nullable();
            $table->string('n_imagem3')->nullable();
            $table->string('n_imagem4')->nullable();

            // ✅ STATUS DA EDIÇÃO
            $table->enum('status', ['pendente', 'aprovado', 'rejeitado'])->default('pendente');

            $table->timestamps();

            // ✅ INDEX para performance
            $table->index(['animal_id', 'status']);
            $table->index(['user_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('editados');
    }
};