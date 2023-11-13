if (!require('RMySQL')) install.packages ('RMySQL')
if (!require('stringr')) install.packages ('stringr')
library("DBI")
library("RMySQL")
library("stringr")
# variaveis de conexão com banco de dados
db_user <- 'root'
db_password<-'urubu100'
db_schema<-'stage'
db_host<-'localhost'
# conexão com banco de dados
db_stage = dbConnect(MySQL(), user = db_user, password = db_password, dbname=db_schema, host = db_host)
#usuario precisa ter permissa de SUPER para poder alterar global do banco
dbExecute(db_stage, 'set global local_infile=on')
# função para limpara caracteres de quebra de pagina / ESC 
limpa_caracter = function (vColuna) {
  
  vtratado <-str_trim(str_replace_all(str_replace_all(str_replace_all(str_replace_all(vColuna,'\r',''),'\n',''),'\t',''),'\r\n',''))
  
  return (vtratado)
  
}
# função para tratamento de datas
trata_data = function (vColuna) {
  
  vtratado <-strptime(vColuna,format="%d/%m/%Y")
  
  return (vtratado)
  
}
# ========================================================================
# Extração
# ========================================================================
# definir pasta onde o R irá buscar seus arquivos CSV
setwd("./source")
# importar CSV
voo<-read.csv2(file = "voos_realizados.csv", header = TRUE, sep=";", encoding = "UTF-8")
# renomear o header do data frame
names(voo)<-c("empresa_sigla", "empresa_nome", "ano", "mes", "sigla_aeroporto_origem", "nome_aeroporto_origem", "uf_aeroporto_origem", "regiao_aeroporto_origem", "sigla_aeroporto_destino", "nome_aeroporto_destino", "uf_aeroporto_destino", "regiao_aeroporto_destino", "natureza", "grupo_voo", "passageiros_pagos", "distancia_km", "assentos_total")
# ========================================================================
# Transformação
# ========================================================================
# 1a forma de fazer a limpeza - escrever sempre os mesmos comandos
voo$empresa_sigla<-str_trim(str_replace_all(str_replace_all(str_replace_all(
                   str_replace_all(voo$empresa_sigla,'\r',''),'\n',''),'\t',''),'\r\n',''))
# 2a forma de fazer a limpeza -  criar uma função que contenha os comandos
#voo$empresa_sigla<-limpa_caracter(voo$empresa_sigla)
voo$empresa_nome<-limpa_caracter(voo$empresa_nome)
voo$ano<-limpa_caracter(voo$ano)
voo$mes<-limpa_caracter(voo$mes)
voo$sigla_aeroporto_origem<-limpa_caracter(voo$sigla_aeroporto_origem)
voo$nome_aeroporto_origem<-limpa_caracter(voo$nome_aeroporto_origem)
voo$uf_aeroporto_origem<-limpa_caracter(voo$uf_aeroporto_origem)
voo$regiao_aeroporto_origem<-limpa_caracter(voo$regiao_aeroporto_origem)
voo$sigla_aeroporto_destino<-limpa_caracter(voo$sigla_aeroporto_destino)
voo$nome_aeroporto_destino<-limpa_caracter(voo$nome_aeroporto_destino)
voo$uf_aeroporto_destino<-limpa_caracter(voo$uf_aeroporto_destino)
voo$regiao_aeroporto_destino<-limpa_caracter(voo$regiao_aeroporto_destino)
voo$natureza<-limpa_caracter(voo$natureza)
voo$grupo_voo<-limpa_caracter(voo$grupo_voo)
voo$passageiros_pagos<-limpa_caracter(voo$passageiros_pagos)
voo$distancia_km<-limpa_caracter(voo$distancia_km)
voo$assentos_total<-limpa_caracter(voo$assentos_total)
# substituir valores null por zero
voo$passageiros_pagos[is.na(voo$passageiros_pagos)] <-0
voo$distancia_km[is.na(voo$distancia_km)] <-0
voo$assentos_total[is.na(voo$assentos_total)] <-0

# Truncar dados da tabela no banco de dados que ira receber os dados
# preparar o comando para truncar a tabela
truncar_tabela<-"truncate table stage.resumo_voo"
# executar o comando que trunca a tabela
dbExecute(db_stage, truncar_tabela)

