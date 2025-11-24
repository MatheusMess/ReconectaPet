@extends('site.layout')
@section('title','Lista de Usuários')
@section('conteudo')
    <div class="container mt-4">
        <h2 class="mb-4">Usuários Cadastrados</h2>
        
        {{-- Mensagens de Sucesso/Erro --}}
        @if(session('success'))
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                {{ session('success') }}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        @endif

        @if(session('error'))
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                {{ session('error') }}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        @endif

        {{-- ✅ DEBUG: Verificar se há usuários --}}
        <!-- DEBUG: Total de usuários = {{ $usuarios->count() }} -->

        <div class="row">
            @if($usuarios->count() > 0)
                {{-- ✅ USE A PROP 'animais' COM OS USUÁRIOS --}}
                <x-listagem :animais="$usuarios" :usuario="true" :showActions="true" />
            @else
                <div class="col-12 text-center">
                    <p class="text-muted">Nenhum usuário cadastrado.</p>
                </div>
            @endif
        </div>
    </div>
@endsection