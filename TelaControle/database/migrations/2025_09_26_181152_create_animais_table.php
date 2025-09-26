<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateAnimaisTable extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('animais', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->string('nome')->nullable();
            $table->enum('tipo', ['Cachorro', 'Gato', 'Pássaro', 'Outro']);
            $table->enum('situacao', ['Perdido', 'Encontrado']);
            $table->string('raca')->nullable();
            $table->string('cor');
            $table->enum('tam', ['Pequeno', 'Médio', 'Grande']);
            $table->enum('sexo', ['Macho', 'Fêmea', 'Não identificado']);
            $table->text('aparencia')->nullable();
            $table->string('lugar_visto')->nullable();
            $table->string('lugar_encontrado')->nullable();
            $table->string('imagem1')->nullable();
            $table->string('imagem2')->nullable();
            $table->string('imagem3')->nullable();
            $table->string('imagem4')->nullable();
            $table->enum('status', ['ativo', 'inativo', 'resolvido'])->default('ativo');
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
