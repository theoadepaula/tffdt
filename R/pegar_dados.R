#' Pegar os dados da estação telemétrica
#'
#' @importFrom lubridate floor_date
#' @importFrom httr GET
#' @importFrom httr content
#' @importFrom XML xmlParse
#' @importFrom XML getNodeSet
#' @importFrom XML xmlToDataFrame
#' @importFrom tibble tibble
#'
#'
#' @param nome_estacao Código da Estação Telemétrica
#' @param data_inicio Data com o formato DD/MM/AAAA
#' @param data_fim Data com o formato DD/MM/AAAA
#'
#' @return Um tibble com dados telemétricos, puxando os dados do começo do ano vigente até o dia de hoje.
#' @export
#'
#' @examples pegar_dados(14990000,'01/01/2021','10/01/2021')
pegar_dados <- function(nome_estacao,
                        data_inicio=format(floor_date( Sys.Date(),unit='years'),'%d/%m/%Y'),
                        data_fim=format(Sys.Date(),'%d/%m/%Y'))
{
  url <- 'http://telemetriaws1.ana.gov.br/ServiceANA.asmx/DadosHidrometeorologicos?'

  dados_hidro <- GET(url,
                     query = list(
                       codEstacao=nome_estacao,
                       dataInicio=data_inicio,
                       dataFim= data_fim
                     ))

  tabela_hidro <- content(dados_hidro,type='text') %>%
    XML::xmlParse(encoding = 'UTF-8') %>%
    getNodeSet('//DadosHidrometereologicos') %>%
    xmlToDataFrame() %>%
    tibble()
}
