<?php

namespace App\View\Components;

use Illuminate\Database\Eloquent\Collection;
use Illuminate\View\Component;

class Listagem extends Component
{
    public $animais;
    public $info;
    
    /**
     * Create a new component instance.
     *
     * @return void
     */
    public function __construct(Collection $animais, int $info)
    {
        $this->animais = $animais;
        $this->info = $info;
    }

    /**
     * Get the view / contents that represent the component.
     *
     * @return \Illuminate\Contracts\View\View|\Closure|string
     */
    public function render()
    {
        return view('components.listagem');
    }
}
