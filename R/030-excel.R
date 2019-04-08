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
