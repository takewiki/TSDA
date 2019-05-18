library(tsda);
conn <-conn_demo_setting();
tableNames <- db_tableNames(conn);
length(tableNames[tableNames == 'iris']) == 0;



data(iris)
names(iris) <-letters[1:5];
library(RJDBC)
dbWriteTable(conn, "iris", iris)


sql_select(conn,'select * from iris') ->bb;
conn;


cc <-db_writeTable(conn,'iris',iris);



db_iris <- db_readTable(conn,'iris');

library(RJDBC);
?dbSendUpdate;

dbSendUpdate(conn,'update iris set d =1');



?dbGetFields

dbGetFields(conn,'iris');


sql_update(conn,'drop table iris');

dbGetFields(conn,'t_GL_VOUCHER')



library(RJDBC);

dbExistsTable(conn,'iris');



dbGetFields(conn,name='iris');

dbRemoveTable(conn,'iris');


select * fro



