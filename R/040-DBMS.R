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
