
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
                                <a href="http://reconectpet.test/dca" class="btn btn-info">Ver detalhes</a>
                            </div>
                        </div>
                    </div>
                </div>
			@endforeach
		</div>
	</div>
@endsection