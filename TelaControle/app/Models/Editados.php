<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Editados extends Model
{
    /** @use HasFactory<\Database\Factories\UsuarioFactory> */
    use HasFactory;
    /**
     * @var string
     */
    protected $table = 'editados';
}
