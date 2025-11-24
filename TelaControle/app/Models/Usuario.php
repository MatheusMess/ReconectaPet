<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Usuario extends Model
{
    use HasFactory;

    protected $table = 'usuarios';

    protected $fillable = [
        'nome',
        'email',
        'tel',
        'cpf',
        'senha',
        'adm',
        'banido' // ✅ ADICIONADO campo banido
    ];

    protected $hidden = [
        'senha',
        'remember_token'
    ];

    protected $casts = [
        'adm' => 'boolean',
        'banido' => 'boolean' // ✅ CAST para boolean
    ];

    /**
     * Relacionamento com animais
     */
    public function animais()
    {
        return $this->hasMany(Animal::class, 'user_id');
    }

    /**
     * Scope para usuários não banidos
     */
    public function scopeNaoBanidos($query)
    {
        return $query->where('banido', false);
    }

    /**
     * Scope para usuários banidos
     */
    public function scopeBanidos($query)
    {
        return $query->where('banido', true);
    }

    /**
     * Scope para usuários ativos (não banidos)
     */
    public function scopeAtivos($query)
    {
        return $query->where('banido', false);
    }

    /**
     * Verifica se o usuário está banido
     */
    public function isBanido()
    {
        return $this->banido === true;
    }

    /**
     * Verifica se o usuário é administrador
     */
    public function isAdmin()
    {
        return $this->adm === true;
    }

    /**
     * Banir usuário
     */
    public function banir()
    {
        $this->banido = true;
        return $this->save();
    }

    /**
     * Desbanir usuário
     */
    public function desbanir()
    {
        $this->banido = false;
        return $this->save();
    }

    /**
     * Mutator para garantir que o email seja sempre lowercase
     */
    public function setEmailAttribute($value)
    {
        $this->attributes['email'] = strtolower($value);
    }

    /**
     * Mutator para formatar CPF (apenas números)
     */
    public function setCpfAttribute($value)
    {
        $this->attributes['cpf'] = preg_replace('/[^0-9]/', '', $value);
    }

    /**
     * Accessor para formatar CPF com pontuação
     */
    public function getCpfFormatadoAttribute()
    {
        $cpf = $this->cpf;
        if (strlen($cpf) === 11) {
            return substr($cpf, 0, 3) . '.' . substr($cpf, 3, 3) . '.' . substr($cpf, 6, 3) . '-' . substr($cpf, 9, 2);
        }
        return $cpf;
    }

    /**
     * Accessor para telefone formatado
     */
    public function getTelefoneFormatadoAttribute()
    {
        $telefone = $this->tel;
        if (strlen($telefone) === 11) {
            return '(' . substr($telefone, 0, 2) . ') ' . substr($telefone, 2, 5) . '-' . substr($telefone, 7, 4);
        } elseif (strlen($telefone) === 10) {
            return '(' . substr($telefone, 0, 2) . ') ' . substr($telefone, 2, 4) . '-' . substr($telefone, 6, 4);
        }
        return $telefone;
    }

    /**
     * Accessor para tipo de usuário
     */
    public function getTipoUsuarioAttribute()
    {
        if ($this->banido) {
            return 'Banido';
        }
        return $this->adm ? 'Administrador' : 'Usuário';
    }

    /**
     * Accessor para status do usuário
     */
    public function getStatusAttribute()
    {
        return $this->banido ? 'Banido' : 'Ativo';
    }
}