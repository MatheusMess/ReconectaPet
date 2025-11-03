<style>
    .filtro-wrapper {
        margin: 4%;
        margin-bottom: 0%;
        display: flex;
        justify-content: flex-end;
        max-width: 1280px;
        background-color: rgb(16, 196, 228);
        width: 100%;
        height: 70px;
        align-self: center;
        justify-self: center;
        border-radius: 50px 50px 0 0;
        padding: 50px;
        padding-top: 60px;
        align-items: center;

    }
    .pai{
        border-radius: 0 0 50px 50px;
    }

    #filtro {
        display: flex;
        gap: 12px;
        align-items: center;
        flex-wrap: wrap;
        .btn{
            background-color: rgb(75, 225, 255);
            color: black;
            border-radius: 50px;
        }
        .btn:hover{
            background-color: gold;
            
        }
    }

    .itens_filtro {
        width: 100%;
        max-width: 200px;
        justify-self: end;
        background-color: white;
        border-radius: 50px;
        padding-left: 5%;
        color: black;
        label {
            color: black;
            padding-left: 5%;
            font-size: 17px;
            background-color: cyan;
            border-radius: 50px;
            width: 85px;
            height: 25px;
        }
    }
    .itens_filtro .select-wrapper{
        padding-left: 10%;
        padding-right: 10%;
    }

    @media (max-width: 960px) {
        .filtro-wrapper {
            justify-content: center;
            margin-right: 0;
            margin-left: 0;
        }
        #filtro {
            justify-content: center;
        }
        .itens_filtro {
            max-width: 320px;
        }
    }
</style>