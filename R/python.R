#' 针对python环境进行设置
#'
#' @return 返回
#' @import reticulate
#' @export
#'
#' @examples
#' set_py()
set_py <- function() {
  #不再使用连接的方式
  #使用虚拟环境更容易对python包进行维护
  use_virtualenv('/opt/my_env',required = TRUE)
  res <- TRUE
  return(res)

}
