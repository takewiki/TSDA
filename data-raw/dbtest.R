library(RJDBC)
drv <- JDBC("com.microsoft.sqlserver.jdbc.SQLServerDriver","/opt/jdbc/mssql-jdbc-7.2.2.jre8.jar")
con <- dbConnect(drv, "jdbc:sqlserver://115.159.201.178:1433;databaseName=test", "sa", "Hoolilay889@")
voucher <- dbGetQuery(con,'select * from t_test;')
View(voucher);

var <- as.list(.GlobalEnv)

print(var)
var_names <- names(var)

for (i in seq_along(var_names)){
  if (class(var[[var_names[i]]]) == "JDBCConnection"){
    print('true')
    dbDisconnect(var[[var_names[i]]])
    print(var[[var_names[i]]])
    print('A')
  }
}

dbDisconnect(con)

?dbDisconnect

RJDBC::dbDisconnect

.GlobalEnv$con

library(RJDBC)
dbSendQuery(con,"SELECT 1")
