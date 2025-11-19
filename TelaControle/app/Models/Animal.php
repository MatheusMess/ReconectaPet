<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Animal extends Model
{
    use HasFactory;

    protected $table = 'animais';

    protected $fillable = [
        'user_id',
        'nome',
        'especie',
        'raca',
        'sexo',
        'porte',
        'idade',
        'cor',
        'situacao',
        'caracteristicas',
        'descricao',
        'imagens',
        'foto',
        'cidade',
        'bairro',
        'rua',
        'ultimo_local_visto',
        'endereco_desaparecimento',
        'data_desaparecimento',
        'status',
        'ativo',
    ];

    protected $casts = [
        'imagens' => 'array', // importante por ser JSON
        'data_desaparecimento' => 'date',
        'ativo' => 'boolean',
    ];

    // Dono do anúncio (FK: user_id → usuarios)
    public function usuario()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
