@extends('site.layout')
@section('title','Todos Animais')
@section('conteudo')
    <h3 id="titulo" class="center">Todos Animais</h3>

    @php
        $f = array_merge(
            ['situacao'=>'','status'=>'','animal'=>'','sexo'=>''],
            $filters ?? []
        );
    @endphp

    <div class="filtro-wrapper">
        <form id="filtro" action="{{ route('todos.animais') }}" method="GET" class="row" style="margin-bottom:20px;">
            <div class="input-field col s12 m3 itens_filtro">
                <select name="situacao">
                    <option value="" {{ $f['situacao']=='' ? 'selected' : '' }}>Todos</option>
                    <option value="Encontrado" {{ $f['situacao']=='Encontrado' ? 'selected' : '' }}>Encontrado</option>
                    <option value="Perdido" {{ $f['situacao']=='Perdido' ? 'selected' : '' }}>Perdido</option>
                </select>
                <label><b>Situação</b></label>
            </div>

            <div class="input-field col s12 m3 itens_filtro">
                <select name="status">
                    <option value="" {{ $f['status']=='' ? 'selected' : '' }}>Todos</option>
                    <option value="ativo" {{ $f['status']=='ativo' ? 'selected' : '' }}>Ativo</option>
                    <option value="inativo" {{ $f['status']=='inativo' ? 'selected' : '' }}>Inativado</option>
                    <option value="pendente" {{ $f['status']=='pendente' ? 'selected' : '' }}>Pendente</option>
                    <option value="resolvido" {{ $f['status']=='resolvido' ? 'selected' : '' }}>Resolvido</option>
                </select>
                <label><b>Status</b></label>
            </div>

            <div class="input-field col s12 m3 itens_filtro">
                <select name="animal">
                    <option value="" {{ $f['animal']=='' ? 'selected' : '' }}>Todos</option>
                    <option value="Gato" {{ $f['animal']=='Gato' ? 'selected' : '' }}>Gato</option>
                    <option value="Cachorro" {{ $f['animal']=='Cachorro' ? 'selected' : '' }}>Cachorro</option>
                </select>
                <label><b>Animal</b></label>
            </div>

            <div class="input-field col s12 m2 itens_filtro">
                <select name="sexo">
                    <option value="" {{ $f['sexo']=='' ? 'selected' : '' }}>Todos</option>
                    <option value="Macho" {{ $f['sexo']=='Macho' ? 'selected' : '' }}>Macho</option>
                    <option value="Fêmea" {{ $f['sexo']=='Fêmea' ? 'selected' : '' }}>Fêmea</option>
                </select>
                <label><b>Sexo</b></label>
            </div>

            <div class="col s12 m1" style="display:flex;align-items:center;">
                <button type="submit" class="btn">Filtrar</button>
            </div>

            <div class="col s12 m1" style="display:flex;align-items:center;">
                <a href="{{ route('todos.animais') }}" class="btn">Limpar</a>
            </div>
        </form>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var elems = document.querySelectorAll('select');
            var instances = M.FormSelect.init(elems, {
                coverSelect: false,
                constrainWidth: false
                
            });

        });
    </script>

    <x-listagem :animais="$animais" :info="1"/>
    @include('components.css.CSSfiltro')
    
@endsection