<?php

namespace App\View\Components;

use Illuminate\View\Component;
use Illuminate\Database\Eloquent\Collection; // 1. Importe a classe Collection

class Lista extends Component
{
    /**
     * A coleção de animais.
     *
     * @var \Illuminate\Database\Eloquent\Collection
     */
    public $informacoes;
    public $usuario;

    public $showActions;

    /**
     * Create a new component instance.
     *
     * @param \Illuminate\Database\Eloquent\Collection $informacoes
     * @param bool $showActions
     * @param bool $usuario
     * @return void
     */
    public function __construct(Collection $informacoes, bool $showActions = false, bool $usuario = false) // 2. Altere o tipo aqui
    {
        $this->informacoes = $informacoes;
        $this->showActions = $showActions;
        $this->usuario = $usuario;
    }

    /**
     * Get the view / contents that represent the component.
     *
     * @return \Illuminate\Contracts\View\View|\Closure|string
     */
    public function render()
    {
        return view('components.lista');
    }
}
