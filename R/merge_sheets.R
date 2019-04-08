#' 合并所有Excel
#'
#' @param file Excel文件名
#'
#' @return 返回值
#' @import readxl
#' @export
#'
#' @examples merge_sheets(file);
merge_sheets <- function (file_name){
  library(readxl)
  # get sheet name set.
  sheet_set <- excel_sheets(file_name);
  #读取所有Excel 数据
  res <- lapply(sheet_set,function(sheet){
    bb <-read_excel(file_name,sheet);
    bb <- as.data.frame(bb);
    return(bb);
  })
  #设置相应的列表为原始的名称
  names(res) <- sheet_set;
  #获取每一页的字段名
 field_names <-lapply(res,function(page){
    names(page)
  })

  #判断是否来源于相同表结构
  uniform_page <-length(unique(field_names));
  sheet_count <-length(sheet_set);
  if (uniform_page ==1 && sheet_count >1){
    res <- do.call("rbind",res);
    names(res) <- field_names[[1]];
  }
  return(res);
}
