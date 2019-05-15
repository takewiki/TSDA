#' 定义排序判断转换函数
#'
#' @param x 逻辑变量
#'
#' @return 返回值
#'
#' @examples logical_as_asc();
logical_as_asc <- function(x){
 if (x){
   'asc'
 }else{
   'desc'
 }
}

#' 排序判断辅助函数
#'
#' @param logical_vec 逻辑变量
#'
#' @return 返回值
#'
#' @examples logical_as_ascs();
logical_as_ascs <-function(logical_vec){
  unlist(lapply(logical_vec, logical_as_asc))
}
#' 定义sqlserver的语句自动生成函数
#'
#' @param table_name 表名称
#' @param col_vec 字段名向量
#' @param row_where_expr where表达式，完全使用tsql语法
#' @param order_vec   排序字段
#' @param order_asc_logical 逻辑表达式TRUE表示asc,FALSE表示desc
#'
#' @return 返回值
#' @include 040-aaaparam.R
#' @export
#'
#' @examples
#' bb <- select_gen_sqlserver(table_name='T_GL_VOUCHER',
#' col_vec=c('FDATE','FYEAR','FPERIOD','FBILLNO'),
#' row_where_expr="FDATE>='2019-01-01' and fdate <= '2019-03-31' ",order_vec=c('FDATE','FBILLNO'),order_asc_logical=c(T,T));
#' bb;
#' cc <- select_gen_sqlserver(table_name='T_GL_VOUCHER',
#' col_vec=c('FDATE','FYEAR','FPERIOD','FBILLNO'),
#' row_where_expr=NULL,order_vec=c('FDATE','FBILLNO'),order_asc_logical=c(F,T));
#' cc;
#' dd <- select_gen_sqlserver(table_name='T_GL_VOUCHER',
#' col_vec=c('FDATE','FYEAR','FPERIOD','FBILLNO'),
#' row_where_expr=NULL);
#' dd;
select_gen_sqlserver <- function(table_name='T_GL_VOUCHER',
                                 col_vec=c('FDATE','FYEAR','FPERIOD','FBILLNO'),
                                 row_where_expr=NULL,order_vec=NULL,order_asc_logical=NULL) {

#定义拼接的字段
  prefix <- 'select ';
  field_str <- paste(col_vec,collapse = ',');
  from_str <-'   from  ';
  where_str <-'  where   ';
  order_by <-'  order by  '
  if( !is.null(order_vec)){
    # 针对排序定义了辅助函数
    order_str<- paste(order_vec,logical_as_ascs(order_asc_logical),sep = " ",collapse = ',')
    if(!is.null(row_where_expr)){
      #最全的情况
      paste(prefix,field_str,from_str,table_name,where_str,row_where_expr,order_by,order_str,sep="");
    }else{
      #没有where，需要排序
      paste(prefix,field_str,from_str,table_name,order_by,order_str,sep="");
    }
  }else{
    #以下不需要排序,带where
    if(!is.null(row_where_expr)){
      paste(prefix,field_str,from_str,table_name,where_str,row_where_expr,sep="");
    }else{
      #全表查询
      paste(prefix,field_str,from_str,table_name,"   ",sep="");
    }
  }
}




#' 读取棱星数据库的配置信息
#'
#' @param db_name 数据库名称,其他信息已加密处理
#'
#' @return 返回值
#' @export
#'
#' @examples sql_conn_rd
sql_conn_rd <- function(db_name='AIS20190427230019') {
  conn_demo_setting(db_name)
}





