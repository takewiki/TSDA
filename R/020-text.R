#' 将向量写入文件
#'
#' @param x  向量
#' @param file  文本
#'
#' @return 返回值
#' @export
#'
#' @examples
#' write.txt();
write.txt <- function(x,file)
{
  cat(x,file=file,append = T,sep="\n");
}
