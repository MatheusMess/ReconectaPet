<style>
    #pai{
        display: grid;
        grid-template-columns: 1fr 1fr 1fr 1fr;
        grid-template-rows: 1fr 1fr;
        gap: 40px;
        height: 50%;
        margin: 5%;
        border-radius: 50px;
        padding: 20px;
        justify-items: center;
        align-items: center;
    }
    .opcao{
        position: relative;
        background-color: rgb(16, 196, 228);
        width: 220px;
        height: 220px;
        border-radius: 30px;
        display: flex;
        justify-content: center;
        align-items: center;
        box-shadow: 0 4px 16px rgba(0,0,0,0.08);
        overflow: hidden;
        transition: transform 0.3s, box-shadow 0.3s;
    }
    .opcao:hover{
        transform: scale(1.08);
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.18);
        cursor: pointer;
        background-color: gold;
        border-radius: 50px;
        transition: 200ms;
    }
    .opcao:not(:hover){
        border-radius: 30px;
        transition: 200ms;
    }
    .icone-fundo{
        position: absolute;
        left: 50%;
        top: 50%;
        transform: translate(-50%, -50%);
        font-size: 125px;
        color: #757575;
        opacity: 0.18;
        z-index: 1;
        pointer-events: none;
        align-items: center;
        
        #estrela{
            padding-top: 40px;
            font-size: 150px;
        }
    }
    h1{
        position: relative;
        z-index: 2;
        text-align: center;
        font-size: 22px;
        color: #00363a;
        font-weight: bold;
    }

    /* RESPONSIVIDADE: quando a largura for menor (metade/colapsado),
       passar para 2 colunas e 4 fileiras com a ordem solicitada:
       coluna 1 = itens da fileira 2 (5,6,7,8) e coluna 2 = itens da fileira 1 (1,2,3,4) */
    @media (max-width: 960px) {
        #pai{
            grid-template-columns: 1fr 1fr;
            grid-template-rows: repeat(4, auto);
            gap: 20px;
            height: auto;
            margin: 3%;
        }

        /* força posicionamento por item para obter a ordem desejada */
        .opcao {
            width: 100%;
            max-width: 220px;
            max-height: 220px;
        }

        /* coluna 1 recebe os itens da antiga fileira 2 (5..8) */
        .opcao:nth-child(5) { grid-column: 1; grid-row: 1; }
        .opcao:nth-child(6) { grid-column: 1; grid-row: 2; }
        .opcao:nth-child(7) { grid-column: 1; grid-row: 3; }
        .opcao:nth-child(8) { grid-column: 1; grid-row: 4; }

        /* coluna 2 recebe os itens da antiga fileira 1 (1..4) */
        .opcao:nth-child(1) { grid-column: 2; grid-row: 1; }
        .opcao:nth-child(2) { grid-column: 2; grid-row: 2; }
        .opcao:nth-child(3) { grid-column: 2; grid-row: 3; }
        .opcao:nth-child(4) { grid-column: 2; grid-row: 4; }
    }
</style>
