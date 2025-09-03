<?php   

namespace App\View\Components;

use Illuminate\View\Component;

class Detalhes extends Component
{
    /**
     * Dados do animal (array associativo)
     *
     * Ex: ['id'=>1,'tipo'=>'Gato','nome'=>'Mimi','raca'=>'Siamês','cor'=>'Branco','sexo'=>'Fêmea','imagem'=>'...']
     *
     * @var array
     */
    public array $animal;

    /**
     * Mostrar botões "Caso Resolvido" / "Caso Abandonado"
     * @var bool
     */
    public bool $showResolveButtons;

    public function __construct(array $animal = [], bool $showResolveButtons = true)
    {
        $this->animal = $animal;
        $this->showResolveButtons = $showResolveButtons;
    }

    public function render()
    {
        return view('components.detalhes');
    }
}