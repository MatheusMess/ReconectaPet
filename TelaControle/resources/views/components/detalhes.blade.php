@if($caso >=10)


@php
    // Determina se este componente está mostrando "antes" ou "depois"
    /*
    $isBefore = in_array($caso, [10, 12], true);
    $isAfter  = in_array($caso, [11, 13], true);


    $campos = $animal;
    $imagens = ['imagem1','imagem2','imagem3','imagem4'];

    $nValue = function($key) use ($editado) {
        $v = $editado['n_'.$key] ?? null;
        if (is_null($v) || trim((string)$v) === '') {
            return ' ';
        }
        return $v;
    };

    $origValue = function($key) use ($animal) {
        $v = $animal[$key] ?? null;
        return is_null($v) ? ' ' : $v;
    };

    $display = function($key) use ($isBefore, $origValue, $nValue) {
        if ($isBefore) {
            return $origValue($key);
        }
        $nv = $nValue($key) ?? $origValue($key);
        return trim((string)$nv) === ' ' ? $origValue($key) : $nv;
    };

    $isChanged = function($key) use ($origValue, $nValue) {
        $orig = (string)$origValue($key);
        $nv   = (string)$nValue($key) ?? (string)$origValue($key);
        return trim($nv) !== '' && trim($nv) !== ' ' && $nv !== $orig;
    };

    $imageSrc = function($imgKey) use ($isBefore, $origValue, $nValue, $animal) {
        $orig = $origValue($imgKey);
        if ($isBefore) {
            return trim((string)$orig) === '' ? (file_exists(public_path('images/animais/'.$animal['id'].'/'.$animal[$imgKey])) ? asset('images/animais/'.$animal['id'].'/'.$imgKey) : asset('images/animais/noimg.jpg')) : $orig;
        }
        $nv = $nValue($imgKey);
        if (trim((string)$nv) === ' ') {
            return trim((string)$orig) === '' ? (file_exists(public_path('images/animais/'.$animal['id'].'/'.'new/'.$animal[$imgKey])) ? asset('images/animais/'.$animal['id'].'/new/'.$imgKey) : asset('images/animais/noimg.jpg')) : $orig;
        }
        return $nv;
    };*/

@endphp

