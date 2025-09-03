<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('site.inicio');
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
Route::get('/dcr', function () {
    return view('site.detalhesCR');
});
Route::get('/dca', function () {
    return view('site.detalhesCA');
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