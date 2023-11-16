USE stage;

-- dimensao regiao
CREATE OR REPLACE VIEW dm_regiao AS
SELECT DISTINCT ROW_NUMBER() OVER () as regiao_id, regiao, uf_regiao
FROM reclamacao_voo
GROUP BY regiao, uf_regiao;

CREATE OR REPLACE VIEW dm_cidade AS
SELECT DISTINCT
    uf_regiao,
    cidade
FROM reclamacao_voo;

-- dimensao tempo
CREATE OR REPLACE VIEW dm_tempo AS
SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY ano, mes) AS tempo_id,
                ano, mes
FROM resumo_voo
GROUP BY ano, mes;

-- dimensao aeroporto
CREATE OR REPLACE VIEW dm_aeroporto AS
SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY sigla_aeroporto, nome_aeroporto) AS aeroporto_id,
                sigla_aeroporto, nome_aeroporto,
                uf_aeroporto, regiao_aeroporto
FROM (
    SELECT sigla_aeroporto_origem AS sigla_aeroporto, nome_aeroporto_origem AS nome_aeroporto,
           uf_aeroporto_origem AS uf_aeroporto, regiao_aeroporto_origem AS regiao_aeroporto
    FROM resumo_voo
    UNION
    SELECT sigla_aeroporto_destino, nome_aeroporto_destino, uf_aeroporto_destino, regiao_aeroporto_destino
    FROM resumo_voo
) AS Aeroportos;

-- dimensao empresa
CREATE OR REPLACE VIEW dm_empresa AS SELECT DISTINCT
    empresa_sigla, 
    empresa_nome
FROM resumo_voo
UNION
SELECT DISTINCT
    sigla,
    nome_fantasia
FROM reclamacao_voo;

-- fato reclamacao
CREATE OR REPLACE VIEW ft_reclamacao AS 
SELECT 
    rc.uf_regiao as dm_uf_regiao, -- DIM REGIAO
    rc.sexo,
    rc.faixa_etaria,
    rc.data_abertura,
    rc.data_resposta,
    rc.data_finalizacao,
    rc.prazo_resposta,
    rc.sigla as dm_empresa_sigla, -- DIM_EMPRESA
    rc.problema,
    rc.local_compra,
    rc.situacao,
    rc.avaliacao_reclamacao,
    rc.nota_consumidor,
    rv.ano,
    rv.mes,
    rv.sigla_aeroporto_origem as dm_sigla_aero_origem, -- DIM_AEROPORTO
    rv.sigla_aeroporto_destino as dm_sigla_aero_destino, -- DIM_AEROPORTO
    rv.natureza,
    rv.grupo_voo,
    rv.passageiros_pagos,
    rv.distancia_km,
    rv.assentos_total 
FROM reclamacao_voo rc JOIN resumo_voo rv 
ON  rc.cidade = rv.nome_aeroporto_origem AND
    MONTH(rc.data_abertura) = rv.mes AND
    YEAR(rc.data_abertura) = rv.ano AND
    rc.sigla = rv.empresa_sigla;