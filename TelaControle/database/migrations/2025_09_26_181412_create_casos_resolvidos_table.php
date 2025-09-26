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
        Schema::create('casos_resolvidos', function (Blueprint $table) {
            $table->id();
            $table->foreignId('animal_id')->constrained('animais')->onDelete('cascade');
            $table->foreignId('user_id')->constrained('users')->comment('Usuário que marcou o caso como resolvido');
            $table->text('detalhes_resolucao')->nullable()->comment('Detalhes sobre como o animal foi encontrado ou devolvido');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('casos_resolvidos');
    }
};
