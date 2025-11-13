<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Animal extends Model
{
    use HasFactory;

    /**
     * O nome da tabela associada ao model.
     *
     * @var string
     */
    protected $table = 'animais';
    protected $fillable = [
        'nome',
        'tipo',
        'raca',
        'tam',
        'sexo',
        'cor',
        'aparencia',
        'lugar_visto',
        'lugar_encontrado',
        'situacao',
        'status',
        'usuario_id', // se existir relacionamento com usuário
    ];
}
