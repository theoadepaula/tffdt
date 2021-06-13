#' Pegar histórico da série telemétrica da estação
#'
#' @importFrom httr GET
#' @importFrom httr content
#' @importFrom XML xmlParse
#' @importFrom XML getNodeSet
#' @importFrom XML xmlToDataFrame
#' @importFrom tibble tibble
#'
#' @param cod_estacao Código da Estação Telemétrica
#' @param data_inicio Data com o formato DD/MM/AAAA
#' @param data_fim Data com o formato DD/MM/AAAA
#' @param tipo_dados1-Cotas Digitar 1-Cotas, 2-Chuvas ou 3-Vazões
#' @param nivel_consistencia 1-Bruto ou 2-Consistido
#'
#' @return Um tibble com a série histórica.
#' @export
#'
#' @examples pegar_historico('14990000','01/01/2000','31/01/2000',1,1)
#'
pegar_historico <- function(cod_estacao,
                            data_inicio='',
                            data_fim='',
                            tipo_dados,
                            nivel_consistencia) {

  url <- 'http://telemetriaws1.ana.gov.br/ServiceANA.asmx/HidroSerieHistorica?'

  dados_hidro <- GET(url,
                     query = list(
                       codEstacao=cod_estacao,
                       dataInicio=data_inicio,
                       dataFim= data_fim,
                       tipoDados=tipo_dados,
                       nivelConsistencia=nivel_consistencia
                     ))

  tabela_hidro <- content(dados_hidro,type='text') %>%
    XML::xmlParse(encoding = 'UTF-8') %>%
    getNodeSet('//SerieHistorica') %>%
    xmlToDataFrame() %>%
    tibble()

}
