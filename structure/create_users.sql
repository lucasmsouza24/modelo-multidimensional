DROP USER 'marketing'@'localhost';
DROP USER 'qualidade_voo'@'localhost';
DROP USER 'diretoria'@'localhost';

CREATE USER 'marketing'@'localhost' IDENTIFIED BY 'marketing100';
CREATE USER 'qualidade_voo'@'localhost' IDENTIFIED BY 'qualidade100';
CREATE USER 'diretoria'@'localhost' IDENTIFIED BY 'diretoria100';

GRANT SELECT ON stage.view_resumo_voo TO 'marketing'@'localhost';
GRANT SELECT ON stage.view_reclamacao_voo TO 'qualidade_voo'@'localhost';
GRANT SELECT ON stage.view_resumo_voo_x_reclamacao_voo TO 'diretoria'@'localhost';

FLUSH PRIVILEGES;