#' 定义一下虚拟的jdbc_dirver类
#'
#' @slot driver_name character. 驱动类型
#' @slot driver_location character.驱动位置
#' @slot os_type character. 操作系统类型
#' @slot db_type 数据库类型
#'
#' @return 返回值
#' @export
#'
#' @examples jdbc_dirver
setClass("jdbc_driver", slots = c(driver_name = "character",
                                  driver_location='character',
                                  os_type='character',
                                  db_type='character'),
         contains = 'VIRTUAL')

#' 定义sqlserver_jdbc_driver类
#'
#' @return 返回值
#' @export
#'
#' @examples sqlserver_jdbc_driver();
setClass("sqlserver_jdbc_driver", contains = 'jdbc_driver',
         prototype = prototype(driver_name='com.microsoft.sqlserver.jdbc.SQLServerDriver',
                               driver_location="/opt/sqljdbc_7.2/enu/mssql-jdbc-7.2.2.jre8.jar",
                               os_type='linux',
                               db_type='sqlserver'))
#' 定义sqlserver_jdbc_driver入口实例化函数
#'
#' @param driver_location 驱动存放位置
#' @param os_type 操作系统类型
#'
#' @return 返回值
#' @export
#'
#' @examples sqlserver_jdbc_driver();
sqlserver_jdbc_driver <- function(driver_location='/opt/sqljdbc_7.2/enu/mssql-jdbc-7.2.2.jre8.jar',
                                  os_type='linux') {
  res1 <- new('sqlserver_jdbc_driver');
  res2 <- initialize(res1,driver_location=driver_location,os_type=os_type);
  return(res2)
}

#' 定义连接的通用函数
#'
#' @param x 名称对
#' @param server_ip 服务器地址
#' @param db_name 数据库名称
#' @param username 用户名
#' @param password  密码
#'
#' @return 返回值
#' @export
#'
#' @examples conn();
setGeneric("conn",
           signature = "jdbc_driver",
           function(jdbc_driver,server_ip,port,db_name,username,password) standardGeneric("conn"))

#' 用于生成conn相应的sqlserver_jdbc_driver对应的连接信息
#'
#' @param jdbc_driver sqlserver_jdbc_driver.
#'
#' @return 返回值
#' @import RJDBC
#' @export
#'
#' @examples conn();
setMethod("conn",
          c("jdbc_driver" = "sqlserver_jdbc_driver"),
          function(jdbc_driver,server_ip,port='1433',db_name,username,password){
            #code here
            sqlserver_driver <- JDBC(jdbc_driver@driver_name,jdbc_driver@driver_location);
            sql_driver_prefix <-'jdbc:sqlserver://';
            jdbc_str <-paste(sql_driver_prefix,server_ip,":",port,";databaseName=",db_name,sep="");

            res <- dbConnect(sqlserver_driver, jdbc_str, username, password);
            return(res);
                      })


#' 执行sql的查询语句
#'
#' @param conn 连接信息
#' @param sql_str 语句
#'
#' @return 返回值
#' @import RJDBC
#' @export
#'
#' @examples sql_select();
sql_select <- function(conn,sql_str) {
  res <- dbGetQuery(conn,sql_str)
  return(res)
}




