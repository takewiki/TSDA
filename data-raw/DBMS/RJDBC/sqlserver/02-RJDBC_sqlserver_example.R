library(RJDBC)
drv <- JDBC("com.microsoft.sqlserver.jdbc.SQLServerDriver","/opt/jdbc/mssql-jdbc-7.2.2.jre8.jar")
con <- dbConnect(drv, "jdbc:sqlserver://115.159.201.178:1433;databaseName=JH_2018B", "sa", "Hoolilay889@")
voucher <- dbGetQuery(con,'select * from T_GL_VOUCHER;')




library(tsda);
con <- sql_conn_common();
voucher <- dbGetQuery(con,'select * from T_GL_VOUCHER;')

class(voucher);




class(voucher2);

str(voucher2);

sql_conn@jc;
sql_dirver@driver_name;
sql_dirver@db_type;
sql_conn@jc@jclass;

View(voucher)
#sql select example----------
library(tsda);
sql_dirver <- sqlserver_jdbc_driver();
sql_conn <- conn(jdbc_driver = sql_dirver,server_ip ='115.159.201.178',port = '1433',db_name = 'AIS20190427230019',username = 'sa',password = 'Hoolilay889@' )
voucher2 <- sql_select(sql_conn,'select * from T_GL_VOUCHER;')

library(RJDBC);
table_list <- dbListTables(sql_conn);
class(table_list);
table_list;

sql_sel

#sql select into -----

voucher_into  <- sql_select(sql_conn,'select * into T_GL_VOUCHER2 from T_GL_VOUCHER;')






