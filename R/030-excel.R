
#' 读取Excel数据到数据框
#'
#' @param file 数据文件名
#'
#' @return 返回值
#' @import readxl
#' @export
#'
#' @examples
#' readExcelDf('.data-raw/txt.xlsx');
#' 读取excel数据
readExcelDf <- function(file) {

  res<- read_excel(file);
  res <- as.data.frame(res,stringsAsFactors=FALSE);
  return(res);
}

#' 读取excel的默认第一个页签
#'
#' @param excel_file 文件名
#'
#' @return 返回值
#' @import readxl
#' @export
#'
#' @examples
#' read_excelSheet('./data-raw/gh_llb.xlsx')
read_excelSheet <- function(excel_file) {

  #library(readxl)
  res<- read_excel(excel_file)
  res <- as.data.frame(res);
  return(res);

}


read_excelSheets <- function(variables) {

}

read_excelBook <- function(variables) {

}

#' 将多个相同结构的EXCEL合并出一个数据
#'
#' @param dir_files excel_files所在的目录
#'
#' @return 返回值
#' @include 010-directory.R
#' @export
#'
#' @examples
#' read_excelBooks('./data-raw/ghdata')
read_excelBooks <- function(dir_files) {
  files <- dir(dir_files)
  files <-paste(dir_files,files,sep="/");
  #get files
  res <-lapply(files, read_excelSheet)
  #get names
  field_names <-lapply(res,names)
  #sheet name
  sheet_header <- field_names[[1]];
  res <- do.call("rbind",res);
  names(res) <- sheet_header;
  return(res);
}

#' 广汇数据处理后
#'
#' @param gh_download_dir 文件目录
#'
#' @return 返回值
#' @export
#'
#' @examples read_excel_GH();
read_excel_GH <-function(gh_download_dir='./data-raw/test'){

  res <-read_excelBooks(dir_files = gh_download_dir);
  header_name <-names(res);
  header_selected <- header_name[c(2,4)];
  res <-res[,header_selected];
 #进行求和运算
  res2 <-tapply(as.integer(res[,2]),res[,1],sum);
  res_name <-names(res2);
  res_count <-as.vector(res2);
  res3 <- data.frame(res_name,res_count,stringsAsFactors = F);
  names(res3) <- c('fname','fuvcount')
  #View(res3)
  #openxlsx::write.xlsx(res3,paste('./广汇UV数据处理后_',Sys.Date(),'.xlsx',sep=''))
  return(res3)

}


# 从Excel中读取数据----
#' 从Excel中读取数据
#'
#' @param file 文件名
#' @param sheet sheet
#'
#' @return 返回值
#' @import readxl
#' @export
#'
#' @examples getDataFromExcel
getDataFromExcel <- function(file,sheet=1)
{
  res <- read_excel(file,sheet)
  return(res)
};

# 将R对象写入到Excel文件中-----
#' 将R对象写入到Excel文件中
#'
#' @param data R对象
#' @param fileName  文件名
#' @param sheetName  页签名
#'
#' @return 返回值
#' @import openxlsx
#' @export
#'
#' @examples writeDataToExcel();
writeDataToExcel <- function (data,fileName,sheetName)
{

  #write.xlsx(x = data,file = fileName,sheetName = sheetName,row.names = FALSE,append = T,showNA = T);
  write.xlsx(x = data,file = fileName,sheetName=sheetName);

}




#' 读取excel页答名称
#'
#' @param file 文件
#'
#' @return 返回值
#' @export
#'
#' @examples
#' execl_getSheetNames()
excel_getSheetNames <- function(file) {
  res <-readxl::excel_sheets(file)
  return(res)

}
