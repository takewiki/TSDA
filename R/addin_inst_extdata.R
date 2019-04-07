#' 插入外部数据
#'
#' @return 返回值
#' @export
#'
#' @examples addin_inst_extdata();Name: 注册Rstudio插件
addin_inst_extdata <- function(){
  if(!dir.exists("./inst")){
    dir.create("./inst");
  }
  if(!dir.exists("./inst/extdata")){
    dir.create("./inst/extdata");
  }
}

