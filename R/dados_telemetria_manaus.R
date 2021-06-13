#' Dados arrumados da Telemetria 14990000 de Manaus
#'
#' Um banco de dados contendo mais de 270.000 informações. Pegando os dados brutos e
#' trabalhado da seguinte maneira.
#'
#' dados_brutos_telemetria_manaus %>%
#' janitor::clean_names() %>%
#'  dplyr::na_if('')%>%
#'  dplyr::mutate(dplyr::across(c(nivel,chuva,vazao),as.numeric),
#'                data_hora = stringr::str_squish(data_hora) %>%
#'                  lubridate::as_datetime())
#'
#'  As variáveis são:
#'
#' \itemize{
#'   \item cod_estacao. Código da Estação
#'   \item data_hora. Data e Hora do Dado
#'   \item vazao. Quantidade de Vazão no período
#'   \item nivel. Nível da Água no momento da medição
#'   \item chuva. Nível de água captada pela chuva
#'
#' }
#'
#' @docType data
#' @keywords datasets
#' @name dados_brutos_telemetria_manaus
#' @usage data(dados_brutos_telemetria_manaus)
#' @format A data frame with 270677 rows and 5 variables
