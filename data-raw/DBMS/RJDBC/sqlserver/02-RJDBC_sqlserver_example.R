library(RJDBC)
drv <- JDBC("com.microsoft.sqlserver.jdbc.SQLServerDriver","/opt/sqljdbc_7.2/enu/mssql-jdbc-7.2.2.jre8.jar")
con <- dbConnect(drv, "jdbc:sqlserver://115.159.201.178:1433;databaseName=AIS20190427230019", "sa", "Hoolilay889@")
voucher <- dbGetQuery(con,'select * from T_GL_VOUCHER;')
View(voucher)

library(tsda);
sql_dirver <- sqlserver_jdbc_driver();
sql_conn <- conn(jdbc_driver = sql_dirver,server_ip ='115.159.201.178',port = '1433',db_name = 'AIS20190427230019',username = 'sa',password = 'Hoolilay889@' )
voucher2 <- sql_select(sql_conn,'select * from T_GL_VOUCHER;')

sql_conn@jc;
sql_dirver@driver_name;
sql_dirver@db_type;
sql_conn@jc@jclass;