<div class="pai">
    {{--<div id="img" class="card">
        @if($caso == 10 || $caso == 11)
            <h2 class="titulo">Perdido</h2>
        @elseif($caso == 12 || $caso == 13)
            <h2 class="titulo">Encontrado</h2>
        @endif

        <div id="imgs">
            <div class="img-wrap alterado2">
                <img src={{"images/animais/".$editado['animal_id']."/imagem1.png" }}alt="{{ $animal['nome'] ?: 'Animal' }}">
            </div>
        </div>
        {{--
        @php
            $nameChanged = $isChanged('nome');
            $nameClass = $nameChanged ? ($isBefore ? 'changed-before' : 'changed-after') : '';
        @endphp
        -}}
        @if(trim((string)($animal['nome'])) === '')
            <span id="snome" class="center">(Sem coleira)</span>
        @else
            <span id="nome" class="center ">{{ $animal['nome'] }}</span>
        @endif
    </div> --}}
     <div id="img" class="white" style="border-radius: 50px">
        <div id="imgs">
            @php
            $noimg = asset('images/animais/noimg.jpg');
            $Cimg = 'images/animais/'.$animal['id'].'/';

                $IMG1_antes = '';
                $IMG2_antes = '';
                $IMG3_antes = '';
                $IMG4_antes = '';

                $IMG1_depois = '';
                $IMG2_depois = '';
                $IMG3_depois = '';
                $IMG4_depois = '';
            if ($caso == 10 || $caso == 12) {
                $img1 = $Cimg.'imagem1.png';
                $img2 = $Cimg.'imagem2.png';
                $img3 = $Cimg.'imagem3.png';
                $img4 = $Cimg.'imagem4.png';

                $IMG1 = file_exists(public_path($img1)) ? asset($img1) : $noimg;
                $IMG2 = file_exists(public_path($img2)) ? asset($img2) : $noimg;
                $IMG3 = file_exists(public_path($img3)) ? asset($img3) : $noimg;
                $IMG4 = file_exists(public_path($img4)) ? asset($img4) : $noimg;

                $IMG1_antes = $IMG1;
                $IMG2_antes = $IMG2;
                $IMG3_antes = $IMG3;
                $IMG4_antes = $IMG4;

                $IMG1_depois = file_exists(public_path($Cimg.'new/imagem1.png')) ? asset($Cimg.'new/imagem1.png') : $IMG1;
                $IMG2_depois = file_exists(public_path($Cimg.'new/imagem2.png')) ? asset($Cimg.'new/imagem2.png') : $IMG2;
                $IMG3_depois = file_exists(public_path($Cimg.'new/imagem3.png')) ? asset($Cimg.'new/imagem3.png') : $IMG3;
                $IMG4_depois = file_exists(public_path($Cimg.'new/imagem4.png')) ? asset($Cimg.'new/imagem4.png') : $IMG4;

            } else {
                $img1 = $Cimg.'new/imagem1.png';
                $img2 = $Cimg.'new/imagem2.png';
                $img3 = $Cimg.'new/imagem3.png';
                $img4 = $Cimg.'new/imagem4.png';

                $IMG1 = file_exists(public_path($img1)) ? asset($img1) : (file_exists(public_path($Cimg.'imagem1.png')) ? asset($Cimg.'imagem1.png') : $noimg );
                $IMG2 = file_exists(public_path($img2)) ? asset($img2) : (file_exists(public_path($Cimg.'imagem2.png')) ? asset($Cimg.'imagem2.png') : $noimg );
                $IMG3 = file_exists(public_path($img3)) ? asset($img3) : (file_exists(public_path($Cimg.'imagem3.png')) ? asset($Cimg.'imagem3.png') : $noimg );
                $IMG4 = file_exists(public_path($img4)) ? asset($img4) : (file_exists(public_path($Cimg.'imagem4.png')) ? asset($Cimg.'imagem4.png') : $noimg );

                $IMG1_depois = $IMG1;
                $IMG2_depois = $IMG2;
                $IMG3_depois = $IMG3;
                $IMG4_depois = $IMG4;

                $IMG1_antes = file_exists(public_path($Cimg.'imagem1.png')) ? asset($Cimg.'imagem1.png') : $noimg;
                $IMG2_antes = file_exists(public_path($Cimg.'imagem2.png')) ? asset($Cimg.'imagem2.png') : $noimg;
                $IMG3_antes = file_exists(public_path($Cimg.'imagem3.png')) ? asset($Cimg.'imagem3.png') : $noimg;
                $IMG4_antes = file_exists(public_path($Cimg.'imagem4.png')) ? asset($Cimg.'imagem4.png') : $noimg;
            }
            @endphp
            @if ($caso == 10 || $caso == 12)
                <img class="{{ ($IMG1_depois == $IMG1_antes) ? '' : 'alterado1'}}" src="{{ $IMG1 }}" alt="{{ $animal['tipo'].' '.$animal['nome'] ?? $animal['tipo'] }}">
                <img class="{{ ($IMG2_depois == $IMG2_antes) ? '' : 'alterado1'}}" src="{{ $IMG2 }}" alt="{{ $animal['tipo'].' '.$animal['nome'] ?? $animal['tipo'] }}">
                <img class="{{ ($IMG3_depois == $IMG3_antes) ? '' : 'alterado1'}}" src="{{ $IMG3 }}" alt="{{ $animal['tipo'].' '.$animal['nome'] ?? $animal['tipo'] }}">
                <img class="{{ ($IMG4_depois == $IMG4_antes) ? '' : 'alterado1'}}" src="{{ $IMG4 }}" alt="{{ $animal['tipo'].' '.$animal['nome'] ?? $animal['tipo'] }}">
            @else
                <img class="{{ ($IMG1_depois == $IMG1_antes) ? '' : 'alterado2'}}" src="{{ $IMG1 }}" alt="{{ $animal['tipo'].' '.$animal['nome'] ?? $animal['tipo'] }}">
                <img class="{{ ($IMG2_depois == $IMG2_antes) ? '' : 'alterado2'}}" src="{{ $IMG2 }}" alt="{{ $animal['tipo'].' '.$animal['nome'] ?? $animal['tipo'] }}">
                <img class="{{ ($IMG3_depois == $IMG3_antes) ? '' : 'alterado2'}}" src="{{ $IMG3 }}" alt="{{ $animal['tipo'].' '.$animal['nome'] ?? $animal['tipo'] }}">
                <img class="{{ ($IMG4_depois == $IMG4_antes) ? '' : 'alterado2'}}" src="{{ $IMG4 }}" alt="{{ $animal['tipo'].' '.$animal['nome'] ?? $animal['tipo'] }}">
            @endif
        </div>
        @php
            $nome_antes  = $animal ['nome'];
            $nome_depois = $editado['n_nome']? $editado['n_nome']: $animal['nome'];

            $situ_antes  = $animal ['situacao'];
            $situ_depois = $editado['n_situacao'] ? $editado['n_situacao']: $animal['situacao'];
        @endphp
        @if($caso == 10 || $caso == 12)
            @if(trim((string)($nome_antes)) === '')
                <span id="snome">(Sem coleira)</span>
            @else
                <span id="nome" class="{{ ($nome_depois == $nome_antes) ? '' : 'alterado1' }}"><b>{{ $animal['nome'] }}</b></span>
            @endif

        @else
            @if(trim((string)($nome_depois)) === '')
                <span id="snome">(Sem coleira)</span>
            @else
                <span id="nome" class="{{ ($nome_depois == $nome_antes) ? '' : 'alterado2' }}"><b>{{ $nome_depois }}</b></span>
            @endif
        @endif
        <ul class="caso">
            @if ($caso == 10 || $caso == 12)
                <li class="{{ ($situ_depois == $situ_antes) ? '' : 'alterado1' }}">
                    <b>Situação: </b>{{ $animal['situacao'] }}
                </li>
            @else
                <li class="{{ ($situ_depois == $situ_antes) ? '' : 'alterado2' }}">
                    <b>Situação: </b>{{ $situ_depois }}
                </li>
            @endif
            <li id="caso"><b>Caso {{ $animal['status'] }}</b></li>
        </ul>
    </div>

    <div class="div2">
        <div id="detalhes" class="card">
            {{--<ul>
                @foreach(['tipo' => 'Animal', 'raca' => 'Raça', 'tam' => 'Tamanho', 'sexo' => 'Sexo', 'cor' => 'Cor'] as $campo => $label)
                    {{--@php
                        $changed = $isChanged($campo);
                        $cls = $changed ? ($isBefore ? 'alterado1' : 'alterado2') : '';
                    @endphp -}}
                    <li class="alterado2"><b>{{ $label }}: </b>{{ $animal[$campo]}}</li>
                @endforeach

                <li><b>Detalhes da aparência:</b></li>
                {{--@php
                    $changedA = $isChanged('aparencia');
                    $clsA = $changedA ? ($isBefore ? 'alterado1' : 'alterado2') : '';
                @endphp
                <p class="alterado2">{{ $animal['aparencia') }}</p> -}}

                @switch($caso)
                    {{-- Perdido: antes = 10, depois = 11 -}}
                    @case(10)
                    @case(11)
                        {{--@php
                            $changedLV = $isChanged('lugar_visto');
                            $clsLV = $changedLV ? ($isBefore ? 'alterado1' : 'alterado2') : '';
                        @endphp  -}}
                        <li><b>Último lugar visto:</b></li>
                        <p class="alterado2">{{ $animal['lugar_visto'] }}</p>
                        @break

                    {{-- Encontrado: antes = 12, depois = 13  -}}
                    @case(12)
                    @case(13)
                        {{--@php
                            $changedLE = $isChanged('lugar_encontrado');
                            $clsLE = $changedLE ? ($isBefore ? 'alterado1' : 'alterado2') : '';
                        @endphp -}}
                        <li><b>Lugar encontrado:</b></li>
                        <p class="alterado2">{{ $animal['lugar_encontrado'] }}</p>
                        @break

                    @default
                @endswitch
            </ul>--}}
            <ul>
                @php
                    $tipo_antes = $animal['tipo'];
                    $tipo_depois = $editado['n_tipo'] ?: $animal['tipo'];

                    $raca_antes = $animal['raca'];
                    $raca_depois = $editado['n_raca'] ?: $animal['raca'];

                    $tam_antes = $animal['tam'];
                    $tam_depois = $editado['n_tam'] ?: $animal['tam'];

                    $sexo_antes = $animal['sexo'];
                    $sexo_depois = $editado['n_sexo'] ?: $animal['sexo'];

                    $cor_antes = $animal['cor'];
                    $cor_depois = $editado['n_cor'] ?: $animal['cor'];

                    $apar_antes = $animal['aparencia'];
                    $apar_depois = $editado['n_aparencia'] ?: $animal['aparencia'];

                    $lugarV_antes = $animal['lugar_visto'] ?? '';
                    $lugarV_depois = $editado['n_lugar_visto'] ?: ($animal['lugar_visto'] ?? '');

                    $lugarE_antes = $animal['lugar_encontrado'] ?? '';
                    $lugarE_depois = $editado['n_lugar_encontrado'] ?: ($animal['lugar_encontrado'] ?? '');
                @endphp
                @if ($caso == 10 || $caso == 12)
                    <li class="{{ ($tipo_antes == $tipo_depois) ? '' : 'alterado1' }}"><b>Animal: </b>{{$animal['tipo']}}</li>
                    <li class="{{ ($raca_antes == $raca_depois) ? '' : 'alterado1' }}"><b>Raça:   </b>{{$animal['raca']}}</li>
                    <li class="{{ ($tam_antes  == $tam_depois ) ? '' : 'alterado1' }}"><b>Tamanho:</b>{{$animal['tam' ]}}</li>
                    <li class="{{ ($sexo_antes == $sexo_depois) ? '' : 'alterado1' }}"><b>Sexo:   </b>{{$animal['sexo']}}</li>
                    <li class="{{ ($cor_antes  == $cor_depois ) ? '' : 'alterado1' }}"><b>Cor:    </b>{{$animal['cor' ]}}</li>
                    <li><b>Detalhes da aparência:</b></li>
                    <p class="{{ ($apar_antes == $apar_depois) ? '' : 'alterado1' }}">{{$animal['aparencia']}}</p>
                    @if($caso == 10)
                        <li><b>Ultimo lugar visto:</b></li>
                        <p class="{{ ($lugarV_antes == $lugarV_depois) ? '' : 'alterado1' }}">{{$animal['lugar_visto']}}</p>
                    @else
                        <li><b>Lugar encontrado:</b></li>
                        <p class="{{ ($lugarE_antes == $lugarE_depois) ? '' : 'alterado1' }}">{{$animal['lugar_encontrado']}}</p>
                    @endif
                @else
                    <li class="{{ ($tipo_antes == $tipo_depois) ? '' : 'alterado2' }}"><b>Animal: </b>{{$editado['n_tipo']? $editado['n_tipo'] : $animal['tipo']}}</li>
                    <li class="{{ ($raca_antes == $raca_depois) ? '' : 'alterado2' }}"><b>Raça:   </b>{{$editado['n_raca']? $editado['n_raca'] : $animal['raca']}}</li>
                    <li class="{{ ($tam_antes  == $tam_depois ) ? '' : 'alterado2' }}"><b>Tamanho:</b>{{$editado['n_tam' ]? $editado['n_tam' ] : $animal['tam' ]}}</li>
                    <li class="{{ ($sexo_antes == $sexo_depois) ? '' : 'alterado2' }}"><b>Sexo:   </b>{{$editado['n_sexo']? $editado['n_sexo'] : $animal['sexo']}}</li>
                    <li class="{{ ($cor_antes  == $cor_depois ) ? '' : 'alterado2' }}"><b>Cor:    </b>{{$editado['n_cor' ]? $editado['n_cor' ] : $animal['cor' ]}}</li>
                    <li><b>Detalhes da aparência:</b></li>
                    <p class="{{ ($apar_antes == $apar_depois) ? '' : 'alterado2' }}">{{$editado['n_aparencia']? $editado['n_aparencia'] : $animal['aparencia']}}</p>
                    @if($caso == 11)
                        <li><b>Ultimo lugar visto:</b></li>
                        <p class="{{ ($lugarV_antes == $lugarV_depois) ? '' : 'alterado2' }}">{{$editado['n_lugar_visto']? $editado['n_lugar_visto'] : $animal['lugar_visto']}}</p>
                    @else
                        <li><b>Lugar encontrado:</b></li>
                        <p class="{{ ($lugarE_antes == $lugarE_depois) ? '' : 'alterado2' }}">{{$editado['n_lugar_encontrado']? $editado['n_lugar_encontrado'] : $animal['lugar_encontrado']}}</p>
                    @endif
                @endif

            </ul>

        </div>

        <div class="botao">
            @if($caso == 11 || $caso == 13)
                <form action="{{ route('animal.aceitar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="reso" class="btn-caso">Aceitar</button>
                </form>

                <form action="{{ route('animal.recusar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="aban" class="btn-caso">Recusar</button>
                </form>
            @endif
        </div>
    </div>
