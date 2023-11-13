-- Empresas que lideram voos por estados
CREATE OR REPLACE VIEW lideranca_voo_por_estado AS
SELECT empresa_nome, uf_aeroporto_origem, COUNT(*) AS quantidade_voos FROM resumo_voo
GROUP BY empresa_nome, uf_aeroporto_origem
ORDER BY quantidade_voos DESC;

