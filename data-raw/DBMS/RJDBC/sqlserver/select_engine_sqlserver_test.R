library(tsda);

#test 01 只显示字段列表--------
# select  FVOUCHERGROUPNO,FYEAR,FPERIOD,FBILLNO from T_GL_VOUCHER

fieldName_vec_simple <-c('FVOUCHERGROUPNO','FYEAR','FPERIOD','FBILLNO');
table_name ='T_GL_VOUCHER';


simpleFieldCombiner_sqlserver(fieldName_vec_simple);

test01 <- select_engine_sqlserver(fieldName_vec_simple =fieldName_vec_simple ,
                                  table_name = table_name
                                    );
test01;

#test 02 显示字段列表及别名--------
# select    FVOUCHERGROUPNO as 凭证字号  ,  FYEAR as 会计年度  ,  FPERIOD as 会计期间  ,
# FBILLNO as 凭证号      from  T_GL_VOUCHER

fieldName_vec_simple <-c('FVOUCHERGROUPNO','FYEAR','FPERIOD','FBILLNO');
table_name ='T_GL_VOUCHER';
fieldName_caption_simple <-c('凭证字号','会计年度','会计期间','凭证号');

test02 <- select_engine_sqlserver(fieldName_vec_simple =fieldName_vec_simple ,
                                  fieldName_caption_simple = fieldName_caption_simple,
                                  table_name = table_name
);
test02;


#test 03 显示字段列表及别名,显示行过滤--------
# select    FVOUCHERGROUPNO as 凭证字号  ,  FYEAR as 会计年度  ,
# FPERIOD as 会计期间  ,  FBILLNO as 凭证号      from  T_GL_VOUCHER
# where   FDATE = '2018-10-09' and
# FVOUCHERGROUPID = 1 and  FACCOUNTBOOKID = 100032
fieldName_vec_simple <-c('FVOUCHERGROUPNO','FYEAR','FPERIOD','FBILLNO');
table_name ='T_GL_VOUCHER';
fieldName_caption_simple <-c('凭证字号','会计年度','会计期间','凭证号');
fieldName_vec_where = c('FDATE','FVOUCHERGROUPID','FACCOUNTBOOKID');
comparerSig_vec_where = c('=','=','=');
filterValue_vec_where = c("'2018-10-09'","1","100032");
comboCondition_logi_vec_where = c('and','and','and');
test03 <- select_engine_sqlserver(fieldName_vec_simple =fieldName_vec_simple ,
                                  fieldName_vec_where = fieldName_vec_where,
                                  comparerSig_vec_where = comparerSig_vec_where,
                                  filterValue_vec_where = filterValue_vec_where,
                                  comboCondition_logi_vec_where =comboCondition_logi_vec_where ,
                                  fieldName_caption_simple = fieldName_caption_simple,
                                  table_name = table_name
);
test03;



#test 04 显示字段列表及别名,显示行过滤,字段排序--------
# select    FVOUCHERGROUPNO as 凭证字号  ,
# FYEAR as 会计年度  ,  FPERIOD as 会计期间  ,
# FBILLNO as 凭证号      from  T_GL_VOUCHER
# where   FDATE = '2018-10-09' and  FVOUCHERGROUPID = 1
# and  FACCOUNTBOOKID = 100032
# order by  FVOUCHERGROUPNO asc , FBILLNO desc
fieldName_vec_simple <-c('FVOUCHERGROUPNO','FYEAR','FPERIOD','FBILLNO');
table_name ='T_GL_VOUCHER';
fieldName_caption_simple <-c('凭证字号','会计年度','会计期间','凭证号');
fieldName_vec_where = c('FDATE','FVOUCHERGROUPID','FACCOUNTBOOKID');
comparerSig_vec_where = c('=','=','=');
filterValue_vec_where = c("'2018-10-09'","1","100032");
comboCondition_logi_vec_where = c('and','and','and');
fieldName_vec_orderBy = c('FVOUCHERGROUPNO','FBILLNO')
asc_vec_orderBy = c(T,F)
test04 <- select_engine_sqlserver(fieldName_vec_simple =fieldName_vec_simple ,
                                  fieldName_vec_orderBy = fieldName_vec_orderBy,
                                  asc_vec_orderBy = asc_vec_orderBy,
                                  fieldName_vec_where = fieldName_vec_where,
                                  comparerSig_vec_where = comparerSig_vec_where,
                                  filterValue_vec_where = filterValue_vec_where,
                                  comboCondition_logi_vec_where =comboCondition_logi_vec_where ,
                                  fieldName_caption_simple = fieldName_caption_simple,
                                  table_name = table_name
);
test04;



select FVOUCHERGROUPID,count(FBILLNO) as bill_count,sum(FPRINTTIMES)
as sum_print from T_GL_VOUCHER
where FVOUCHERGROUPID <>1
group by FVOUCHERGROUPID
order by FVOUCHERGROUPID desc

test05 <-select_engine_sqlserver(fieldName_vec_simple = c('FVOUCHERGROUPID'),
                                 fieldName_vec_where = 'FVOUCHERGROUPID',
                                 comparerSig_vec_where = '<>',
                                 filterValue_vec_where = '1',
                                 comboCondition_logi_vec_where = 'and',
                                 fieldName_vec_groupBy = 'FVOUCHERGROUPID',
                                 fieldName_vec_orderBy = 'FVOUCHERGROUPID',
                                 asc_vec_orderBy = F,
                                 fun_vec_aggr = c('count','sum'),
                                 fieldName_vec_aggr = c("FBILLNO","FPRINTTIMES"),
                                 fieldName_caption_aggr =c("bill_count","sum_print"),
                                 table_name = 'T_GL_VOUCHER'

                                )
test05;
