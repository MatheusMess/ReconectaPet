<style>
    
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
        border-radius: 100px;
    }
    }
    #teste{
        color: black;
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
        color: #fff; /* cor do texto */
        display: inline-block;
        font-weight: 700;
        -webkit-text-stroke: 1px rgba(0,0,0,0.88); /* contorno para WebKit */
        text-shadow:
            1px 1px 0 rgba(0,0,0,0.65),
            -1px -1px 0 rgba(0,0,0,0.65),
            1px -1px 0 rgba(0,0,0,0.65),
            -1px 1px 0 rgba(0,0,0,0.65); /* fallback para navegadores sem text-stroke */
        padding: 2px 6px;
        border-radius: 6px;
        -webkit-font-smoothing: antialiased;
        backface-visibility: hidden;
    }
</style>
