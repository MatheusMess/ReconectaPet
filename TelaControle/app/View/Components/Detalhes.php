<?php

namespace App\View\Components;

use Illuminate\View\Component;
use App\Models\Animal;
use App\Models\Editados;

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
     * @param int $caso
     * @param \App\Models\Editados|null $editado
     * @return void
     */
    public function __construct(Animal $animal, int $caso, ?Editados $editado = null)
    {
        $this->animal = $animal;
        $this->caso = $caso;
        $this->editado = $editado;
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