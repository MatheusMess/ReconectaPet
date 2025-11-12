<?php

namespace App\View\Components;

use Illuminate\View\Component;
use App\Models\Animal; // 1. Importe a classe Animal
use App\Models\Editados;
use PhpParser\Node\Expr\Cast\Void_;

class Detalhes extends Component
{
    /**
     * O modelo do animal.
     *
     * @var \App\Models\Animal
     */
    public $animal;
    public $editado;

    public $caso;

    /**
     * Create a new component instance.
     *
     * @param \App\Models\Animal $animal
     * @param \App\Models\Editados $editado
     * @param int $caso
     * @return void
     */
    public function __construct(?Animal $animal = null, int $caso, ?Editados $editado = null) // 2. Altere o tipo aqui
    {
        $this->editado = $editado;
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
