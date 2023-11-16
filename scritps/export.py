from functions import extract_and_export

# exports
extract_and_export(database='stage', table_name='view_resumo_voo', user='marketing', password='marketing100')
extract_and_export(database='stage', table_name='view_reclamacao_voo', user='qualidade_voo', password='qualidade100')
extract_and_export(database='stage', table_name='view_resumo_voo_x_reclamacao_voo', user='diretoria', password='diretoria100')