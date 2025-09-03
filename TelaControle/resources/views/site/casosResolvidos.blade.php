
@extends('site.layout')
@section('title','Casos Resolvidos')
@section('conteudo')
	<div class="container mt-4">
		<h2 class="mb-4">Casos Resolvidos</h2>
		<div class="row">
			@php
				$animais = [
					[
						'tipo' => 'Cachorro',
						'nome' => 'Muttley',
						'raca' => 'Vira-Lata',
						'cor' => 'Caramelo',
						'sexo' => 'Macho',
						'imagem' => 'https://assets.brasildefato.com.br/2024/09/image_processing20210113-1654-11x5azn-750x533.jpeg',
					],
					[
						'tipo' => 'Gato',
						'nome' => 'Mel',
						'raca' => 'Maine Coon',
						'cor' => 'Cinza',
						'sexo' => 'Fêmea',
						'imagem' => 'https://cdn2.thecatapi.com/images/MTY3ODIyMQ.jpg',
					],
					[
						'tipo' => 'Cachorro',
						'nome' => 'Bob',
						'raca' => 'Bulldog Francês',
						'cor' => 'Branco e preto',
						'sexo' => 'Macho',
						'imagem' => 'https://cdn.los-animales.org/fotos/419525000_7168619_thumb.jpg',
					],
					[
						'tipo' => 'Gato',
						'nome' => 'Garfield',
						'raca' => 'Persa',
						'cor' => 'Laranja',
						'sexo' => 'Macho',
						'imagem' => 'https://preview.redd.it/my-orange-boi-possibly-the-dumbest-cat-ive-ever-met-v0-dvlbpo59778e1.jpg?width=640&crop=smart&auto=webp&s=02577195da76385188ee80759548bf2a07f866b7',
					],
				];
			@endphp
            <x-lista :animais="$animais" :showActions="false" />
		</div>
	</div>
@endsection