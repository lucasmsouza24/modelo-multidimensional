import mysql.connector as connection
import pandas as pd

def get_conn(database, user, password):
    conn = connection.connect(host="localhost", database=database, user=user, passwd=password, use_pure=True)
    return conn

def execute_query(sql, database, user, password):
    mydb = get_conn(database=database, user=user, password=password)
    try:
        result_dataFrame = pd.read_sql(sql,mydb)
        mydb.close() #close the connection
        return result_dataFrame
    except Exception as e:
        mydb.close()
        print(str(e))
        return 'Error'

def export_file(table_name, dataframe):
    # exporting data to CSV file
    try:
        dataframe.to_csv(f'./exports/{table_name}.csv', index = False, encoding='utf-8', header=True)
        print('Data exported')
    except:
        print('Error while exporting data')

# extract data from database, then export that as CSV file
def extract_and_export(table_name, database, user, password):
    # extracting data from database
    dataframe = execute_query(f'SELECT * FROM {table_name}', database, user, password)
    export_file(table_name, dataframe)