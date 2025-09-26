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
        Schema::create('edicoes_pendentes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users');
            $table->foreignId('animal_id')->constrained('animais')->onDelete('cascade');
            $table->json('dados_originais');
            $table->json('dados_editados');
            $table->enum('status', ['pendente', 'aprovado', 'recusado'])->default('pendente');
            $table->text('motivo_recusa')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('edicoes_pendentes');
    }
};