</div>

@else
<div class="pai">
    <div id="img" class="white" style="border-radius: 50px">
        <div id="imgs">
            <img src="{{ file_exists(public_path('images/animais/'.$animal['id'].'/imagem1.png')) ? asset('images/animais/'.$animal['id'].'/imagem1.png') : asset('images/animais/noimg.jpg') }}" alt="{{ $animal['tipo'].' '.$animal['nome'] ?? $animal['tipo'] }}">
            <img src="{{ file_exists(public_path('images/animais/'.$animal['id'].'/imagem2.png')) ? asset('images/animais/'.$animal['id'].'/imagem2.png') : asset('images/animais/noimg.jpg') }}" alt="{{ $animal['tipo'].' '.$animal['nome'] ?? $animal['tipo'] }}">
            <img src="{{ file_exists(public_path('images/animais/'.$animal['id'].'/imagem3.png')) ? asset('images/animais/'.$animal['id'].'/imagem3.png') : asset('images/animais/noimg.jpg') }}" alt="{{ $animal['tipo'].' '.$animal['nome'] ?? $animal['tipo'] }}">
            <img src="{{ file_exists(public_path('images/animais/'.$animal['id'].'/imagem4.png')) ? asset('images/animais/'.$animal['id'].'/imagem4.png') : asset('images/animais/noimg.jpg') }}" alt="{{ $animal['tipo'].' '.$animal['nome'] ?? $animal['tipo'] }}">
        </div>
        @if(!$animal['nome'])
            <span id="snome" >(Sem coleira)</span>
        @endif
        @if($animal['nome'])
            <span id="nome" ><b>{{ $animal['nome']}}</b></span>
        @endif
        <ul class="caso">
            <li>
                <b>Situação: </b>{{ $animal['situacao'] }}
            </li>
            <li id="caso"><b>Caso {{ $animal['status'] }}</b></li>
        </ul>
    </div>
    <!--
    caso [dap] = 1
    caso [dae] = 2
    caso [dcr] = 3
    caso [dca] = 4
    caso [dnae] = 6
    caso [dnap] = 7
    caso [dce.p] = 10
    caso [dce.p] = 11
    caso [dce.e] = 12
    caso [dce.e] = 13
    -->
    <div class="div2" >
        <div id="detalhes" class="white card-content" style="width: 100%;">
            <ul>
                <li><b>Animal: </b>{{$animal['tipo']}}</li>
                <li><b>Raça:   </b>{{$animal['raca']}}</li>
                <li><b>Tamanho:</b>{{$animal['tam']}}</li>
                <li><b>Sexo:   </b>{{$animal['sexo']}}</li>
                <li><b>Cor:    </b>{{$animal['cor']}}</li>
                <li><b>Detalhes da aparência:</b></li>
                <p>{{$animal['aparencia']}}</p>

                @if($caso == 3 || $caso == 4 || $caso == 5)
                    <li><b>Ultimo lugar visto:</b></li>
                    <p>{{$animal['lugar_visto']}}</p>
                    <li><b>Lugar encontrado:</b></li>
                    <p>{{$animal['lugar_encontrado']}}</p>
                @endif

                @if($caso == 1 || $caso == 2)
                    <li><b>Ultimo lugar visto:</b></li>
                    <p>{{$animal['lugar_visto']}}</p>
                @endif

                @if($caso == 2 || $caso == 6)
                    <li><b>Lugar encontrado:</b></li>
                    <p>{{$animal['lugar_encontrado']}}</p>
                @endif
            </ul>
        </div>
        <div class="botao" >
            @if($caso == 5 || $caso == 6 || $caso == 7)
                <form action="{{ route('animal.aceitar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="reso" class="btn-caso">Aceitar</button>
                </form>

                <form action="{{ route('animal.recusar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="aban" class="btn-caso">Recusar</button>
                </form>
            @endif

            @if($caso == 1 || $caso == 2)
                <form action="{{ route('animal.resolver') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="reso" class="btn-caso">Resolvido</button>
                </form>

                <form action="{{ route('animal.inativar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="aban" class="btn-caso">Inativar</button>
                </form>
            @endif

            @if($caso == 3)
                <form action="{{ route('animal.reativar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="aban" class="btn-caso">Reativar Caso</button>
                </form>
            @endif

            @if($caso == 4)
                <form action="{{ route('animal.reativar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="reso" class="btn-caso">Reativar Caso</button>
                </form>
            @endif
            {{--
            @if($caso == 5 || $caso == 6 || $caso == 7)
                <form action="{{ route('animal.aceitar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="reso" class="btn-caso">Aceitar</button>
                </form>

                <form action="{{ route('animal.recusar') }}" method="POST" style="display:inline">
                    @csrf
                    <input type="hidden" name="id" value="{{ $animal['id'] }}">
                    <button type="submit" id="aban" class="btn-caso">Recusar</button>
                </form>
            @endif

            @if($caso == 1 || $caso == 7)
                <button id="reso" class="btn-caso" >Resolvido</button>
                <button id="aban" class="btn-caso" >Inativar</button>
            @endif

            @if($caso == 3)
                <button id="aban" class="btn-caso" >Reativar Caso</button>
            @endif

            @if($caso == 4)
                <button id="reso" class="btn-caso" >Reativar Caso</button>
            @endif
            --}}
        </div>
    </div>
</div>
@endif

@include('components.css.CSSdetalhes')
