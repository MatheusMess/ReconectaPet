<?php   

namespace App\View\Components;

use Illuminate\View\Component;

use function PHPUnit\Framework\isNull;

class Detalhes extends Component
{
    /**
     * @var array
     */
    public array $animal;

    /**
     * @var bool
     */
    
    public bool $aceitar;
    public bool $recusar;
    public bool $abandonar;
    public bool $resolvido;
    public bool $rcr;
    public bool $rca;

    /**
     * @var int
     */
    public int $caso;

    /*
    caso [dap] = 1
    caso [dae] = 2
    caso [dcr] = 3
    caso [dca] = 4
    caso [dce]  = 5ad
    caso [dnae] = 6
    caso [dnap] = 7
    */

    public function __construct(
        array $animal = [],
        ?int $caso = null,
        ?bool $aceitar = null,
        ?bool $recusar = null,
        ?bool $abandonar = null,
        ?bool $resolvido = null,
        ?bool $rcr = null,
        ?bool $rca = null,
    ) {
        $this->animal = $animal;
        $this->caso = !is_null($caso) ? (int) $caso : 1;

        // atribuições explícitas (quando passadas)
        $this->aceitar   = !is_null($aceitar)   ? (bool) $aceitar   : false;
        $this->recusar   = !is_null($recusar)   ? (bool) $recusar   : false;
        $this->abandonar = !is_null($abandonar) ? (bool) $abandonar : false;
        $this->resolvido = !is_null($resolvido) ? (bool) $resolvido : false;
        $this->rcr       = !is_null($rcr)       ? (bool) $rcr       : false;
        $this->rca       = !is_null($rca)       ? (bool) $rca       : false;

        // lógica baseada no caso (sobrepõe defaults quando aplicável)
        switch ($this->caso) {
            case 1: // dap
                $this->resolvido = true;
                $this->abandonar = true;
                break;
            case 2: // dae
                $this->resolvido = true;
                $this->abandonar = true;
                break;
            case 3: // dcr
                $this->rcr = true;
                break;
            case 4: // dca
                $this->rca = true;
                break;
            case 5: // dce
                $this->rcr = true;
                $this->rca = true;
                break;
            case 6: // dnae
                $this->aceitar = true;
                $this->recusar = true;
                break;
            case 7: // dnap
                $this->aceitar = true;
                $this->recusar = true;
                break;
            default:
                // sem alterações
                break;
        }
    }

    public function render()
    {
        return view('components.detalhes');
    }
}