# ========================================================================
# Carga
# ========================================================================
# carregar dados em lote na tabela
dbWriteTable(db_stage, name="resumo_voo", value=voo, row.names=FALSE, append=TRUE)

# apagar record set para liberar memoria
rm(voo)

#
#   carga de dados da segunda tabela
#
# ========================================================================
# Extração
# ========================================================================
reclamacao<-read.csv2(file = "reclamacao_clientes.csv", header = TRUE, sep=";", encoding = "UTF-8")


# ========================================================================
# Transformação
# ========================================================================
names(reclamacao)<-c("regiao", "uf_regiao", "cidade", "sexo", "faixa_etaria", "data_abertura", "data_resposta", 
                     "data_finalizacao", "prazo_resposta", "sigla", "nome_fantasia", "problema", "local_compra", 
                     "situacao", "avaliacao_reclamacao", "nota_consumidor")

reclamacao$regiao<-limpa_caracter(reclamacao$regiao)
reclamacao$uf_regiao<-limpa_caracter(reclamacao$uf_regiao)
reclamacao$cidade<-limpa_caracter(reclamacao$cidade)
reclamacao$sexo<-limpa_caracter(reclamacao$sexo)
reclamacao$faixa_etaria<-limpa_caracter(reclamacao$faixa_etaria)
reclamacao$data_abertura<-limpa_caracter(reclamacao$data_abertura)
reclamacao$data_resposta<-limpa_caracter(reclamacao$data_resposta)
reclamacao$data_finalizacao<-limpa_caracter(reclamacao$data_finalizacao)
reclamacao$prazo_resposta<-limpa_caracter(reclamacao$prazo_resposta)
reclamacao$sigla<-limpa_caracter(reclamacao$sigla)
reclamacao$nome_fantasia<-limpa_caracter(reclamacao$nome_fantasia)
reclamacao$problema<-limpa_caracter(reclamacao$problema)
reclamacao$local_compra<-limpa_caracter(reclamacao$local_compra)
reclamacao$situacao<-limpa_caracter(reclamacao$situacao)
reclamacao$avaliacao_reclamacao<-limpa_caracter(reclamacao$avaliacao_reclamacao)
reclamacao$nota_consumidor<-limpa_caracter(reclamacao$nota_consumidor)
#
reclamacao$data_abertura<-trata_data(reclamacao$data_abertura)
reclamacao$data_resposta<-trata_data(reclamacao$data_resposta)
reclamacao$data_finalizacao<-trata_data(reclamacao$data_finalizacao)
reclamacao$prazo_resposta<-trata_data(reclamacao$prazo_resposta)

limpa_reclamacao<-"truncate table reclamacao_voo"
dbExecute(db_stage, limpa_reclamacao)

# ========================================================================
# Carga
# ========================================================================
dbWriteTable(db_stage, name="reclamacao_voo", value=reclamacao, row.names=FALSE, append=TRUE)
rm(reclamacao)

# ========================================================================
# ETL Reverso
# ========================================================================
sql_aero<-"insert into central_dados.cia_aerea(sg_icao, nm_aerea)
          select empresa_sigla sg_icao, empresa_nome nm_aerea from stage.resumo_voo rv
          where not exists (select 1 from central_dados.cia_aerea ca where ca.sg_icao = rv.empresa_sigla)
          group by empresa_sigla, empresa_nome"

dbExecute(db_stage, sql_aero)

sql_aeroporto<-"insert into central_dados.aeroporto(sg_icao, nm_aeroporto)
            select sg_icao, nm_aeroporto
            from (select sigla_aeroporto_origem sg_icao, nome_aeroporto_origem nm_aeroporto from stage.resumo_voo
                  union 
                  select sigla_aeroporto_destino sg_icao, nome_aeroporto_destino nm_aeroporto from stage.resumo_voo) as rv
            where not exists (select 1 from central_dados.aeroporto ca where ca.sg_icao = rv.sg_icao)
            group by sg_icao, nm_aeroporto"

dbExecute(db_stage, sql_aeroporto)

dbDisconnect(db_stage)
