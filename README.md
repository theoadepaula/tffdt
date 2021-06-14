# tffdt

<!-- badges: start -->

[![R-CMD-check](https://github.com/theoadepaula/tffdt/workflows/R-CMD-check/badge.svg)](https://github.com/theoadepaula/tffdt/actions)

<!-- badges: end -->

O propósito da criação do pacote é para a entrega final do curso Faxina de Dados.

Será trabalhado os dados telemétricos de uma máquina que está instalada no Rio Negro, perto de Manaus. Pelas reportagens vistas na TV, podemos observar que foi ultrapassado o recorde histórico do nível de água na região.

## Limpeza de dados

### Série Histórica

Para poder utilizar o nível de água, que é a medição de cota, é preciso primeiramente retirar as variáveis que não tem interesse, já que a tabela bruta possui 78 variáveis.

Como os dados dos dias estão dispostos em colunas, foi preciso colocar em formato longer para se adequar aos princípios tidy.Depois foram feitas as transformações como colocar em formato datetime e númerico.

Depois foi preciso ordenar o banco de dados pelas colunas data_hora e nivel_consistencia para retirar as informações duplicadas, dando preferëncia aos dados de nível consistidos do que os brutos.

### Dados telemétricos

Para arrumar os dados, foi preciso transformar todos os dados em branco em NA, transformar as variáveis Nivel,Vazao e Chuva em númericos e DataHora em datetime.
