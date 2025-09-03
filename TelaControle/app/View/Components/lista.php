<?php
namespace App\View\Components;

use Illuminate\View\Component;

class Lista extends Component
{
    /**
     * @var array
     */
    public array $animais;

    /**
     * Mostrar botões Aceitar/Recusar
     * @var bool
     */
    public bool $showActions;

    public function __construct(array $animais = [], bool $showActions = true)
    {
        $this->animais = $animais;
        $this->showActions = $showActions;
    }

    public function render()
    {
        return view('components.lista');
    }
}