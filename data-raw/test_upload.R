mydata <- data.frame(flarge=LETTERS,fsmall=letters)

conn <- conn_rds()

table_name='letter'

upload_data(conn,table_name,mydata)
