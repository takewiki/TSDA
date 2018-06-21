
#' 将数据写到到某个系统默认为R
#'
#' @param data 系统中R数据对照
#' @param to   输入的文件系统，默认为R
#' @param overwrite  是否覆盖原有的数据，默认为否
#'
#' @return  不用于返回
#' @export
#' @import devtools
#' @examples writeData(data,'R',T);

writeData<- function (data,to='R',overwrite=F)
{
  if (to == 'R')
  {
    use_data(data,overwrite = overwrite);
  } else{
    stop('请填写适用的数据');
  }

};
#' 将数据写入到Excel
#'
#' @param data 数据框
#' @param fileName 目标文件名
#' @param sheetName 页签名
#' @import openxlsx
#' @return 返顺值
#' @export
#'
#' @examples writeData2Excel(letters,'text.xlsx','sheet1');
writeData2Excel <- function (data,fileName,sheetName='sheet1')
{
   write.xlsx(x = data,file = fileName,sheetName=sheetName);
};
