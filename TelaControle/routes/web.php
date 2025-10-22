<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\CasoPendenteController;
use App\Http\Controllers\AnimalController;

Route::get('/', function () {
    return view('site.index');
});



Route::get('/ap', function () {
    return view('site.AnimaisPerdidos');
});
Route::get('/ae', function () {
    return view('site.AnimaisEncontrados');
});




Route::get('/dap', function () {
    return view('site.detalhesAP');
});
Route::get('/dae', function () {
    return view('site.detalhesAE');
});
Route::get('/dnap', function () {
    return view('site.detalhesNAP');
});
Route::get('/dnae', function () {
    return view('site.detalhesNAE');
});
Route::get('/dcr', function () {
    return view('site.detalhesCR');
});
Route::get('/dca', function () {
    return view('site.detalhesCA');
});
Route::get('/dce', function () {
    return view('site.detalhesCE');
});



Route::get('/nap', function () {
    return view('site.listaNovosAP');
});
Route::get('/nae', function () {
    return view('site.listaNovosAE');
});



Route::get('/cr', function () {
    return view('site.casosResolvidos');
});
Route::get('/ca', function () {
    return view('site.casosAbandonados');
});
Route::get('/ce', function () {
    return view('site.casosEditados');
});

// Rota para listar novos animais encontrados pendentes de aprovação
Route::get('/nae2', [CasoPendenteController::class, 'indexEncontrados'])->name('admin.novos.encontrados');

// Rota para listar animais encontrados e ativos
Route::get('/n-animais-encontrados', [AnimalController::class, 'listarNEncontrados'])->name('site.listaNEncontrados');

// Altere esta rota para POST e remova o {id} da URL
Route::post('/dn-animais-encontrados', [AnimalController::class, 'DNEncontrados'])->name('site.DNEncontrados');

Route::get('/n-animais-perdidos', [AnimalController::class, 'listarNPerdidos'])->name('site.listaNPerdidos');

Route::post('/dn-animais-perdidos', [AnimalController::class, 'DNPerdidos'])->name('site.DNPerdidos');

Route::get('/todos-animais', [AnimalController::class, 'TodosAnimais'])->name('site.todosAnimais');
Route::post('/detalhes-do-animal', [AnimalController::class, 'DetalheAnimal'])->name('site.detalheAnimal');

Route::get('/animais-perdidos', [AnimalController::class, 'listarPerdidos'])->name('AnimaisPerdidos');
Route::get('/animais-encontrados', [AnimalController::class, 'listarEncontrados'])->name('AnimaisEncontrados');
Route::get('/casos-inativados', [AnimalController::class, 'listarInativados'])->name('CasosInativados');