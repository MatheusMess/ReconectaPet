<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\CasoPendenteController;

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