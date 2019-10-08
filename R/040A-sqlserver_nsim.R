#1. 配置nsim系统数据-----
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

# 2.辅助函数--------
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
#' 处理返回类型问题
#'
#' @param x  原始数据
#' @param res_type 返回值类型
#'
#' @return 返回值
#' @export
#'
#' @examples
#' deal_res_type();
deal_res_type <- function(x,res_type='vector'){
  if (res_type == 'vector'){
    res <- x;
  }else if(res_type == 'sql'){
    res <- vector_as_sql_fieldNames(x)
  }else if (res_type == 'list'){
    res <- tsdo::vect_as_list(x)
  }else{
    res <- x;
  }
  return(res);
}
# 3.表级操作区-------
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
  }else if(is.na(res)){
    #fix the na error
    res <-0
  }else{
    res<- as.numeric(res)
  }
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
#' @param field_vars 指定需要查询的字段列表
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_read();
nsim_read <- function(table_name = 'test2',id_var=NULL,field_vars=NULL){
  conn <- conn_nsim();
  if(is.null(field_vars)){
    fieldNames <- nsim_fieldNames(table_name,id_var,'sql');
  }else{
    fieldNames <- vector_as_sql_fieldNames(field_vars);
  }

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


#4.字段列表区------
# 4.01 通用字段---------
#' 读取表中的字段
#'
#' @param table_name 表名
#' @param field_name 字段名
#' @param res_type 返回值类型
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_read_byField();
nsim_read_byField <- function(table_name='test2',field_name='FName',res_type='vector'){
  res <-nsim_read(table_name ,field_vars = field_name)
  res <- res[ ,1,drop=TRUE];
  res <- as.character(res);
  # print(res);
  res <-deal_res_type(res,res_type);
  return(res)

}
#4.02 品牌字段处理区域-------
#' 处理品牌字段信息
#'
#' @param lang 返回语言格式
#' @param res_type 返回字段格式
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_brand_fieldNames()
nsim_brand_fieldNames <-function(lang='en',res_type='vector'){
  if(lang == 'en'){
    res <-nsim_fieldNames('brand')
  }else{
    res<-c('品牌内码','品牌代码','品牌名称')

  }
  res <- deal_res_type(res,res_type);
  return(res)
}



#' 获取字段名
#'
#' @param res_type 返回字段类型
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_brand_FName();
#' nsim_brand_FName();
#' nsim_brand_FName('list');
nsim_brand_FName <- function(res_type='vector'){
  res <-nsim_read_byField('brand','FName',res_type)
  return(res)

}

#' 读取品牌中的数据类型
#'
#' @param res_type 返回值类型
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_brand_FNumber();
#' nsim_brand_FNumber('list');
nsim_brand_FNumber <- function(res_type='vector'){
  res <-nsim_read_byField('brand','FNumber',res_type)
  return(res)
}

#4.03语料数据处理-------
#' 处理语料的字段信息
#'
#' @param lang 语言选择
#' @param res_type 返回类型选择
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_im_raw_record_fieldNames();
nsim_im_raw_record_fieldNames <-function(lang='en',res_type='vector'){
  if (lang == 'en'){
    res <- nsim_fieldNames('im_raw_record')
  }else{
    res<-c('语料内码','用户ID','日期时间','日志内容','日期','时间','品牌',
           '是否需要合并','合并内码')
  }
  res <- deal_res_type(res,res_type);
  return(res);
}

#' 处理原始语料的日志字段
#'
#' @param res_type 返回值类型
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_im_raw_record_FLog();
nsim_im_raw_record_FLog <- function(res_type='vector'){
  res <-nsim_read_byField('im_raw_record','FLog',res_type)
  return(res)
}


#' 增加通用的品牌信息查询
#'
#' @param table_name  表名
#' @param field_name  字段名
#' @param brand 品牌
#' @param unique 是否唯一
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_brand_table_query();
nsim_brand_table_query <- function(table_name='qalist_raw',
                                   field_name='FQuestionText',
                                   brand = 'JBLH',
                                   unique = FALSE){
  brand <- paste("FBrand = '",brand,"'",sep="");
  res <- nsim_read_where(table_name,field_vars = field_name,where = brand);
  res <- res[ ,1,drop=TRUE];
  if (unique == TRUE){
    res <- unique(res)
  }
  return(res)

}
#' 提取品牌的文本信息
#'
#' @param brand 品牌
#' @param unique 是否唯一
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_qalist_FQuestionText();
nsim_qalist_FQuestionText <- function(brand = 'JBLH',unique=FALSE){
  res <- nsim_brand_table_query(table_name = 'qalist_raw',
                                field_name = 'FQuestionText',
                                brand,unique

                                )
  return(res)

}

#' 处理QA中的answer问题
#'
#' @param brand 品牌
#' @param unique 唯一性
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_qalist_FAnswerText();
nsim_qalist_FAnswerText <- function(brand = 'JBLH',unique=FALSE){
  res <- nsim_brand_table_query(table_name = 'qalist_raw',
                                field_name = 'FAnswerText',
                                brand,unique

  )
  return(res)

}

# 5.0 行级数据处理--------
#' 处理语句读取问题
#'
#' @param table_name 表名
#' @param id_var 内码
#' @param field_vars  字段名
#' @param where 条件
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_read_where();
#' nsim_read_where('qalist_raw',field_vars = 'FQuestionText',where = "FBrand = 'JBLH'");
nsim_read_where <- function(table_name = 'test2',
                            id_var=NULL,
                            field_vars=NULL,
                            where=' fid =1'){
  conn <- conn_nsim();
  if(is.null(field_vars)){
    fieldNames <- nsim_fieldNames(table_name,id_var,'sql');
  }else{
    fieldNames <- vector_as_sql_fieldNames(field_vars);
  }

  sql_str <- paste("select  ",fieldNames," from ",table_name," where ",where," ;",sep="");
  res <- sql_select(conn,sql_str);
  ncount <- nrow(res);
  if (ncount >0){
    res <- res
  }else{
    res <- NULL
  }
  return(res)
}


# 6.0 统计数据处理-------

