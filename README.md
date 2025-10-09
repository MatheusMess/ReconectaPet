# ReconectaPet
Placeholder

Passos para abrir o banco de dados com o HeidiSQL (programa padrão do Laragon):

Etapa 1: Baixar a Biblioteca do SQLite
1.  Vá para a página oficial de downloads do SQLite: **https://www.sqlite.org/download.html**

2.  Na seção **"Precompiled Binaries for Windows"**, procure pelo arquivo ".zip" que contém as ferramentas de linha de comando. O nome será algo como **"sqlite-tools-win-x64-*.zip"** para sistemas de 64 bits.

3.  Baixe e extraia este arquivo .zip. Dentro dele, você encontrará o arquivo que precisamos: **"sqlite3.dll"**.

4.  Copie o arquivo sqlite3.dll e cole-o na mesma pasta onde o heidisql.exe está instalado. Geralmente, fica em "C:\Program Files\HeidiSQL\".
    -----**No caso do laragon, fica em "C:\laragon\bin\heidisql"**-----
    *Isso permite que o HeidiSQL encontre o "tradutor" automaticamente.*

Etapa 2: Configurar a Conexão no HeidiSQL
1.  Abra o HeidiSQL. A janela do **"Gerenciador de Sessões"** aparecerá.

2.  Clique no botão "Nova" para criar uma nova configuração de conexão.

3.  Na aba **"Configurações"** à direita, faça o seguinte:

       **Tipo de rede**: Selecione na lista a opção "SQLite (libsqlite3.dll)".  *pode estar escrito como **"SQLite (Encrypted)"***
        
       **Biblioteca**: O HeidiSQL deve encontrar o sqlite3.dll automaticamente se você o colocou na pasta certa. Se não, clique no ícone de pasta ao lado e aponte para o local onde você salvou o sqlite3.dll.

       **Arquivo**: Este é o passo mais importante. Clique no ícone de pasta e navegue até o seu arquivo de banco de dados do projeto: **database.sqlite**

4.  Clique em "Abrir".