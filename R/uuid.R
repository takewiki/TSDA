#' 读取硬件的uuid
#'
#' @return 返回值
#' @export
#'
#' @examples
#' uuid_readId()
uuid_readId <- function() {
  bb <- system('blkid',intern = TRUE)
  res <-tsdo::right(tsdo::left(bb[2],53),36)
  return(res)


}
