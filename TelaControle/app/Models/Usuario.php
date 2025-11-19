<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class Usuario extends Authenticatable
{
    use HasFactory, Notifiable;

    protected $table = 'usuarios';

    protected $fillable = [
        'nome',
        'email',
        'tel', 
        'cpf',
        'senha',
        'adm',
    ];

    protected $hidden = [
        'senha',
        'remember_token',
    ];

    /**
     * Get the name of the password attribute for the user.
     *
     * @return string
     */
    public function getAuthPassword()
    {
        return $this->senha;
    }

    /**
     * Get the column name for the "remember me" token.
     *
     * @return string
     */
    public function getRememberTokenName()
    {
        return 'remember_token';
    }

    /**
     * Relacionamento com animais
     */
    public function animais()
    {
        return $this->hasMany(Animal::class, 'user_id');
    }

    /**
     * Scope para buscar usuário por email
     */
    public function scopePorEmail($query, $email)
    {
        return $query->where('email', $email);
    }

    /**
     * Verificar se usuário é administrador
     */
    public function isAdmin()
    {
        return $this->adm === true;
    }

    /**
     * Atributos que devem ser convertidos
     */
    protected $casts = [
        'adm' => 'boolean',
        'email_verified_at' => 'datetime',
    ];

    /**
     * Mutator para o campo email - sempre salvar em minúsculo
     */
    public function setEmailAttribute($value)
    {
        $this->attributes['email'] = strtolower($value);
    }

    /**
     * Mutator para o campo CPF - remover formatação
     */
    public function setCpfAttribute($value)
    {
        $this->attributes['cpf'] = preg_replace('/[^0-9]/', '', $value);
    }

    /**
     * Mutator para o campo telefone - remover formatação
     */
    public function setTelAttribute($value)
    {
        $this->attributes['tel'] = preg_replace('/[^0-9]/', '', $value);
    }

    /**
     * Accessor para o campo CPF - formatar na exibição
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
     * Accessor para o campo telefone - formatar na exibição
     */
    public function getTelefoneFormatadoAttribute()
    {
        $tel = $this->tel;
        if (strlen($tel) === 11) {
            return '(' . substr($tel, 0, 2) . ') ' . substr($tel, 2, 5) . '-' . substr($tel, 7, 4);
        } elseif (strlen($tel) === 10) {
            return '(' . substr($tel, 0, 2) . ') ' . substr($tel, 2, 4) . '-' . substr($tel, 6, 4);
        }
        return $tel;
    }

    /**
     * Verificar se a senha está correta
     */
    public function verificarSenha($password)
    {
        return Hash::check($password, $this->senha);
    }

    /**
     * Buscar usuário por email
     */
    public static function buscarPorEmail($email)
    {
        return static::porEmail($email)->first();
    }

    /**
     * Verificar se email já existe
     */
    public static function emailExiste($email)
    {
        return static::porEmail($email)->exists();
    }

    /**
     * Verificar se CPF já existe
     */
    public static function cpfExiste($cpf)
    {
        $cpfLimpo = preg_replace('/[^0-9]/', '', $cpf);
        return static::where('cpf', $cpfLimpo)->exists();
    }
}