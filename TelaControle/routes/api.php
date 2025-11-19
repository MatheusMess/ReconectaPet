<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\AnimalController;

// ===============================
// ROTAS DE AUTENTICAÇÃO
// ===============================
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/check-email', [AuthController::class, 'checkEmail']);
Route::post('/logout', [AuthController::class, 'logout']);

// ===============================
// ROTAS DE ANIMAIS (API)
// ===============================
Route::get('/animais', [AnimalController::class, 'apiTodosAnimais']);
Route::get('/animais/{id}', [AnimalController::class, 'show']);
Route::post('/animais', [AnimalController::class, 'store']);
Route::put('/animais/{id}', [AnimalController::class, 'update']);
Route::delete('/animais/{id}', [AnimalController::class, 'destroy']);

// ===============================
// ROTAS ADICIONAIS DA API
// ===============================
Route::get('/animais/tipo/{tipo}', [AnimalController::class, 'animaisPorTipo']);
Route::get('/animais/user/{userId}', [AnimalController::class, 'animaisPorUsuario']);

// ===============================
// TESTE DE AUTENTICAÇÃO
// ===============================
Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});