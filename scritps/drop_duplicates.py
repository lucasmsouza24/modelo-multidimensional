from functions import execute_query
from sqlalchemy import create_engine
import pymysql
pymysql.install_as_MySQLdb()

conn = create_engine("mysql+mysqldb://root:urubu100@localhost/stage")
df = execute_query(database='stage', password='urubu100', user='root', sql='SELECT * FROM reclamacao_voo')

print('before: ', len(df.index))

df = df.drop_duplicates(subset = ['regiao',
'uf_regiao',
'cidade',
'sexo',
'faixa_etaria',
'data_abertura',
'data_resposta',
'data_finalizacao',
'prazo_resposta',
'sigla',
'nome_fantasia',
'problema',
'local_compra',
'situacao',
'avaliacao_reclamacao',
'nota_consumidor'])

df['nota_consumidor'] = df['nota_consumidor'].fillna(0)

print('after: ', len(df.index))

execute_query(database='stage', password='urubu100', user='root', sql='TRUNCATE TABLE reclamacao_voo')

df.to_sql(name="reclamacao_voo", con=conn, if_exists='append', index=False,method="multi")