CREATE DATABASE if not exists central_dados;

drop table if exists central_dados.cia_aerea;

create table central_dados.cia_aerea(
	id int not null auto_increment comment 'Chave Interna para as Empresas Aereas',
    sg_icao   varchar(03) not null comment 'Sigla da empresa Aerea na Organização da Aviação Civil Internacional (OACI) ',
    nm_aerea  varchar(100) not null comment 'Nome da Companhia Aerea',
	primary key id(id),
    unique key sg_icao(sg_icao),
    unique key nm_aerea(nm_aerea)
) ;

drop table if exists central_dados.aeroporto;

create table central_dados.aeroporto(
	id int not null auto_increment,
    sg_icao      varchar(05) not null comment 'Sigla do Aeroporto na Organização da Aviação Civil Internacional (OACI) ',
    nm_aeroporto  varchar(100) not null comment 'Nome do Aeroporto',
	primary key id(id),
    unique key sg_icao(sg_icao),
    key nm_aeroporto(nm_aeroporto)
) ;


