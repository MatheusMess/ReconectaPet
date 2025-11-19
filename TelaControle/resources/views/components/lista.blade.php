@php
    $urlDetalhes = url('d' . trim(request()->path(), '/'));
@endphp

@if(!$usuario)
    @foreach($informacoes as $animal)
        <div class="col-md-6 col-lg-4 mb-4">
            <div id="item" class="card h-100">
                <div class="img">
                    {{-- CORRIGIDO: usando array de imagens --}}
                    @php $images = $animal->imagens ?? []; @endphp
                    <img src="{{ $images[0] ?? asset('images/animais/noimg.jpg') }}" class="card-img-top" alt="Imagem do {{ $animal->especie }}">
                </div>
                <div class="card-body">
                    <h5 class="card-title">{{ $animal->nome ?? '(Sem coleira)' }}</h5>
                    <ul class="list-unstyled mb-3">
                        {{-- CORRIGIDO: campos reais do modelo --}}
                        <li><strong>Animal:</strong> {{ $animal->especie }}</li>
                        <li><strong>Raça:</strong> {{ $animal->raca }}</li>
                        <li><strong>Cor:</strong> {{ $animal->cor }}</li>
                        <li><strong>Sexo:</strong> {{ $animal->sexo }}</li>
                        <li><strong>Situação:</strong> {{ $animal->situacao ?? 'Não informada' }}</li>
                    </ul>
                    <div id="btns" class="d-flex justify-content-between">
                        <form action="{{$urlDetalhes}}" method="POST" style="display: inline;">
                            @csrf
                            <input type="hidden" name="id" value="{{ $animal->id }}">
                            <button id="det" type="submit" class="btn btn-primary">Ver Detalhes</button>
                        </form>

                        @if($showActions)
                            <button id="ace" class="btn btn-accept" data-id="{{ $animal->id }}">Aceitar</button>
                            <button id="rej" class="btn btn-reject" data-id="{{ $animal->id }}">Recusar</button>
                        @endif
                    </div>
                </div>
            </div>
        </div>
    @endforeach
@else
    {{-- Seção para usuários --}}
    @foreach($informacoes as $usuario)
        <div class="col-md-6 col-lg-4 mb-4">
            <div id="item" class="card h-100">
                <div class="img">
                    <img src="{{ file_exists(public_path('images/usuarios/'.$usuario->id.'.png')) ? asset('images/usuarios/'.$usuario->id.'.png') : asset('images/usuarios/1.png') }}" class="card-img-top" alt="Imagem do usuário">
                </div>
                <div class="card-body">
                    <h5 class="card-title">{{ $usuario->nome }}</h5>
                    <ul class="list-unstyled mb-3">
                        <li><strong>Email:</strong> {{ $usuario->email }}</li>
                        <li><strong>Telefone:</strong> {{ $usuario->tel }}</li>
                        <li><strong>CPF:</strong> {{ $usuario->cpf }}</li>
                        <li><strong>Tipo:</strong> {{ $usuario->adm ? 'Administrador' : 'Usuário' }}</li>
                    </ul>
                    <div id="btns" class="d-flex justify-content-between">
                        <form action="{{$urlDetalhes}}" method="POST" style="display: inline;">
                            @csrf
                            <input type="hidden" name="id" value="{{ $usuario->id }}">
                            <button id="det" type="submit" class="btn btn-primary">Ver Detalhes</button>
                        </form>
                        <button id="rej" class="btn btn-reject" data-id="{{ $usuario->id }}">Banir Usuário</button>
                    </div>
                </div>
            </div>
        </div>
    @endforeach
@endif