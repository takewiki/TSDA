# elect * from T_GL_VOUCHER
# where FYEAR=2018 and FDATE>='2018-10-02'



#

library(tsda);
simpleFieldCombiner(letters,LETTERS);
simpleFieldCombiner(c('fnumber','fname'),c('物料代码','物料名称'));



# select FVOUCHERGROUPID,COUNT(1)  AS COUN2 from T_GL_VOUCHER
# GROUP BY FVOUCHERGROUPID

aggregateFieldCombiner(c('aa','bb'),c('物料数量','物料金额'),c('sum','sum'));
aggregateFieldCombiner(c('aa','bb'),aggr_fun_vec = c('sum','sum'));


groupByCombiner_sqlserver(LETTERS);




FYEAR=2018 and FDATE>='2018-10-02'



is.null(whereStatementCombiner());
fieldName_vec <-c('FYEAR','FDATE');
comparerSig_vec <-c('=','>=');
filterValue_vec <-c("2018","'2018-10-02'");
comboCondition_logi_vec <-c('and','and');
whereStatementCombiner(fieldName_vec,comparerSig_vec,filterValue_vec,comboCondition_logi_vec);


# select FVOUCHERGROUPID as 凭证好 ,FVOUCHERGROUPNO as 评选哼 from T_GL_VOUCHER
# where FYEAR=2018 and FDATE>='2018-10-02'
# order by FDATE asc,FVOUCHERGROUPNO desc


orderByCombiner();
orderByCombiner(fieldName_vec = letters,asc_vec = rep(T,26));


