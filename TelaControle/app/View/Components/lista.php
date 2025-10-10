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
    public $animais;

    public $showActions;

    /**
     * Create a new component instance.
     *
     * @param \Illuminate\Database\Eloquent\Collection $animais
     * @param bool $showActions
     * @return void
     */
    public function __construct(Collection $animais, bool $showActions = false) // 2. Altere o tipo aqui
    {
        $this->animais = $animais;
        $this->showActions = $showActions;
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