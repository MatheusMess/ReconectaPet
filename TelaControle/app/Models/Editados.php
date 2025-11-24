<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Editados extends Model
{
    use HasFactory;

    protected $table = 'editados';

    protected $fillable = [
        'animal_id',
        'user_id',
        
        // Campos básicos
        'n_nome',
        'n_raca', 
        'n_cor',
        'n_especie',
        'n_sexo',
        'n_descricao',
        
        // Situação e status
        'n_situacao',
        'n_status',
        
        // Localização
        'n_cidade',
        'n_bairro',
        
        // Campos para perdidos
        'n_ultimo_local_visto',
        'n_endereco_desaparecimento', 
        'n_data_desaparecimento',
        
        // Campos para encontrados
        'n_local_encontro',
        'n_endereco_encontro',
        'n_data_encontro',
        'n_situacao_saude',
        
        // Imagens
        'n_imagem1',
        'n_imagem2',
        'n_imagem3',
        'n_imagem4',
        
        // Status da edição
        'status',
    ];

    protected $casts = [
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    /**
     * Relacionamento com o animal original
     */
    public function animal()
    {
        return $this->belongsTo(Animal::class, 'animal_id');
    }

    /**
     * Relacionamento com usuário que editou
     */
    public function user()
    {
        return $this->belongsTo(Usuario::class, 'user_id');
    }

    /**
     * Scope para edições pendentes
     */
    public function scopePendentes($query)
    {
        return $query->where('status', 'pendente');
    }

    /**
     * Scope para edições aprovadas
     */
    public function scopeAprovadas($query)
    {
        return $query->where('status', 'aprovado');
    }

    /**
     * Scope para edições rejeitadas
     */
    public function scopeRejeitadas($query)
    {
        return $query->where('status', 'rejeitado');
    }

    /**
     * Verifica se está pendente
     */
    public function isPendente()
    {
        return $this->status === 'pendente';
    }

    /**
     * Aprovar edição
     */
    public function aprovar()
    {
        $this->status = 'aprovado';
        return $this->save();
    }

    /**
     * Rejeitar edição
     */
    public function rejeitar()
    {
        $this->status = 'rejeitado';
        return $this->save();
    }

    /**
     * Aplicar edições ao animal original - CORRIGIDO para bater com Animal
     */
    public function aplicarEdicoes()
    {
        $animal = $this->animal;

        // ✅ CAMPOS BÁSICOS - CORRESPONDÊNCIA DIRETA
        if ($this->n_nome) $animal->nome = $this->n_nome;
        if ($this->n_raca) $animal->raca = $this->n_raca;
        if ($this->n_cor) $animal->cor = $this->n_cor;
        if ($this->n_especie) $animal->especie = $this->n_especie;
        if ($this->n_sexo) $animal->sexo = $this->n_sexo;
        if ($this->n_descricao) $animal->descricao = $this->n_descricao;
        
        // ✅ SITUAÇÃO E STATUS
        if ($this->n_situacao) $animal->situacao = $this->n_situacao;
        if ($this->n_status) $animal->status = $this->n_status;
        
        // ✅ LOCALIZAÇÃO
        if ($this->n_cidade) $animal->cidade = $this->n_cidade;
        if ($this->n_bairro) $animal->bairro = $this->n_bairro;

        // ✅ CAMPOS PARA ANIMAIS PERDIDOS
        if ($this->n_ultimo_local_visto) $animal->ultimo_local_visto = $this->n_ultimo_local_visto;
        if ($this->n_endereco_desaparecimento) $animal->endereco_desaparecimento = $this->n_endereco_desaparecimento;
        if ($this->n_data_desaparecimento) $animal->data_desaparecimento = $this->n_data_desaparecimento;

        // ✅ CAMPOS PARA ANIMAIS ENCONTRADOS  
        if ($this->n_local_encontro) $animal->local_encontro = $this->n_local_encontro;
        if ($this->n_endereco_encontro) $animal->endereco_encontro = $this->n_endereco_encontro;
        if ($this->n_data_encontro) $animal->data_encontro = $this->n_data_encontro;
        if ($this->n_situacao_saude) $animal->situacao_saude = $this->n_situacao_saude;

        // ✅ PROCESSAR IMAGENS
        $this->processarImagens($animal);

        $animal->save();
        $this->aprovar();

        return $animal;
    }

    /**
     * Processar atualização de imagens
     */
    private function processarImagens(Animal $animal)
    {
        $novasImagens = [];

        // Adicionar novas imagens (n_imagem1 a n_imagem4)
        for ($i = 1; $i <= 4; $i++) {
            $campoImagem = "n_imagem{$i}";
            if ($this->$campoImagem) {
                $novasImagens[] = $this->$campoImagem;
            }
        }

        // Se há novas imagens, substituir as existentes
        if (!empty($novasImagens)) {
            $animal->imagens = json_encode($novasImagens);
        }
    }

    /**
     * Accessor para dados formatados (útil para APIs)
     */
    public function getDadosFormatadosAttribute()
    {
        return [
            'nome' => $this->n_nome,
            'raca' => $this->n_raca,
            'cor' => $this->n_cor,
            'especie' => $this->n_especie,
            'sexo' => $this->n_sexo,
            'descricao' => $this->n_descricao,
            'situacao' => $this->n_situacao,
            'status' => $this->n_status,
            'cidade' => $this->n_cidade,
            'bairro' => $this->n_bairro,
            'ultimo_local_visto' => $this->n_ultimo_local_visto,
            'endereco_desaparecimento' => $this->n_endereco_desaparecimento,
            'data_desaparecimento' => $this->n_data_desaparecimento,
            'local_encontro' => $this->n_local_encontro,
            'endereco_encontro' => $this->n_endereco_encontro,
            'data_encontro' => $this->n_data_encontro,
            'situacao_saude' => $this->n_situacao_saude,
        ];
    }

    /**
     * Verifica se há alterações pendentes para um animal
     */
    public static function temEdicaoPendente($animalId)
    {
        return self::where('animal_id', $animalId)
                  ->pendentes()
                  ->exists();
    }
}