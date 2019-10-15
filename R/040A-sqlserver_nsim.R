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
#' 处理表查询的问题
#'
#' @param table_name 表名称
#' @param field_name 字段名
#' @param brand 品牌
#' @param unique 是否唯一
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_brand_table_query2();
nsim_brand_table_query2 <- function(table_name='qalist_raw',
                                   field_name='FQuestionText',
                                   brand = 'JBLH',
                                   unique = FALSE){
  brand <- paste("FBrand = '",brand,"'",sep="");
  res <- nsim_read_distinct(table_name,field_vars = field_name,where = brand,unique = unique
                              );
  res <- res[ ,1,drop=TRUE];
  #if (unique == TRUE){
  #  res <- unique(res)
  #}
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

#' 处理问题字段2
#'
#' @param brand 品牌
#' @param unique 是否唯一
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_qalist_FQuestionText2();
nsim_qalist_FQuestionText2 <- function(brand = 'JBLH',unique=FALSE){
  res <- nsim_brand_table_query2(table_name = 'qalist_raw',
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
#' 处理回复字段2
#'
#' @param brand 品牌
#' @param unique 是否回复
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_qalist_FAnswerText2();
nsim_qalist_FAnswerText2 <- function(brand = 'JBLH',unique=FALSE){
  res <- nsim_brand_table_query2(table_name = 'qalist_raw',
                                field_name = 'FAnswerText',
                                brand,unique

  )
  return(res)

}


#4.04 问答ID---------

#' 将问题进行ID化处理
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_vw_qalist_id();
nsim_vw_qalist_id <-function(){
  res <- nsim_read('vw_qalist_id');
  res <- res[order(res$FSessionId), ];
  return(res)
}

#4.05处理分词-----

#' 处理词汇查询
#'
#' @param brand 品牌
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_dict();
nsim_dict <- function(brand='JBLH'){
  str_brand <- paste(" FBrand = '",brand,"' ",sep="");
 res <-nsim_read_where('dict',field_vars = c('FWord','FCategory'),
                       where =str_brand )
 return(res)
}

#' 处理到词汇
#'
#' @param brand 品牌
#' @param unique 是否唯一
#'
#' @return 返回值
#' @export
#'
#' @examples
#'  nsim_dict_FWord()
 nsim_dict_FWord <- function(brand = 'JBLH',unique=FALSE){

   res <- nsim_brand_table_query2(table_name = 'dict',
                                  field_name = 'FWord',
                                  brand,unique

   )
   return(res)

 }

#' 读取分词的类别
#'
#' @param brand 品牌
#' @param unique 唯一
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_dict_category();
nsim_dict_category <- function(brand = 'JBLH',unique=TRUE){

  res <- nsim_brand_table_query2(table_name = 'dict',
                                 field_name = 'FCategory',
                                 brand,unique

  )
  return(res)

}

#4.06  问题处理
#' 查询问题及id信息
#'
#' @param brand 品牌
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_ques();
nsim_ques <- function(brand = 'JBLH'){
 conn <- conn_nsim();
 sql <-paste("select FQuestionId,FQuestion from item_question
             where FBrand = '",brand," '
             order by FQuestionId ", sep="")
 res <- sql_select(conn,sql)
  return(res);

}

#' 处理答案的读取问题
#'
#' @param brand  品牌
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_answ();
nsim_answ <-function(brand = 'JBLH'){
  conn <- conn_nsim();
  sql <-paste("select FAnswerId,FAnswer from item_answer
             where FBrand = '",brand," '
             order by FAnswerId ", sep="")
  res <- sql_select(conn,sql)
  return(res);

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



#' 处理查询的唯一性问题
#'
#' @param table_name 表名
#' @param id_var 内码
#' @param field_vars 名称
#' @param where 查询条件
#' @param unique 是否已到
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_read_distinct();
nsim_read_distinct <- function(table_name = 'test2',
                            id_var=NULL,
                            field_vars=NULL,
                            where=' fid =1',
                            unique=FALSE){
  conn <- conn_nsim();
  if(is.null(field_vars)){
    fieldNames <- nsim_fieldNames(table_name,id_var,'sql');
  }else{
    fieldNames <- vector_as_sql_fieldNames(field_vars);
  }
  if (unique == TRUE){
    str_unique <-" distinct "
  }else{
    str_unique <-" "
  }
  sql_str <- paste("select  ",str_unique,fieldNames," from ",table_name," where ",where," ;",sep="");
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

#' 处理问题分类
#'
#' @param brand 品牌
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_ques_seg();
nsim_ques_seg <- function(brand = 'JBLH'){
  library(Rwordseg);
  data <- nsim_dict_FWord();
  Rwordseg::insertWords(data);
  #加入品牌信息
  data_ques <- nsim_ques(brand);
  ques_id <-as.character(data_ques$FQuestionId);
  ques_txt <-data_ques$FQuestion;
  ques_seg <-Rwordseg::segmentCN(ques_txt,nosymbol = T)
  names(ques_seg) <- ques_id;
  seg_count <- length(ques_seg);
  res <- tsdo::list_init(seg_count);
  for ( i in 1:seg_count){
    item <- ques_seg[[i]];
    #每个元素的数量
    item_count <- length(item);
    item_name <- ques_id[i];
    FQuestionId <- rep(item_name,item_count);
    FEntryId <-1:item_count;
    FSegment <- item;
    FNSOwn <- rep(0,item_count);
    item_table <-data.frame(FQuestionId,FEntryId,FSegment,FNSOwn,stringsAsFactors = F)
    res[[i]] <- item_table

  }
  res<-do.call('rbind',res);
  nsim_save(res,'ques_segment');
  #更新标志----
  sql_update(conn_nsim()," update  a set a.FNSOwn = 1  from ques_segment a
inner join dict b
on a.FSegment = b.FWord
")
  #res;
  #

}

#' 处理相应的分组分类数据
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_vw_ques_segment();
nsim_vw_ques_segment <- function(){
  conn <- conn_nsim();
  sql <-"select FQuestionId,FCategory  from  vw_ques_segment
order by FQuestionId,FCategory ;"
  res <- sql_select(conn,sql)
  return(res)
}



#' 处理将数据进行模板化处理
#'
#' @return 返回值
#' @import tsdo
#' @export
#'
#' @examples
#' nsim_ques_tpl_save();
nsim_ques_tpl_save <- function(){
  data <- nsim_vw_ques_segment();
  res <- split(data$FCategory,data$FQuestionId);
  res <- lapply(res, vect_as_long_string)
  res <- unlist(res);
  FQuestionId <-names(res);
  FQuesTpl <-res
  res <- data.frame(FQuestionId,FQuesTpl,stringsAsFactors = F)
  nsim_save(res,'ques_template')

}

#' 处理数据按||合并的问题
#'
#' @param x  向量
#' @param group  分量
#'
#' @return 返回数据框
#' @import tsdo
#' @export
#'
#' @examples
#' nsim_split_combine();
nsim_split_combine <- function(x,group){
  res <-split(x,group);
  res <- lapply(res, vect_as_dbl_equal)
  res <- unlist(res);
  FGroup <-names(res);
  FData <-res
  res <- data.frame(FGroup,FData,stringsAsFactors = F)
  return(res)

}

#' 读取问题模板的计数数据
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_ques_template_count();
nsim_ques_template_count <- function(){
  conn <- conn_nsim();
  sql <-"select FQuesTpl,FQuestionId,FQuesCount from vw_ques_template_count
order by FQuesTpl,FQuesCount desc";
  res <- sql_select(conn,sql);
  return(res)
}


#' 处理答案的标签个数
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_answ_template_count()
nsim_answ_template_count <- function(){
  conn <- conn_nsim();
  sql <-"select FQuesTpl,FAnswerId,FAnswerCount from vw_answ_template_count
order by FQuesTpl,FAnswerCount desc"
  res <- sql_select(conn,sql);
  return(res)
}

#' Title处理数据取TOP1
#'
#' @param data 数据
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_top1();
nsim_top1 <-function(data){
  ncount <-nrow(data);
  data$FStandard <- rep(0,ncount);
  data[1,'FStandard'] <-1;
  return(data)
}

#' 针对问题进行标准化处理
#'
#' @return 返顺值
#' @export
#'
#' @examples
#' nsim_ques_standardize();
nsim_ques_standardize <- function(){
  data <-nsim_ques_template_count();
  res <- split(data,data$FQuesTpl);
  names(res) <-NULL
  #res;
  #head(res,3);

  res2 <-lapply(res,nsim_top1)

  res <- do.call('rbind',res2);
  rownames(res) <-NULL
  res$FQuesCount[is.na(res$FQuesCount)] <-0;
  # View(res);
 # lapply(res, unique);

  nsim_save(res,'ques_standardize');
  #return(res)
}

#' 处理答案标准化
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_answ_standardize();
nsim_answ_standardize <- function(){
  data <-nsim_answ_template_count();
  res <- split(data,data$FQuesTpl);
  names(res) <-NULL
  #res;
  #head(res,3);

  res2 <-lapply(res,nsim_top1)

  res <- do.call('rbind',res2);
  rownames(res) <-NULL
  res$FAnswerCount[is.na(res$FAnswerCount)] <-0;
  # View(res);
  # lapply(res, unique);

  nsim_save(res,'answ_standardize');
  #return(res)
}


#' 处理相类型问题
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_ques_like();
nsim_ques_like <- function(){
  conn <- conn_nsim();
  sql <-"select FQuesTpl,FQuestion from ques_like
order by fquesTpl";
  res <- sql_select(conn,sql);
  res2 <- nsim_split_combine(res$FQuestion,res$FQuesTpl);
  rownames(res2) <-NULL
  names(res2) <-c('FQuesTpl','FQuestion')
 # max(nchar(res$FQuestion))
 # max(nchar(res$FQuesTpl))
  nsim_save(res2,'ques_like_txt')
  #View(res2);
}


#' 处理相似答案
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_answ_like();
nsim_answ_like <- function(){
  conn <- conn_nsim();
  sql <-"select FQuesTpl,FAnswer from answ_like_txt
order by FQuesTpl";
  res <- sql_select(conn,sql);
  res2 <- nsim_split_combine(res$FAnswer,res$FQuesTpl);
  rownames(res2) <-NULL
  names(res2) <-c('FQuesTpl','FAnswer')
  # max(nchar(res$FQuestion))
  # max(nchar(res$FQuesTpl))
  nsim_save(res2,'answ_like_txt2')
  #View(res2);
}

# 创建nsim_version---
#' 创建新的版本
#'
#' @param module 模块
#' @param from 开始
#' @param to 结束
#' @param prefix 前缀
#' @param brand  品牌
#'
#' @return 返顺值
#' @export
#'
#' @examples
#' nsim_version_create();
#' nsim_version_create('nsdict');
#' nsim_version_create('nsbl',1L,10000L);
nsim_version_create <- function(brand='JBLH',module='nsbl',from=1L,to=1000L,prefix='V'){
  # module='nsbl'
  # from=1L
  # to=1000L
  # prefix='V'
  FVersionId <- from:to;
  ncount <- length(FVersionId);
  FVersionTxt <- paste(prefix,FVersionId,sep = "");
  FBrand <- rep(brand,ncount);
  FType <- rep(module,ncount);
  FCurrentVersion<-rep(0L,ncount);
  FVersionNext <- from:to +1L;
  FNextVersion <-paste(prefix,FVersionNext,sep = "");
  res <- data.frame(FVersionId,FVersionTxt,FBrand,FType,FCurrentVersion,FNextVersion,
                    stringsAsFactors = F)
  #View(res)
  #str(res)
  nsim_save(res,'nsim_version');

}

#' 获取品牌模块的版本
#'
#' @param brand 品牌
#' @param module 模块
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_version_getCurrentVersion();
nsim_version_getCurrentVersion<- function(brand='JBLH',module='nsbl'){
  sql <- paste("select FVersionTxt  from nsim_version
  WHERE  FBrand = '",brand,"'  and
  FTYPE='",module,"' and FCurrentVersion=1",sep="")
  conn <- conn_nsim();
  data <- sql_select(conn,sql);
  if(nrow(data) == 0){
    res <-""
  }else{
    res<-data$FVersionTxt[1]
  }
  return(res)


}

#' 获取品牌模块的下一个版本，用于程序处理
#'
#' @param brand 品牌
#' @param module 模块
#'
#' @return 返回值
#' @export
#'
#' @examples
#' nsim_version_getNextVersion();
nsim_version_getNextVersion<- function(brand='JBLH',module='nsbl'){
  sql <- paste("select FNextVersion  from nsim_version
  WHERE  FBrand = '",brand,"'  and
  FTYPE='",module,"' and FCurrentVersion=1",sep="")
  conn <- conn_nsim();
  data <- sql_select(conn,sql);
  if(nrow(data) == 0){
    res <-"V1"
  }else{
    res<-data$FNextVersion[1]
  }
  return(res)


}

#' 设置品牌模块的版本
#'
#' @param brand 品牌
#' @param module 模块
#' @param version 版本
#'
#' @return 无
#' @export
#'
#' @examples
#' nsim_version_setCurrentVersion();
nsim_version_setCurrentVersion<- function(brand='JBLH',module='nsbl',version){
  sql <- paste("update nsim_version set  FCurrentVersion=1
WHERE  FBrand = '",brand,"'  and
FTYPE='",module,"' and FVersionTxt='",version,"'",sep="");
  conn<- conn_nsim();
  sql_update(conn,sql);
  sql2 <- paste("update nsim_version set  FCurrentVersion=0
WHERE  FBrand = '",brand,"'  and
FTYPE='",module,"' and FVersionTxt<>'",version,"'",sep="");
  sql_update(conn,sql2);

}

