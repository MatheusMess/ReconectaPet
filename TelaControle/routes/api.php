<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\AnimalController;
use App\Http\Controllers\EditadosController;
use App\Http\Controllers\UsuarioController;

// ===============================
// ROTAS DE AUTENTICAÇÃO
// ===============================
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/check-email', [AuthController::class, 'checkEmail']);
Route::post('/logout', [AuthController::class, 'logout']);
Route::put('/user/profile', [AuthController::class, 'updateProfile']);

// ===============================
// ROTAS DE RECUPERAÇÃO DE SENHA
// ===============================
Route::post('/esqueceu_senha', [AuthController::class, 'solicitarRecuperacaoSenha']);
Route::post('/verificar_codigo', [AuthController::class, 'verificarCodigoRecuperacao']);
Route::post('/redefinir_senha', [AuthController::class, 'redefinirSenha']);

// ===============================
// ROTAS DE ANIMAIS (API - FLUTTER)
// ===============================
Route::get('/animais', [AnimalController::class, 'index']);
Route::get('/animais/{id}', [AnimalController::class, 'show']);
Route::post('/animais', [AnimalController::class, 'store']);
Route::put('/animais/{id}', [AnimalController::class, 'update']);
Route::delete('/animais/{id}', [AnimalController::class, 'destroy']);

// ✅ AÇÕES ADMIN
Route::put('/animais/{id}/aprovar', [AnimalController::class, 'aprovarAnimal']);
Route::put('/animais/{id}/rejeitar', [AnimalController::class, 'rejeitarAnimal']);
Route::put('/animais/{id}/status', [AnimalController::class, 'atualizarStatusAnimal']);

// ===============================
// ROTAS DE EDIÇÕES (API - FLUTTER)
// ===============================
Route::prefix('editados')->group(function () {
    Route::get('/', [EditadosController::class, 'index']);
    Route::post('/', [EditadosController::class, 'store']); // ✅ ROTA QUE O FLUTTER USA
    Route::get('/minhas', [EditadosController::class, 'minhasEdicoes']);
    Route::get('/{id}', [EditadosController::class, 'show']);
    Route::put('/{id}/aprovar', [EditadosController::class, 'aprovar']);
    Route::put('/{id}/rejeitar', [EditadosController::class, 'rejeitar']);
});

// ===============================
// ROTAS DE USUÁRIOS (API - FLUTTER)
// ===============================
Route::prefix('usuarios')->group(function () {
    Route::get('/', [UsuarioController::class, 'index']);
    Route::get('/{id}', [UsuarioController::class, 'show']);
    Route::put('/{id}/banir', [UsuarioController::class, 'banir']);
    Route::put('/{id}/desbanir', [UsuarioController::class, 'desbanir']);
    Route::put('/{id}/tornar-admin', [UsuarioController::class, 'tornarAdmin']);
    Route::put('/{id}/remover-admin', [UsuarioController::class, 'removerAdmin']);
});

// ===============================
// ROTAS ADICIONAIS
// ===============================
Route::get('/animais/tipo/{tipo}', [AnimalController::class, 'animaisPorSituacao']);
Route::get('/animais/user/{userId}', [AnimalController::class, 'animaisPorUsuario']);

// ===============================
// ROTAS DE TESTE
// ===============================
Route::get('/teste-get', function () {
    return response()->json([
        'message' => '✅ API GET funcionando!',
        'status' => 'CSRF resolvido'
    ]);
});

Route::post('/teste-post', function (Request $request) {
    return response()->json([
        'message' => '✅ API POST funcionando!',
        'data_recebida' => $request->all()
    ]);
});

// ===============================
// ROTA DE SAÚDE
// ===============================
Route::get('/health', function () {
    return response()->json([
        'status' => 'online',
        'message' => 'API ReconectaPet funcionando!',
        'timestamp' => now()->toDateTimeString()
    ]);
});