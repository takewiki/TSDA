server_ip <-'115.159.201.178'
port <- '1433'
username <- 'sa'
password <- 'Hoolilay889@'

Sys.setenv(server_ip=server_ip,
           port=port,
           username=username,
           password=password)

Sys.getenv('username');
Sys.getenv('password');
Sys.getenv('server_ip');
Sys.getenv('port');


get_conn_demo<- function(db_name='AIS20190427230019'){
  sql_dirver <- sqlserver_jdbc_driver();
  sql_conn <- conn(jdbc_driver = sql_dirver,
                   server_ip =Sys.getenv('server_ip'),
                   port = Sys.getenv('port'),
                   db_name = db_name,
                   username = Sys.getenv('username'),
                   password = Sys.getenv('password') )

}

#' 进入默认演示服务器
#'
#' @param db_name 数据库名称
#'
#' @return 返回值
#' @export
#'
#' @examples conn_demo_setting();
conn_demo_setting <- function(db_name='AIS20190427230019'){
  get_conn_demo(db_name)

}
