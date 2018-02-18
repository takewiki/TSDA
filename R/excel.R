#' 将字符串汪加相应的class标识为excel
#'
#' @param file 文件名，符合R语言规范
#'
#' @return 返回excel类的文件名
#' @export
#'
#' @examples excel('file');
excel <- function (file)
{
  if ( class(file) == 'character'){
    class(file) <- 'excel'
  }else if (class(file) == 'excel')
  {
    file
  }
  return(file)
}
