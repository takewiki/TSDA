#' 加载单个库文件
#'
#' @param lib 文件名
#'
#' @return 返回值
#'
#' @examples singleLoadLib('reshape2');
singleLoadLib <- function(lib){
  if(!require(lib,character.only = TRUE)){
    install.packages(lib);
  }
  #require(lib,character.only = T);
  library(lib,character.only = T);
}

#' 批量加载库文件
#'
#' @param libs  所有的库文件名
#'
#' @return 返回值
#' @export
#'
#' @examples libraryEx(letters);
libraryEx <- function(libs){

res <- lapply(libs,singleLoadLib);

if (length(res) >= 1){
  return(TRUE)
}else{
  return(FALSE)
}

}






