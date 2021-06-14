## code to prepare `historico_total_manaus` dataset goes here

# Para poder utilizar o nível de água, que é a medição de cota,
# é preciso primeiramente retirar as variáveis que não tem interesse,
# já que a tabela bruta possui 78 variáveis.
# Como os dados dos dias estão dispostos em colunas, foi preciso colocar em formato
# longer para se adequar aos princípios tidy.Depois foram feitas as transformações
# como colocar em formato datetime e númerico.
# Depois foi preciso ordenar o banco de dados pelas colunas data_hora e nivel_consistencia
# para retirar as informações duplicadas, dando preferëncia aos dados de nível consistidos
# do que os brutos.

historico_total_manaus <-
  historico_bruto_total_manaus %>%
  dplyr::select(-ends_with('Status'),
         -DataIns,
         -EstacaoCodigo,
         -contains('Maxima'),
         -contains('Minima'),
         -contains('Media'),
         -TipoMedicaoCotas
  ) %>%
  tidyr::pivot_longer(starts_with('Cota'),
               names_to = 'dia_cota' ,
               values_to = 'nivel_cota') %>%
  janitor::clean_names() %>%
  dplyr::mutate(data_hora=lubridate::as_datetime(data_hora),
         dia_cota=stringr::str_remove(dia_cota,'Cota') %>% as.numeric(),
         nivel_cota=as.numeric(nivel_cota),
         data_hora= data_hora + lubridate::days(dia_cota-1),
         nivel_consistencia=as.numeric(nivel_consistencia)
  ) %>%
  dplyr::arrange(data_hora,desc(nivel_consistencia)) %>%
  dplyr::select(-dia_cota) %>%
  tidyr::drop_na(nivel_cota) %>%
  dplyr::distinct(data_hora,.keep_all = TRUE)

usethis::use_data(historico_total_manaus, overwrite = TRUE)
