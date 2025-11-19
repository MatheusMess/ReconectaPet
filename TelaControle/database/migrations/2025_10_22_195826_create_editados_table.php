<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('editados', function (Blueprint $table) {

            // animal que está sendo editado
            $table->id();
            $table->foreignId('animal_id')
                ->constrained('animais')
                ->onDelete('cascade');

            // Novos valores sugeridos (cópia fiel da tabela animais)
            $table->string('n_nome')->nullable();
            $table->string('n_especie')->nullable();
            $table->string('n_raca')->nullable();
            $table->string('n_sexo')->nullable();
            $table->string('n_porte')->nullable();
            $table->integer('n_idade')->nullable();
            $table->string('n_cor')->nullable();

            $table->text('n_caracteristicas')->nullable();
            $table->text('n_descricao')->nullable();

            // lista de imagens sugeridas
            $table->json('n_imagens')->nullable();

            // localização sugerida
            $table->string('n_cidade')->nullable();
            $table->string('n_bairro')->nullable();
            $table->string('n_rua')->nullable();

            // desaparecimento
            $table->string('n_ultimo_local_visto')->nullable();
            $table->string('n_endereco_desaparecimento')->nullable();
            $table->date('n_data_desaparecimento')->nullable();

            // status sugerido (enum atualizado)
            $table->enum('n_status', [
                'perdido',
                'encontrado',
                'desaparecido',
                'resgatado',
                'adocao',
                'adotado'
            ])->nullable();

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('editados');
    }
};
