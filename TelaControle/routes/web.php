<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AnimalController;
use App\Http\Controllers\UsuarioController;

// ===============================
// ROTAS PRINCIPAIS
// ===============================
Route::get('/', function () {
    return view('site.index');
});

// ===============================
// ROTAS DE LISTAGEM
// ===============================
Route::get('/animais-perdidos', [AnimalController::class, 'listarPerdidos'])
    ->name('AnimaisPerdidos');

Route::get('/animais-encontrados', [AnimalController::class, 'listarEncontrados'])
    ->name('AnimaisEncontrados');

// Novos casos
Route::get('/n-animais-perdidos', [AnimalController::class, 'listarNPerdidos'])
    ->name('site.listaNPerdidos');

Route::get('/n-animais-encontrados', [AnimalController::class, 'listarNEncontrados'])
    ->name('site.listaNEncontrados');

// Casos resolvidos, inativados e editados
Route::get('/casos-resolvidos', [AnimalController::class, 'listarResolvidos'])
    ->name('CasosResolvidos');

Route::get('/casos-inativados', [AnimalController::class, 'listarInativados'])
    ->name('CasosInativados');

Route::get('/casos-editados', [AnimalController::class, 'listarEditados'])
    ->name('CasosEditados');

// Todos os animais
Route::get('/todos-animais', [AnimalController::class, 'todosAnimais'])
    ->name('todos.animais');


// =======================================================
// ROTAS DE DETALHES  (GET = tela, POST = ação)
// =======================================================

// Detalhes gerais
Route::get('/detalhes-do-animal/{id}', [AnimalController::class, 'viewDetalhe'])
    ->name('animal.detalhes.view');

Route::post('/detalhes-do-animal', [AnimalController::class, 'DetalheAnimal'])
    ->name('animal.detalhes');


// Detalhes — novos encontrados
Route::get('/dn-animais-encontrados/{id}', [AnimalController::class, 'viewDNEncontrados'])
    ->name('site.DNEncontrados.view');

Route::post('/dn-animais-encontrados', [AnimalController::class, 'DNEncontrados'])
    ->name('site.DNEncontrados');


// Detalhes — novos perdidos
Route::get('/dn-animais-perdidos/{id}', [AnimalController::class, 'viewDNPerdidos'])
    ->name('site.DNPerdidos.view');

Route::post('/dn-animais-perdidos', [AnimalController::class, 'DNPerdidos'])
    ->name('site.DNPerdidos');


// Detalhes — Casos Editados
Route::get('/detalhes-ce/{id}', [AnimalController::class, 'viewDetalhesCE'])
    ->name('detalhes.ce.view');

Route::post('/detalhes-ce', [AnimalController::class, 'detalhesCE'])
    ->name('detalhes.ce');


// =======================================================
// AÇÕES SOBRE ANIMAIS — SEMPRE POST
// =======================================================
Route::post('/aceitar-caso',   [AnimalController::class, 'aceitar'])->name('animal.aceitar');
Route::post('/recusar-caso',   [AnimalController::class, 'recusar'])->name('animal.recusar');
Route::post('/resolver-caso',  [AnimalController::class, 'resolver'])->name('animal.resolver');
Route::post('/inativar-caso',  [AnimalController::class, 'inativar'])->name('animal.inativar');
Route::post('/reativar-caso',  [AnimalController::class, 'reativar'])->name('animal.reativar');


// ===============================
// ROTAS DE USUÁRIOS
// ===============================
Route::get('/usuarios', [UsuarioController::class, 'listar'])
    ->name('usuarios.listar');


// ===============================
// TESTES (não obrigatórios)
// ===============================
Route::get('/ap', fn() => view('site.AnimaisPerdidos'));
Route::get('/ae', fn() => view('site.AnimaisEncontrados'));
