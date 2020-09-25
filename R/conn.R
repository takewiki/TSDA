#' 创建连接信息
#'
#' @param config_file  配置文件
#'
#' @return 返回值
#' @export
#'
#' @examples
#' conn_static_info()
conn_config  <- function(config_file='data-raw/conn_config_rds.R') {
  res <- new.env()
  source(file = config_file,local = res,encoding = 'utf-8')
  return(res)

}

#' 打印数据库连接
#'
#' @param conn_config_info 连接配置对象
#'
#' @return 返回值
#' @import RJDBC
#' @export
#'
#' @examples
#' conn_open()
conn_open <- function(conn_config_info) {
  drv <- JDBC("com.microsoft.sqlserver.jdbc.SQLServerDriver","/opt/jdbc/mssql-jdbc-7.2.2.jre8.jar")
  ip = conn_config_info$ip;
  port = conn_config_info$port;
  db_name = conn_config_info$db_name;
  user_name = conn_config_info$user_name;
  password = conn_config_info$password;
  con_str <- paste("jdbc:sqlserver://",ip,":",port,";databaseName=",db_name,sep="");
  con <- dbConnect(drv, con_str, user_name, password)
  return(con)
}

#' 关闭数据库连接
#'
#' @param conn_obj 数据库连接对接
#'
#' @return 无
#' @export
#'
#' @examples
#' conn_close()
conn_close <- function(conn_obj) {
  dbDisconnect(conn = conn_obj)

}


