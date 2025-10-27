<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('animais', function (Blueprint $table) {
            $table->id();
            // Chave estrangeira para a tabela 'users'
            $table->foreignId('user_id')->constrained('usuarios')->onDelete('cascade');
            $table->string('nome')->nullable()->default('(sem coleira)');
            $table->enum('tipo', ['Gato', 'Cachorro', 'Outro'])->nullable();
            $table->enum('situacao', ['Perdido', 'Encontrado'])->nullable();
            $table->string('raca')->nullable();
            $table->string('cor')->nullable();
            $table->enum('tam', ['Pequeno', 'Medio', 'Grande'])->nullable();
            $table->enum('sexo', ['Macho', 'Fêmea'])->nullable();
            $table->text('aparencia')->nullable();
            $table->text('lugar_visto')->nullable();
            $table->text('lugar_encontrado')->nullable();
            $table->string('imagem1')->nullable();
            $table->string('imagem2')->nullable();
            $table->string('imagem3')->nullable();
            $table->string('imagem4')->nullable();
            $table->enum('status', ['ativo', 'inativo', 'resolvido','pendente'])->default('pendente');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('animais');
    }
};
