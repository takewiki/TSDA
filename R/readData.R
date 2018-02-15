
#' 读取数据的通知格式函数
#'
#' @param foramt 选择excel等
#' @param file   输入文件名
#' @return  返回结果
#' @export
#' @import readxl
#' @examples readData('./data/test.xls','excel','readxl');
readData <- function (file='',format='excel',pkg='readxl')
{

  if (format == 'excel' && pkg == 'readxl' && file != '')
  {
    rs<- read_excel(file);
  }else{
    rs <-'';
    stop("请输入正确的文件格式",call. = F);
  }
 return (rs);
};

