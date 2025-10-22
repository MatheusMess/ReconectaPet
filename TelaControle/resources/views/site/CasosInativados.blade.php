
@extends('site.layout')
@section('title','Casos Resolvidos')
@section('conteudo')
		<h2 class="mb-4">Casos Inativados</h2>
			<x-listagem :animais="$animais" :info=2 />
	</div>
@endsection