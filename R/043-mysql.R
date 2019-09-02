#' mysql 数据库连接设置
#'
#' @param ip 服务器IP地址
#' @param port 商品号
#' @param user_name 用户名
#' @param password 密码
#' @param db_name 数据库名称
#'
#' @return 返回值
#' @export
#'
#' @examples
#' mysql_conn_common();
mysql_conn_common <- function(ip='localhost',
                              port=3306,
                              user_name='root',
                              password='Hoolilay889@',
                              db_name='rdkc'
                              ) {
  drv <- JDBC("com.mysql.cj.jdbc.Driver","/opt/jdbc/mysql/mysql-connector-java-8.0.16.jar",identifier.quote="`")
  con_str <- paste("jdbc:mysql://",ip,":",port,"/",db_name,sep="");
  con <- dbConnect(drv, con_str, user_name, password)
  return(con)

}


#' 设置pms连接信息
#'
#' @return 返回值
#'
#' @examples
#' pms_info()
pms_info <- function(){
  username <- 'admin';
  password <-'1qaz2wsx';
  res <-list(username,password);
  return(res);
}

#' 设置pms的连接信息
#'
#' @return 返回值
#' @import RJDBC
#' @export
#'
#' @examples
#' mysql_conn_pms();
mysql_conn_pms <- function() {
  info <- pms_info();
  drv <- JDBC("com.mysql.cj.jdbc.Driver","/opt/jdbc/mysql/mysql-connector-java-8.0.16.jar",identifier.quote="`")
  con <- dbConnect(drv, "jdbc:mysql://118.190.205.117:3306/sendplan?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC", info$username, info$password)
  return(con);

}


