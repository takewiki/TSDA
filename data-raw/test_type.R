library(tsda)
conn <- conn_rds()
sql <- "select a.name as FFieldName,b.name as FTypeName from sys.columns  a
inner join sys.types b
on a.system_type_id = b.system_type_id

where a.object_id=object_id('books') "
mydata <- sql_select(conn,sql)


View(mydata)


sql_fieldInfo(table_name = 't_test')
sql_fieldInfo(table_name = 'conn')
