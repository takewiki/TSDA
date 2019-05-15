bb <- select_gen_sqlserver(table_name='T_GL_VOUCHER',
                           col_vec=c('FDATE','FYEAR','FPERIOD','FBILLNO'),
                           row_where_expr="FDATE>='2019-01-01' and fdate <= '2019-03-31' ",order_vec=c('FDATE','FBILLNO'),order_asc_logical=c(T,T));
bb;
cc <- select_gen_sqlserver(table_name='T_GL_VOUCHER',
                           col_vec=c('FDATE','FYEAR','FPERIOD','FBILLNO'),
                           row_where_expr=NULL,order_vec=c('FDATE','FBILLNO'),order_asc_logical=c(F,T));
cc;
dd <- select_gen_sqlserver(table_name='T_GL_VOUCHER',
                           col_vec=c('FDATE','FYEAR','FPERIOD','FBILLNO'),
                           row_where_expr=NULL);
dd;
