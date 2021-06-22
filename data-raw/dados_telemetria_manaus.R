## code to prepare `dados_telemetria_manaus` dataset goes here

# Para arrumar os dados, foi preciso transformar todos os dados em branco
# em NA, transformar as variáveis Nivel,Vazao e Chuva em númericos e
# DataHora em datetime.

dados_telemetria_manaus <- dados_brutos_telemetria_manaus %>%
  janitor::clean_names() %>% # transforma os nomes das colunas
  dplyr::na_if('')%>% # Substitui o '' por NA
  dplyr::mutate(dplyr::across(c(nivel,chuva,vazao),as.numeric), # Transforma as variáveis em númericos
                data_hora = stringr::str_squish(data_hora) %>% # Transforma em datetime
                  lubridate::as_datetime())

usethis::use_data(dados_telemetria_manaus, overwrite = TRUE)
