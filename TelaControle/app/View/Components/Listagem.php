<?php

namespace App\View\Components;

use Illuminate\Database\Eloquent\Collection;
use Illuminate\View\Component;

class Listagem extends Component
{
    public $informacoes;
    public $usuario;
    public $showActions;
    
    /**
     * Create a new component instance.
     */
    public function __construct(Collection $informacoes, bool $usuario = false, bool $showActions = false)
    {
        $this->informacoes = $informacoes;
        $this->usuario = $usuario;
        $this->showActions = $showActions;
    }

    /**
     * Get the view / contents that represent the component.
     */
    public function render()
    {
        return view('components.listagem');
    }
}