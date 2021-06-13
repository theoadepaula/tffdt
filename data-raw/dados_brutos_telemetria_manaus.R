## code to prepare `dados_brutos_telemetria_manaus` dataset goes here
dados_brutos_telemetria_manaus <- pegar_dados('14990000',
                                       data_inicio = '01/01/1900',
                                       data_fim = '13/06/2021')
usethis::use_data(dados_brutos_telemetria_manaus, overwrite = TRUE)
