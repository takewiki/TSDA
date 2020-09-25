conn_config_info <- conn_config(config_file = 'data-raw/conn_config_kjco.R')

conn <- conn_open(conn_config_info = conn_config_info)

sql <- "select top 10  * from rds_deal_bom_low_code"

data <- sql_select(conn,sql)
View(data)

conn_close(conn)


conn <- conn_open(conn_config_info = conn_config_info)

data2 <- sql_select(conn,sql)
conn_close(conn)
View(data2)


