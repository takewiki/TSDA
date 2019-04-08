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

read_excelBooks <- function(variables) {

}
