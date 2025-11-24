<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AnimalController;
use App\Http\Controllers\UsuarioController;
use App\Http\Controllers\EditadosController;
use Illuminate\Support\Facades\Mail;

// ===============================
// ROTAS PRINCIPAIS (PÁGINAS WEB)
// ===============================
Route::get('/', function () {
    return view('site.index');
});

// ===============================
// ROTAS DE LISTAGEM (WEB)
// ===============================
Route::get('/animais-perdidos', [AnimalController::class, 'listarPerdidos'])
    ->name('AnimaisPerdidos');

Route::get('/animais-encontrados', [AnimalController::class, 'listarEncontrados'])
    ->name('AnimaisEncontrados');

Route::get('/n-animais-perdidos', [AnimalController::class, 'listarNPerdidos'])
    ->name('site.listaNPerdidos');

Route::get('/n-animais-encontrados', [AnimalController::class, 'listarNEncontrados'])
    ->name('site.listaNEncontrados');

Route::get('/casos-resolvidos', [AnimalController::class, 'listarResolvidos'])
    ->name('CasosResolvidos');

Route::get('/casos-inativados', [AnimalController::class, 'listarInativados'])
    ->name('CasosInativados');

Route::get('/casos-editados', [EditadosController::class, 'listarEditados'])
    ->name('CasosEditados');

Route::get('/todos-animais', [AnimalController::class, 'todosAnimais'])
    ->name('todos.animais');

Route::get('/usuarios', [UsuarioController::class, 'listar'])
    ->name('usuarios.listar');

// =======================================================
// ROTAS DE DETALHES (WEB) - GET PARA VISUALIZAÇÃO
// =======================================================
Route::get('/detalhes-do-animal/{id}', [AnimalController::class, 'viewDetalhe'])
    ->name('animal.detalhes.view');

Route::get('/dn-animais-encontrados/{id}', [AnimalController::class, 'viewDNEncontrados'])
    ->name('site.DNEncontrados.view');

Route::get('/dn-animais-perdidos/{id}', [AnimalController::class, 'viewDNPerdidos'])
    ->name('site.DNPerdidos.view');

Route::get('/detalhes-ce/{id}', [EditadosController::class, 'detalhesEditado'])
    ->name('detalhes.ce.view');

Route::get('/detalhes-usuario/{id}', [UsuarioController::class, 'viewDetalhes'])
    ->name('usuario.detalhes.view');

// =======================================================
// ROTAS POST PARA COMPATIBILIDADE
// =======================================================
Route::post('/detalhes-do-animal', [AnimalController::class, 'DetalheAnimal'])
    ->name('animal.detalhes');

Route::post('/dn-animais-encontrados', [AnimalController::class, 'DNEncontrados'])
    ->name('site.DNEncontrados');

Route::post('/dn-animais-perdidos', [AnimalController::class, 'DNPerdidos'])
    ->name('site.DNPerdidos');

Route::post('/detalhes-ce', [EditadosController::class, 'detalhesCE'])
    ->name('detalhes.ce');

Route::post('/detalhes-usuario', [UsuarioController::class, 'detalhes'])
    ->name('usuario.detalhes');

// =======================================================
// AÇÕES SOBRE ANIMAIS
// =======================================================
Route::post('/aceitar-caso', [AnimalController::class, 'aceitar'])
    ->name('animal.aceitar');

Route::post('/recusar-caso', [AnimalController::class, 'recusar'])
    ->name('animal.recusar');

Route::post('/resolver-caso', [AnimalController::class, 'resolver'])
    ->name('animal.resolver');

Route::post('/inativar-caso', [AnimalController::class, 'inativar'])
    ->name('animal.inativar');

Route::post('/reativar-caso', [AnimalController::class, 'reativar'])
    ->name('animal.reativar');

// =======================================================
// AÇÕES SOBRE USUÁRIOS
// =======================================================
Route::post('/banir-usuario', [UsuarioController::class, 'banir'])
    ->name('usuario.banir');

Route::post('/desbanir-usuario', [UsuarioController::class, 'desbanir'])
    ->name('usuario.desbanir');

Route::post('/tornar-admin', [UsuarioController::class, 'tornarAdmin'])
    ->name('usuario.tornarAdmin');

Route::post('/remover-admin', [UsuarioController::class, 'removerAdmin'])
    ->name('usuario.removerAdmin');

// =======================================================
// ✅ ROTAS PARA EDIÇÕES (CORRIGIDAS E UNIFICADAS)
// =======================================================
Route::prefix('edicoes')->group(function () {
    // Listar edições pendentes
    Route::get('/listar', [EditadosController::class, 'listarEditados'])
        ->name('editados.listar');
    
    // Detalhes da edição
    Route::get('/detalhes/{id}', [EditadosController::class, 'detalhesEditado'])
        ->name('editar.detalhes');
});

// =======================================================
// ✅ ROTAS UNIFICADAS PARA AÇÕES DE EDIÇÃO (PUT)
// =======================================================
Route::put('/aceitar-edicao/{id}', [EditadosController::class, 'aprovar'])->name('editar.aprovar');
Route::put('/recusar-edicao/{id}', [EditadosController::class, 'rejeitar'])->name('editar.rejeitar');

// =======================================================
// ROTAS DE REDIRECIONAMENTO
// =======================================================
Route::get('/dn-animais-encontrados', function() {
    return redirect()->route('site.listaNEncontrados');
})->name('site.DNEncontrados.voltar');

Route::get('/dn-animais-perdidos', function() {
    return redirect()->route('site.listaNPerdidos');
})->name('site.DNPerdidos.voltar');

// =======================================================
// ROTAS DE TESTE (WEB)
// =======================================================
Route::get('/ap', function () {
    return view('site.AnimaisPerdidos');
});

Route::get('/ae', function () {
    return view('site.AnimaisEncontrados');
});

// Rota de TESTE para verificar se o Gmail está funcionando
Route::get('/testar-email-simples', function () {
    try {
        Mail::raw('Código de Recuperação: 123456 - ReconectaPet', function($message) {
            $message->to('reconectapet@gmail.com')
                    ->subject('🔐 Código de Recuperação - ReconectaPet');
        });
        
        return "✅ Email SIMPLES enviado! Verifique reconectapet@gmail.com";
    } catch (\Exception $e) {
        return "❌ Erro email simples: " . $e->getMessage();
    }
});