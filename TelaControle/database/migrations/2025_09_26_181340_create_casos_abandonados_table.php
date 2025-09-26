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
        Schema::create('casos_abandonados', function (Blueprint $table) {
            $table->id();
            $table->foreignId('animal_id')->constrained('animais')->onDelete('cascade');
            $table->foreignId('user_id')->constrained('users')->comment('Usuário que abandonou o caso');
            $table->text('motivo')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('casos_abandonados');
    }
};
