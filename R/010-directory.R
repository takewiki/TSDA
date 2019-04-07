#' 显示目录下所有文件并打印出来，每个文件换行
#'
#' @param dir_path 目录路径
#'
#' @return 返回值
#' @export
#'
#' @examples print_dir();
print_dir <- function(dir_path) {
  cat(paste(dir(dir_path),collapse = '\n'));
}

#' 获取某个文件夹的所有文件名
#'
#' @param dir_path 文件夹
#'
#' @return 返回值
#' @export
#'
#' @examples dir_files();
dir_files <- function(dir_path){
  res <-dir(dir_path);
  class(res) <- 'dir_files'
  return(res);
}

#' 打印dir_files文件
#'
#' @param object  dir_files类型的对象
#'
#' @return 返回值
#' @export
#'
#' @examples print();
print.dir_files <- function(object){
  object <- as.character(object);
  cat(paste(object,collapse = '\n'));

}

#' 查看包中R文件中所有文件
#'
#' @return 返回值
#' @export
#'
#' @examples R_files()
R_files <- function(){
  res <-dir_files('./R')
  return(res)
}
