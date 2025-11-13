<style>
    .pai{
        margin: 4%;
        background-color: rgb(16, 196, 228);
        width: 100%;
        height: 100%;
        align-self: center;
        justify-self: center;
        border-radius: 50px;
        padding: 50px;
        padding-top: 60px;
        align-items: center;
        margin-top: 20px;
    }
    .img{
        object-fit: cover;
        object-position: center;
        height: 150px;
        width: 150px;

    }
    #item{
        display: flex;
        padding: 2%;
        border-radius: 100px;
        align-items: center;
        justify-items: center;
        ul{
            width: 100%;
            display: flex;
            justify-content: space-between;
        }
        li{
            width: 175px;
            font-size: 19px;
            margin-left: 20px;
            margin-bottom: 20px;
        }
    }
    .card{
        height: 440px;
        margin-top: 100px;
        margin: 10px;
        border-radius: 30px;
        li{
            margin-top: 10px;
            dysplay: flex;
            align-items: center;
            width: 100%;
            justify-content: space-between;
        }
        img{
        width: 150px;
        height: 250px;
        object-fit: cover;
        object-position: center;
        border-radius: 30px 30px 0 0;
    }
    #img{
        border-radius: 30px 30px 0 0;
    }
    }
    #cardAnimal{
        margin-bottom: 200px;
    }
    #ic:hover{
        background-color: gold;
        transition: 0.2s;
    }
    #ic:not(:hover){
        transition: 0.2s;
    }

    /* Contorno escuro nas letras do nome (card-title) */
    .card-title {
        color: white; /* cor do texto */
        b{
            font-size: 35px;
            font-style: bold;
        }

        display: inline-block;
        font-weight: 700;
        -webkit-text-stroke: 1.5px rgb(0,0,0); /* contorno para WebKit */
        padding: 2px 6px;
        border-radius: 30px;
        -webkit-font-smoothing: antialiased;
        backface-visibility: hidden;
    }
</style>
