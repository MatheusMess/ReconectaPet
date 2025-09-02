
@extends('site.layout')
@section('title','Casos Resolvidos')
@section('conteudo')
    <style>
        img{
            width: 150px;
            height: 150px;
            object-fit: cover; 
            object-position: center; 
            border-radius: 100px;
        }
        .img{
            object-fit: cover; 
            object-position: center; 
            height: 150px;
            width: 150px;
        }
        #item{
            display: flex;
            padding: 2%;
            border-radius: 100px;
            align-items: center;
            justify-items: center;
            ul{
                width: 100%;
                display: flex;
                justify-content: space-evenly;
            }
            li{
                width: 225px;
                font-size: 20px;
                margin-left: 20px;
                margin-bottom: 20px;
            }
        }
        #animal{
            
            
        }
    </style>
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
			@foreach($animais as $animal)
				<div  class="col-md-6 col-lg-4 mb-4">
                    <div id="item" class="card h-100">
                        <div class="img"><img src="{{ $animal['imagem'] }}" class="card-img-top" alt="Imagem do {{ $animal['tipo'] }}"></div>
                        <div class="card-body">
                            <h5 class="card-title">{{ $animal['nome'] }}</h5>
                            <ul class="list-unstyled mb-3">
                                <li><strong>Animal:</strong> {{ $animal['tipo'] }}</li>
                                <li><strong>Raça:</strong> {{ $animal['raca'] }}</li>
                                <li><strong>Cor:</strong> {{ $animal['cor'] }}</li>
                                <li><strong>Sexo:</strong> {{ $animal['sexo'] }}</li>
                            </ul>
                            <div class="d-flex justify-content-between">
                                <a href="http://reconectpet.test/dcr" class="btn btn-info">Ver detalhes</a>
                            </div>
                        </div>
                    </div>
                </div>
			@endforeach
		</div>
	</div>
@endsection