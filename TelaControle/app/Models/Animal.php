<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Animal extends Model
{
    use HasFactory;

    protected $table = 'animais';

    protected $fillable = [
        'nome', 'descricao', 'raca', 'cor', 'especie', 'sexo',
        'imagens', 'cidade', 'bairro', 'user_id', 'situacao', 'status',
        'local_encontro', 'endereco_encontro', 'data_encontro', 'situacao_saude',
        'ultimo_local_visto', 'endereco_desaparecimento', 'data_desaparecimento'
    ];

    // ✅✅✅ REMOVER COMPLETAMENTE OS CASTS DE DATA
    // Isso evita que o Laravel tente fazer parse automático
    protected $casts = [
        'imagens' => 'array'
        // Removidos: 'data_encontro' e 'data_desaparecimento'
    ];

    // ✅✅✅ CORREÇÃO CRÍTICA: RELACIONAMENTO CORRETO COM USUARIO
    public function user()
    {
        return $this->belongsTo(Usuario::class, 'user_id');
    }

    // ✅✅✅ MUTATORS PARA TRATAR AS DATAS COMO STRINGS
    public function setDataEncontroAttribute($value)
    {
        // Armazena como string pura, sem conversão
        $this->attributes['data_encontro'] = $value;
    }

    public function setDataDesaparecimentoAttribute($value)
    {
        // Armazena como string pura, sem conversão
        $this->attributes['data_desaparecimento'] = $value;
    }

    // ✅✅✅ ACCESSORS PARA FORMATAR DATAS NA HORA DA EXIBIÇÃO
    public function getDataEncontroFormatadaAttribute()
    {
        if (!$this->data_encontro) {
            return null;
        }

        // Se já estiver no formato BR, retorna como está
        if (preg_match('/^\d{2}\/\d{2}\/\d{4}$/', $this->data_encontro)) {
            return $this->data_encontro;
        }

        // Tenta converter de ISO para BR
        try {
            $date = \DateTime::createFromFormat('Y-m-d', $this->data_encontro);
            if ($date) {
                return $date->format('d/m/Y');
            }
        } catch (\Exception $e) {
            // Se falhar, retorna o valor original
        }

        return $this->data_encontro;
    }

    public function getDataDesaparecimentoFormatadaAttribute()
    {
        if (!$this->data_desaparecimento) {
            return null;
        }

        // Se já estiver no formato BR, retorna como está
        if (preg_match('/^\d{2}\/\d{2}\/\d{4}$/', $this->data_desaparecimento)) {
            return $this->data_desaparecimento;
        }

        // Tenta converter de ISO para BR
        try {
            $date = \DateTime::createFromFormat('Y-m-d', $this->data_desaparecimento);
            if ($date) {
                return $date->format('d/m/Y');
            }
        } catch (\Exception $e) {
            // Se falhar, retorna o valor original
        }

        return $this->data_desaparecimento;
    }

    // ✅✅✅ ACCESSOR CORRIGIDO PARA IMAGENS
    public function getImagensAttribute($value)
    {
        // Se estiver vazio, retorna imagem padrão
        if (empty($value)) {
            return [asset('images/animais/noimg.jpg')];
        }

        // Se já for um array, processa cada item
        if (is_array($value)) {
            return $this->processarArrayImagens($value);
        }

        // Tenta decodificar JSON
        try {
            $decoded = json_decode($value, true);
            if (json_last_error() === JSON_ERROR_NONE && is_array($decoded)) {
                return $this->processarArrayImagens($decoded);
            }
        } catch (\Exception $e) {
            // Continua com o processamento como string
        }

        // Processa como string única
        return $this->processarStringImagem($value);
    }

    /**
     * Processa array de imagens
     */
    private function processarArrayImagens(array $imagens)
    {
        return array_map(function($imagem) {
            return $this->formatarUrlImagem($imagem);
        }, array_filter($imagens));
    }

    /**
     * Processa string única de imagem
     */
    private function processarStringImagem($imagem)
    {
        if (empty($imagem)) {
            return [asset('images/animais/noimg.jpg')];
        }
        
        return [$this->formatarUrlImagem($imagem)];
    }

    /**
     * Formata URL da imagem corretamente
     */
    private function formatarUrlImagem($imagem)
    {
        // Se já for URL completa, mantém
        if (strpos($imagem, 'http://') === 0 || strpos($imagem, 'https://') === 0) {
            return $imagem;
        }

        // Se começar com storage/, usa asset('storage')
        if (strpos($imagem, 'storage/') === 0) {
            return asset($imagem);
        }

        // Se for caminho dentro de animais/, usa asset normalmente
        if (strpos($imagem, 'animais/') !== false) {
            return asset('storage/' . $imagem);
        }

        // Padrão - assume que está em storage/app/public/animais/
        return asset('storage/animais/' . basename($imagem));
    }

    // ✅ MUTATOR PARA SALVAR IMAGENS
    public function setImagensAttribute($value)
    {
        if (is_array($value)) {
            $this->attributes['imagens'] = json_encode(array_values($value));
        } else {
            $this->attributes['imagens'] = $value;
        }
    }

    // ✅ MÉTODOS AUXILIARES
    public function isPerdido()
    {
        return $this->situacao === 'perdido';
    }

    public function isEncontrado()
    {
        return $this->situacao === 'encontrado';
    }

    public function isAtivo()
    {
        return $this->status === 'ativo';
    }

    public function isPendente()
    {
        return $this->status === 'pendente';
    }

    public function getPrimeiraImagemAttribute()
    {
        $imagens = $this->imagens;
        return !empty($imagens) ? $imagens[0] : asset('images/animais/noimg.jpg');
    }

    public function getDescricaoResumidaAttribute()
    {
        if (strlen($this->descricao) > 100) {
            return substr($this->descricao, 0, 100) . '...';
        }
        return $this->descricao;
    }

    // ✅ SCOPES
    public function scopeAtivos($query)
    {
        return $query->where('status', 'ativo');
    }

    public function scopePendentes($query)
    {
        return $query->where('status', 'pendente');
    }

    public function scopePorSituacao($query, $situacao)
    {
        return $query->where('situacao', $situacao);
    }

    public function getDataFormatadaAttribute()
    {
        return $this->created_at->format('d/m/Y H:i');
    }

    // ✅ MÉTODO PARA API - RETORNA DATAS FORMATADAS
    public function toArray()
    {
        $array = parent::toArray();
        
        // Substitui as datas brutas pelas formatadas na resposta da API
        if (isset($array['data_encontro'])) {
            $array['data_encontro_formatada'] = $this->data_encontro_formatada;
        }
        
        if (isset($array['data_desaparecimento'])) {
            $array['data_desaparecimento_formatada'] = $this->data_desaparecimento_formatada;
        }
        
        return $array;
    }
}