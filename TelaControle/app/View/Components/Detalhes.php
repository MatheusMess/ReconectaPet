<?php

namespace App\View\Components;

use Illuminate\View\Component;
use App\Models\Animal; // 1. Importe a classe Animal

class Detalhes extends Component
{
    /**
     * O modelo do animal.
     *
     * @var \App\Models\Animal
     */
    public $animal;

    public $caso;

    /**
     * Create a new component instance.
     *
     * @param \App\Models\Animal $animal
     * @param int $caso
     * @return void
     */
    public function __construct(Animal $animal, int $caso) // 2. Altere o tipo aqui
    {
        $this->animal = $animal;
        $this->caso = $caso;
    }

    /**
     * Get the view / contents that represent the component.
     *
     * @return \Illuminate\Contracts\View\View|\Closure|string
     */
    public function render()
    {
        return view('components.detalhes');
    }
}