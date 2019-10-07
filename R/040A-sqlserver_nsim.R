#配置nsim系统数据
#' 配置nsim的数据库设置
#'
#' @return 返回值
#' @export
#'
#' @examples
#' conn_nsim()
conn_nsim <- function(){
  res <-sql_conn_common(db_name = 'nsim');
  return(res)
}

#' 将向量变成SQL字段名
#'
#' @param x 向量
#'
#' @return 字段名
#' @export
#'
#' @examples
#' vector_as_sql_fieldNames();
vector_as_sql_fieldNames <- function(x) {
  res <-paste(' ',x,' ',collapse = ',');
  return(res)
}

#' 获取表的字段名向量
#'
#' @param table_name 表名
#' @param id_var 内码字段名
#' @param res_type 返回字段类型vector or sql
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_filedNames();
nsim_fieldNames <- function(table_name='test2',id_var=NULL,res_type='vector'){
  conn <- conn_nsim();
  sql_str <- paste("select top 1  * from ",table_name," ;",sep="");
  data <- sql_select(conn,sql_str);
  res <-names(data);
  if(is.null(id_var)){
    res <- res
  }else{
    logi <- ! (res %in% id_var);
    res <- res[logi]

  }
  if (res_type == 'vector'){
    res <- res
  } else if (res_type == 'sql') {
    res <-vector_as_sql_fieldNames(res);
  }else{
    res <-paste(res,collapse = ',');
  }
  return(res);
}
#' 从数据库中读取数据
#'
#' @param table_name  表名称
#' @param id_var 内码字段名
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_read();
nsim_read <- function(table_name = 'test2',id_var=NULL){
  conn <- conn_nsim();
  fieldNames <- nsim_fieldNames(table_name,id_var,'sql');
  sql_str <- paste("select  ",fieldNames," from ",table_name," ;",sep="");
  res <- sql_select(conn,sql_str);
  ncount <- nrow(res);
  if (ncount >0){
    res <- res
  }else{
    res <- NULL
  }
  return(res)
}



#' 读取表的内码最大值
#'
#' @param table_name  表名
#' @param id_var 内码字段名
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_max_id();
nsim_max_id <- function(table_name='test2',id_var='FInterId'){
  conn <- conn_nsim();
  sql_str <- paste("select max(",id_var,") from ",table_name," ; ",sep="");
  res <- sql_select(conn,sql_str);
  res <- res[1,1];
  if(is.null(res)){
    res <-0
  }else{
    res<- as.numeric(res)
  }
  return(res)
}

#' 将相同结构的数据写入到数据库中
#'
#' @param data 数据
#' @param table_name 写入的表名
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_save();
nsim_save <- function(data,table_name='test2',id_var=NULL){
  conn <-conn_nsim();
  data_new <- nsim_read(table_name,id_var);
  all_filedName <- nsim_fieldNames(table_name);
  if(is.null(data_new)){
    data_add <-data;
  }else{
    data_add <-tsdo::df_setdiff(data,data_new);
  }
  count <- nrow(data_add);
  if (count == 0 ){
    #没有数据，不需要处理
    res <- FALSE
  }else{
    #数据处理
    #处理是否区分id部分
    if(is.null(id_var)){
      data_add <- data_add;

    }else{
      #not null
      max_id <- nsim_max_id(table_name,id_var);
      data_add[ ,id_var] <- 1:count + max_id;
      data_add <- data_add[ ,all_filedName];
    }

    db_writeTable(conn,table_name,r_object = data_add,append = T)
    res <- TRUE;
  }

  return(res);
}
