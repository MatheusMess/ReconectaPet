@extends('site.layout')
@section('title','Casos Editados')

@section('conteudo')
    <h2 class="mb-4" id="titulo">Casos Editados - Aguardando Aprovação</h2>
    
    <div class="row">
        @if($editados->count() > 0)
            @foreach($editados as $editado)
                <div class="col s12 m6 l4">
                    <div class="card">
                        <div class="card-image">
                            @php
                                // Buscar primeira imagem (nova sugerida OU original)
                                $primeiraImagem = asset('images/animais/noimg.jpg');
                                
                                // Tentar imagens novas primeiro
                                for ($i = 1; $i <= 4; $i++) {
                                    $campo = "n_imagem{$i}";
                                    if ($editado->$campo) {
                                        $primeiraImagem = $editado->$campo;
                                        break;
                                    }
                                }
                                
                                // Se não tem imagem nova, tentar do animal original
                                if ($primeiraImagem === asset('images/animais/noimg.jpg') && $editado->animal && $editado->animal->imagens) {
                                    $images = is_array($editado->animal->imagens) 
                                        ? $editado->animal->imagens 
                                        : json_decode($editado->animal->imagens, true);
                                    
                                    if (is_array($images) && count($images) > 0) {
                                        $primeiraItem = $images[0];
                                        if (is_string($primeiraItem)) {
                                            $primeiraImagem = filter_var($primeiraItem, FILTER_VALIDATE_URL) 
                                                ? $primeiraItem 
                                                : asset($primeiraItem);
                                        }
                                    }
                                }
                            @endphp
                            
                            <img src="{{ $primeiraImagem }}" alt="{{ $editado->n_nome ?? $editado->animal->nome ?? 'Animal' }}"
                                 onerror="this.src='{{ asset('images/animais/noimg.jpg') }}'">
                            
                            <span class="card-title" style="background: rgba(0,0,0,0.5); padding: 10px;">
                                <b>{{ $editado->n_nome ?? $editado->animal->nome ?? '(Sem nome)' }}</b>
                            </span>

                            {{-- Botão Ver Detalhes --}}
                            <a href="{{ route('detalhes.ce.view', $editado->id) }}" 
                               class="btn-floating halfway-fab waves-effect waves-light blue">
                               <i class="material-icons">visibility</i>
                            </a>
                        </div>

                        <div class="card-content">
                            <ul class="info">
                                <li><b>Situação:</b> {{ $editado->n_situacao ?? $editado->animal->situacao ?? 'N/A' }}</li>
                                <li><b>Animal:</b> {{ $editado->n_especie ?? $editado->animal->especie ?? 'N/A' }}</li>
                                <li><b>Sexo:</b> {{ $editado->n_sexo ?? $editado->animal->sexo ?? 'N/A' }}</li>
                                <li><b>Status:</b> <span class="blue-text">{{ ucfirst($editado->status ?? 'pendente') }}</span></li>
                                <li><b>Editado por:</b> {{ $editado->user->name ?? 'N/A' }}</li>
                            </ul>
                        </div>

                        {{-- Botões de Aprovação --}}
                        <div class="card-action center-align">
                            <form action="{{ route('editar.aprovar', $editado->id) }}" method="POST" style="display: inline;">
                                @csrf
                                @method('PUT')
                                <button type="submit" class="btn waves-effect waves-light green">
                                    <i class="material-icons left">check</i>
                                    Aprovar
                                </button>
                            </form>
                            
                            <form action="{{ route('editar.rejeitar', $editado->id) }}" method="POST" style="display: inline;">
                                @csrf
                                @method('PUT')
                                <button type="submit" class="btn waves-effect waves-light red">
                                    <i class="material-icons left">close</i>
                                    Rejeitar
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            @endforeach
        @else
            <div class="col s12 center-align">
                <div class="card-panel blue lighten-4 blue-text text-darken-2">
                    <i class="material-icons large">edit</i>
                    <h5>Nenhum caso editado</h5>
                    <p>Não há edições aguardando aprovação no momento.</p>
                </div>
            </div>
        @endif
    </div>
@endsection