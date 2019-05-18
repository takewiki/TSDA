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

# 更新update数据------
#' 更新update数据
#'
#' @param conn 连接信息
#' @param sql_str sql信息
#'
#' @return 返回值
#' @import RJDBC
#' @export
#'
#' @examples sql_update();
sql_update <- function(conn,sql_str) {

  dbSendUpdate(conn,sql_str);

}



# 获取一个数据库中的所有表名-----
#' 获取一个数据库中的所有表名
#'
#' @param conn 连接信息
#'
#' @return 返回值
#' @import RJDBC
#' @export
#'
#' @examples db_tableNames()
db_tableNames <- function(conn) {
  res <- dbListTables(conn);
  return(res);

}

# 判断是否为新表-----
#' 判断是否为新表
#'
#' @param conn 数据库连接
#' @param table_name 数据库表名
#'
#' @return 返回值
#' @import RJDBC
#' @export
#'
#' @examples db_is_newTable();
db_is_newTable <- function(conn,table_name) {

   res <-dbExistsTable(conn,table_name);
   res <- !res
}

# 将R对象写入到SQL_server表中-------
#' 将R对象写入到SQL_server表中
#'
#' @param conn 连接信息
#' @param table_name 表名
#' @param r_object R对象表
#' @param skip 是否跳过表名重复检查，默认为是，不需要重复性
#'
#' @return 返回T表示插入成功，F可能是表名重复等
#' @import RJDBC
#' @export
#'
#' @examples db_saveR2Table();
db_writeTable <- function(conn,table_name,r_object,skip=FALSE){

  if (skip == TRUE){
    res<- dbWriteTable(conn, table_name, r_object)
  }else{
    if(db_is_newTable(conn,table_name)){
      res<- dbWriteTable(conn, table_name, r_object)
    }else{
      res <-FALSE
      # stop(paste('表名:',table_name,"已在数据库中存在，请使用insert语句处理!"),call. = F)
    }
  }

  return(res)

}
# 读取整表数据------
#' 读取整表数据
#'
#' @param conn 数据库连接
#' @param table_name 表名
#'
#' @return 返回值
#' @import RJDBC
#' @export
#'
#' @examples db_readTable();
db_readTable <- function(conn,table_name) {
  res <- dbReadTable(conn, table_name)
  return(res)


}

#' 删除数据库中的表结构
#'
#' @param conn 连接信息
#' @param table_name 表名
#'
#' @return 返回值
#' @export
#'
#' @examples db_dropTable()
db_dropTable <- function(conn,table_name) {
  dbRemoveTable(conn,table_name);
}


