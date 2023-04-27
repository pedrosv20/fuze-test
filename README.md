# Fuze CSTV App

## App desenvolvido em SwiftUI usando TCA (The Composable Architecture) para construção das views e suas interações

* Para rodar o projeto somente abrir o CSTV.xcworkspace onde terá o CSTV target e o Package Modules com as features modularizadas.

O app possui 4 modulos distintos.
Sendo eles:
* Networking para lidar com as requests e tem os objetos de response decodable.
* CSTVMatchesService, o modulo de interface para as chamadas do networking, contendo a interface e as objetos prontos para serem usados nos modulos
* CSTVMatchesServiceLIve, modulo concreto para a camada de servido onde existe a variavel estatica live para ser usada nas logicas para chamadas de API
* MatchesListFeature, feature que contem duas telas distintas, MatchesList e MatchDetail. 

-----------------
## Ao abrir o app, uma launchscreen com a logo da fuze sera mostrada. Após isso iremos para a MatchesListView que ira bater na api no endpoint "/csgo/matches/running" e trará ordenado por inicio crescente (primeiras antes) todas partidas ocorrendo ao vivo. 

-----------------

## Se selecionar uma partida ira para tela de detalhe onde serão mostrados o nome da liga, a logo dos times e seus nomes e os players (nickname e nome real se existirem).

-----------------
## Nas duas telas, dados que não existirem na API serão omitidos e circulos cinza serão colocados nas imagens que não existirem também.

Na entrega final o app contará com testes unitarios dos controladores lógicos das telas e testes de snapshot.