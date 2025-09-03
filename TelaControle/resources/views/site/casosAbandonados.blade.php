
@extends('site.layout')
@section('title','Casos Resolvidos')
@section('conteudo')
	<div class="container mt-4">
		<h2 class="mb-4">Casos Abandonados</h2>
		<div class="row">
			@php
				$animais = [
					[
						'tipo' => 'Cachorro',
						'nome' => 'Thor',
						'raca' => 'Golden Retriever',
						'cor' => 'Dourado',
						'sexo' => 'Macho',
						'imagem' => 'https://images.dog.ceo/breeds/retriever-golden/n02099601_3004.jpg',
					],
                    [
                        'tipo' => 'Gato',
                        'nome' => 'Maya',
                        'raca' => 'Vira-Lata',
                        'cor' => 'Tigrado Cinza',
                        'sexo' => 'Fêmea',
                        'imagem' => 'https://cdn.shopify.com/s/files/1/0500/8965/6473/files/pexels-arina-krasnikova-7726295_480x480.jpg?v=1663249037',
                    ],
                    [
                        'tipo' => 'Cachorro',
                        'nome' => 'Rex',
                        'raca' => 'Pitbull',
                        'cor' => 'Cinza',
                        'sexo' => 'Macho',
                        'imagem' => 'https://i.ytimg.com/vi/sAWu14YKrLY/sddefault.jpg',
                    ],
                    [
                        'tipo' => 'Gato',
                        'nome' => 'Frajola',
                        'raca' => 'Vira-Lata',
                        'cor' => 'Preto e Branco',
                        'sexo' => 'Macho',
                        'imagem' => 'https://cobasiblog.blob.core.windows.net/production-ofc/2023/01/gato-preto-branco-frajola.png',
                    ],
				];
			@endphp
			<x-lista :animais="$animais" :showActions="false" />
		</div>
	</div>
@endsection