CREATE DATABASE if not exists stage;

drop table if exists stage.resumo_voo;

create table stage.resumo_voo(
	id int not null auto_increment comment 'Id da tabela Resumo Voo',
	empresa_sigla	varchar(03) comment 'XXX - Codigo da Empresa Aerea ICAO',
	empresa_nome    varchar(250) comment 'Nome da Empresa',
	ano             int comment '9999 - Ano do Voo',
	mes             int comment '99 - Mes do Voo',
	sigla_aeroporto_origem varchar(04) comment 'XXXX - ICAO do Aeroporto de Origem',
	nome_aeroporto_origem  varchar(250) comment 'Nome do Aeroporto de Origem',
	uf_aeroporto_origem    varchar(02) comment 'XX - Estado do Aeroporto de Origem',
	regiao_aeroporto_origem varchar(250) comment 'Região do Pais do Aeroporto de Origem',
	sigla_aeroporto_destino varchar(05) comment 'XXXX - ICAO do Aeroporto de Destino',
	nome_aeroporto_destino varchar(250) comment 'Nome do Aeroporto de Destino',
	uf_aeroporto_destino   varchar(02) comment 'XX - Estado do Aeroporto de Destino',
	regiao_aeroporto_destino varchar(250) comment 'Região do Pais do Aeroporto de Destino',
	natureza varchar(50) comment 'Natureza do Voo, Domestico ou Internacional',
	grupo_voo  varchar(50) comment 'Grupo de Voo, Regular ou Locacao',
	passageiros_pagos int comment 'Quantidade de Passageiros que Pagaram Passagem',
	distancia_km int comment 'Distancia entre o Aeroporto de Origem e Destino',
	assentos_total int comment 'Quantidade total de Assentos disponibilizados',
	primary key id(id)
);

ALTER TABLE stage.resumo_voo COMMENT = 'Informacoes sumarizadas sobre os voo por periodo';

drop table if exists stage.reclamacao_voo;

create table stage.reclamacao_voo(
	id int not null auto_increment comment 'Auto Incremeto Id da tabela Reclamacao Voo',
    regiao    varchar(05)  comment 'Regiao do Pais onde foi realizada a Reclamacao',
    uf_regiao varchar(02) comment 'XX - Estado do Pais onde foi realizada a Reclamacao',
    cidade    varchar(250) comment 'Cidade onde foi realizada a Reclamacao',
    sexo      char(01) comment 'A - Sexo do Cliente Reclamante',
    faixa_etaria varchar(50) comment 'Faixa Etaria do Reclamacao',
    data_abertura date comment 'YYYY-MM-DD - Data de Abertura da Reclamacao',
    data_resposta date comment 'YYYY-MM-DD - Data de Resposta da Reclamacao',
    data_finalizacao date comment 'YYYY-MM-DD - Data de Encerramento da Reclamacao',
    prazo_resposta date comment 'YYYY-MM-DD - Data Limite para Responder a Reclamacao',
    sigla varchar(03)  comment 'XXX - ICAO da Companhia Aerea',
    nome_fantasia varchar(250) comment 'Nome Fantasia da Companhia Aerea',
    problema      varchar(500)  comment 'Problema Relatado Pelo Cliente',
    local_compra  varchar(50)  comment 'Local de Compra da Passagem', 
    situacao varchar(50)  comment 'Situacao da Reclamacao',  
    avaliacao_reclamacao varchar(20)  comment 'Avaliacao do Cliente sobre sua Reclamacao',
    nota_consumidor int  comment 'Nota do Cliente para o Atendimento de sua Reclamacao',
	primary key id(id)
);

ALTER TABLE stage.reclamacao_voo COMMENT = 'Acompanhamento das Reclamacoes de Voos pelos Clientes';

/*

Dicionario de Dados


select case when @databas = ifnull(col.table_schema,'') and @tabela = ifnull(col.table_name,'') then '' else @databas := col.table_schema end base,
       case when @tabela = ifnull(col.table_name,'') then '' else @tabela := col.table_name end tabela,
       case when @comentario = ifnull(table_comment,'') then '' else @comentario := table_comment end comentario, 
       column_name coluna, 
       is_nullable nulo, 
       column_type datatype, 
       column_comment descricao  
from (select @commentario := '1', @tabela := '1', @databas := '1') as com
inner join information_schema.columns col
inner join information_schema.tables tab on tab.table_schema = col.table_schema and tab.table_name = col.table_name
where col.table_schema = 'stage'
order by col.table_schema, col.table_name, col.ordinal_position;


*/