-- marketing
CREATE OR REPLACE VIEW view_resumo_voo AS SELECT 
*
FROM resumo_voo;

-- qualidade voo
CREATE OR REPLACE VIEW view_reclamacao_voo AS SELECT 
*
FROM reclamacao_voo;

-- diretoria
CREATE OR REPLACE VIEW view_resumo_voo_x_reclamacao_voo AS 
SELECT 
t1.empresa_sigla,
t1.empresa_nome, 
t1.ano, 
t1.mes, 
t1.sigla_aeroporto_origem, 
t1.nome_aeroporto_origem, 
t1.uf_aeroporto_origem, 
t1.regiao_aeroporto_origem, 
t1.sigla_aeroporto_destino, 
t1.nome_aeroporto_destino, 
t1.uf_aeroporto_destino, 
t1.regiao_aeroporto_destino, 
t1.natureza, 
t1.grupo_voo, 
t1.passageiros_pagos, 
t1.distancia_km, 
t1.assentos_total,
t2.regiao,
t2.uf_regiao,
t2.cidade,
t2.sexo,
t2.faixa_etaria,
t2.data_abertura,
t2.data_resposta,
t2.data_finalizacao,
t2.prazo_resposta,
t2.sigla,
t2.nome_fantasia,
t2.problema,
t2.local_compra,
t2.situacao,
t2.avaliacao_reclamacao,
t2.nota_consumidor 
FROM view_resumo_voo as t1
INNER JOIN view_reclamacao_voo as t2 ON t1.empresa_sigla = t2.sigla AND
t1.uf_aeroporto_origem = t2.uf_regiao AND
t1.nome_aeroporto_origem = t2.cidade AND 
t1.ano = YEAR(t2.data_abertura) AND
t1.mes = MONTH(t2.data_abertura);