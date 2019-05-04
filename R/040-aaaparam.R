rd_setting <- function(db_name){
  sql_dirver <- sqlserver_jdbc_driver();
  sql_conn <- conn(jdbc_driver = sql_dirver,server_ip ='115.159.201.178',port = '1433',db_name = db_name,username = 'sa',password = 'Hoolilay889@' )

}
