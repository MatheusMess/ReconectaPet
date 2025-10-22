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
        Schema::create('editados', function (Blueprint $table) {
            // referência ao animal original
            $table->unsignedBigInteger('id');
            $table->primary('id');
            $table->foreign('id')->references('id')->on('animais')->onDelete('cascade');
            $table->string('n_nome')->nullable();

            $table->enum('n_tipo', ['Gato', 'Cachorro', 'Outro'])->nullable();
            $table->enum('n_situacao', ['Perdido', 'Encontrado'])->nullable();
            $table->string('n_raca')->nullable();
            $table->string('n_cor')->nullable();
            $table->enum('n_tam', ['Pequeno', 'Medio', 'Grande'])->nullable();
            $table->enum('n_sexo', ['Macho', 'Fêmea'])->nullable();
            $table->text('n_aparencia')->nullable();
            $table->text('n_lugar_visto')->nullable();
            $table->text('n_lugar_encontrado')->nullable();
            $table->string('n_imagem1')->nullable();
            $table->string('n_imagem2')->nullable();
            $table->string('n_imagem3')->nullable();
            $table->string('n_imagem4')->nullable();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('editados');
    }
};
