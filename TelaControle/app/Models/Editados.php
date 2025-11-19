<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Editado extends Model
{
    use HasFactory;

    protected $table = 'editados';

    protected $fillable = [
        'id',
        'n_nome',
        'n_tipo',
        'n_situacao',
        'n_raca',
        'n_cor',
        'n_tam',
        'n_sexo',
        'n_aparencia',
        'n_lugar_visto',
        'n_lugar_encontrado',
        'n_imagem1',
        'n_imagem2',
        'n_imagem3',
        'n_imagem4',
    ];

    /**
     * Relacionamento com o animal original
     */
    public function animal()
    {
        return $this->belongsTo(Animal::class, 'id');
    }
}