## code to prepare `historico_bruto_total_manaus` dataset goes here
historico_total_manaus_bruto <-
  pegar_historico('14990000',tipo_dados = 1, nivel_consistencia = 1)

historico_total_manaus_consistido <-
  pegar_historico('14990000',tipo_dados = 1, nivel_consistencia = 2)

historico_bruto_total_manaus <-
  dplyr::bind_rows(historico_total_manaus_bruto,historico_total_manaus_consistido)

usethis::use_data(historico_bruto_total_manaus, overwrite = TRUE)
