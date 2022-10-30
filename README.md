<h1 align="center">:file_cabinet: Keylogger!</h1>

## :memo: Descrição
Keylogger desenvolvido em Delphi, tem exemplos de como fazer o registro das teclas, pegar a descrição e o print da tela atual do usuário (cada vez que troca). Criado uma API em java utilizando o framework Quarkus, na qual recebe requisições a cada tempo (definido no componente Timer do Delphi) via HTTP dos logs registrados no computador, fazendo a gravação em uma base de dados PostgreSQL, armazenando data e hora, e informações da máquina que enviou a requisição, como o endereço IP.

## :warning: Avisos
Este projeto não foi criado para invadir a privacidade de outros usuários, isso é crime, foi criado com intuito estudantil, para saber como funciona na prática um Keylogger, nesse projeto, a aplicação em Delphi não é escondida no computador, fica uma tela visível para o usuário verificar como está sendo gravados os logs, os prints são armazenados em uma pasta no computador, somente para teste, não é enviado via http, somente o log. Nenhuma ação maliciosa é feita no computador.

## :wrench: Versões utilizadas
* Delphi Sydney 10.4.
* Java: 17.
* Maven: 3.8.5.
* Quarkus: 2.12.3.
* PostgreSQL: 14.1.
