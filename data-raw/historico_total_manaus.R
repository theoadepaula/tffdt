## code to prepare `historico_total_manaus` dataset goes here

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
