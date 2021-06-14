
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tffdt

<!-- badges: start -->

[![R-CMD-check](https://github.com/theoadepaula/tffdt/workflows/R-CMD-check/badge.svg)](https://github.com/theoadepaula/tffdt/actions)

<!-- badges: end -->

O propósito da criação do pacote é para a entrega final do curso Faxina
de Dados. O trabalho foi feito em cima de pedido feito por um colega de
trabalho para acompanhar o nível de água do município de Manaus.

Para a cumprir o objetivo desse trabalho ,foram trabalhados os dados
telemétricos de uma estação que está instalada no Rio Negro, com o
código 14990000, que se encontra perto de Manaus. Pelas reportagens
noticiadas na TV e na internet, podemos observar a preocupação da
população local com o nível da água, pois não só atrapalha a rotina da
cidade como existem pessoas perdem roupas, móveis, automóveis e até
casas.

## Análise dos dados

Os dados foram baixados de dois lugares no site de [dados de telemetria
da ANA (Agência Nacional de Águas e Saneamento
Básico)](http://telemetriaws1.ana.gov.br/EstacoesTelemetricas.aspx),
sendo uma parte dos dados vindos da Série Histórica da Região e outra
dos dados vindos do ano de 2021.

## Limpeza de dados

Para fazer uma análise adequada, é preciso primeiro fazer uma limpeza
nos dados baixados/recebidos. As variáveis a serem analisadas é data da
medição e o nível de água/cota. Abaixo está como foi feito a limpeza das
duas partes.

### Série Histórica

Dentro da Série Histórica, será necessário verificar a medição de cota.
A tabela bruta possui 78 colunas e é preciso primeiramente retirar as
variáveis que não tem interesse, já que a tabela bruta possui 78
variáveis e 2.854 observações. Algumas dessas colunas, como o status da
estação por dia, a máxima, mínima e média do mês observado, não serão
interessantes para o que foi proposto, podem portanto, serem retirados
da tabela final, após a limpeza.

Como os dados dos dias dos meses estão dispostos em colunas, é preciso
então colocar em formato longer para se adequar aos princípios
tidy.Depois foram feitas as transformações como colocar a variável
dataHora em formato datetime e Cota em formato númerico. As variáveis
citadas foram renomeadas para data\_hora e cota, respectivamente.

Depois foi preciso ordenar o banco de dados pelas colunas data\_hora e
nivel\_consistencia para retirar as informações duplicadas, dando
preferëncia aos dados de nível consistidos do que os dados brutos.

### Dados telemétricos

Para arrumar os dados, foi preciso transformar todos os dados em branco
em NA, transformar as variáveis Nivel,Vazao e Chuva em númericos e
DataHora em datetime.

``` r
install.packages("tffdt")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("theoadepaula/tffdt")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(tffdt)

max_min_historica_mensal_manaus <-
  historico_total_manaus %>%
  filter(year(data_hora)>1903) %>%
  group_by(mes=month(data_hora)) %>%
  summarise(cota_max=max(nivel_cota),
            cota_min=min(nivel_cota),
            cota_med=median(nivel_cota)) %>%
  ungroup() %>%
  mutate(cota_recorde=max(cota_max))

max_min_historica_mensal_manaus %>%
  pivot_longer(starts_with('cota'),
               names_to = 'tipo',
               values_to = 'cota') %>%
  mutate(tipo=case_when(
    tipo=='cota_max' ~ 'Máxima',
    tipo=='cota_min' ~ 'Mínima',
    tipo=='cota_med' ~ 'Mediana',
    tipo=='cota_recorde' ~ 'Recorde'
  )) %>%
  ggplot(aes(factor(mes),cota,color=tipo,group=tipo))+
  geom_line()+
  geom_point()+
  #scale_y_discrete(labels=scales::comma)+
  labs(title = 'Máximas e Mínimas mensais históricas - 14990000',
       x='Mês',
       y='Cota (m)',
       color='Tipo')+
  theme_minimal()
```

<img src="man/figures/README-example_1-1.png" width="100%" />

``` r
max_min_historica_diaria_manaus <-
  historico_total_manaus %>%
  filter(year(data_hora)>1903) %>%
  group_by(mes=month(data_hora), dia=day(data_hora)) %>%
  summarise(cota_max=max(nivel_cota),
            cota_min=min(nivel_cota),
            cota_med=median(nivel_cota)) %>%
  ungroup() %>%
  mutate(cota_recorde=max(cota_max))

diaria_historico <- max_min_historica_diaria_manaus %>%
  pivot_longer(starts_with('cota'),
               names_to = 'tipo',
               values_to = 'cota') %>%
  mutate(tipo=case_when(
    tipo=='cota_max' ~ 'Máxima',
    tipo=='cota_min' ~ 'Mínima',
    tipo=='cota_med' ~ 'Mediana',
    tipo=='cota_recorde' ~ 'Recorde'  ),
    ano=2021
  ) %>%
  unite(data,dia,mes,ano,sep='/') %>%
  filter(data!='29/2/2021')%>%
  mutate(data=parse_date(data,format = '%d/%m/%Y'))

# Fazendo gráfico diário

diaria_historico%>%#filter(tipo=='Mediana') %>%
  ggplot(aes(data,cota,color=tipo,group=tipo))+
  geom_line()+
  geom_point()+
  scale_x_date(date_labels = '%d/%m',date_breaks = '45 days')+
  scale_y_continuous(labels = scales::comma_format(big.mark = '.',decimal.mark = ','))+
  labs(title = 'Máximas e Mínimas diárias históricas - 14990000',
       x='Mês',
       y='Cota (m)',
       color='Tipo')+
  theme_minimal()
```

<img src="man/figures/README-example_2-1.png" width="100%" />

``` r
dados_telemetria_2021 <- dados_telemetria_manaus %>%
  filter(year(data_hora)==2021) %>%
  rename(cota=nivel) %>%
  mutate(data=as_date(data_hora)
  ) %>%
  select(data,cota) %>%
  group_by(data) %>%
  summarise(cota=max(cota,na.rm = T)) %>%
  ungroup() %>%
  drop_na(cota) %>%
  mutate(tipo='2021')

# Juntando os dados telemétricos com a série histórica, junto
# com as linhas de atenção, alerta, inundação e recorde

tabela_grafico <-bind_rows(diaria_historico,dados_telemetria_2021) %>%
  pivot_wider(data,names_from = tipo,values_from = cota,values_fill = NA) %>%
  mutate(Atenção=2700, Alerta=2750, Inundação=2900, Recorde=2997)%>%
  pivot_longer(-data,names_to = 'tipo', values_to = 'cota')


g2021 <- tabela_grafico%>%
  ggplot(aes(data,cota,color=tipo,group=tipo,linetype=tipo))+
  geom_line()+
  # geom_line(. %>% filter(tipo=='2021'),size=2)+
  # geom_line(. %>% filter(tipo!='2021'),size=1.2)+
   scale_x_date(date_labels = '%d/%m',date_breaks = '1 month')+
  expand_limits(y=c(1000,3200))+
  scale_color_manual(values = c(
    '2021'='black',
    'Máxima'='blue',
    'Mínima' = 'blue',
    'Mediana' = 'green',
    'Alerta' = 'orange',
    'Atenção'= '#F0E442',
    'Inundação' = 'red',
    'Recorde' = 'gray'
  )
  )+
    scale_size_manual(breaks=c('2021','Máxima','Mínima','Mediana',
                               'Alerta','Atenção','Inundação','Recorde'),
                      values = c(1.5,1,1,1,1,1,1,1
  )
  )+
  scale_y_continuous(labels = scales::comma_format(big.mark = '.',
                                                   decimal.mark = ','))+
  labs(title = 'Máximas e Mínimas diárias históricas - 14990000',
       x='Mês',
       y='Cota (m)',
       color='Tipo',
       linetype='Tipo')+
  theme_minimal() 


g2021
```

<img src="man/figures/README-example_3-1.png" width="100%" />

``` r
g2021 + 
  coord_cartesian(ylim = c(2980,3010),xlim = c(as_date('2021-05-25'),as_date('2021-06-15')))+
  scale_x_date(date_labels = '%d/%m',date_breaks = '2 days')+
  geom_vline(xintercept=tabela_grafico %>% filter(cota>2997) %>% slice(1) %>% pull(data),
             linetype='dashed', color='red')+
  annotate("rect", xmin = as_date('2021-06-01'), xmax = as_date('2021-06-13'), 
           ymin = 2997, ymax = 3002.5,  alpha = .1)+
  annotate("text", x = as_date('2021-06-07'), y = 3004.5,
           label='Dias acima do recorde histórico')
```

<img src="man/figures/README-example_4-1.png" width="100%" />
