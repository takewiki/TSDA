#' 定义readData的泛型
#'
#' @param file 文件名同时指定类别
#'
#' @return 数据框
#' @export
#' @include excel.R
#' @examples
#' readData('fileExcel')
readData <- function (file)
{
  UseMethod('readData');
}
#' 读取Excel文件
#'
#' @param file 文件名，class=excel.
#' @import readxl
#' @return data.frame.
#' @export
#'
#' @examples
#' readData(fileExcel);
readData.excel <- function (file)
{
  dataset <- read_excel(file)
  dataset <- as.data.frame(dataset);
  return (dataset)
}

#' 读取csv数据
#'
#' @param file 文件名,类型为csv的文件
#'
#' @return 返回数据框
#' @export
#' @import readr
#' @examples
#' readData(filecsv);
readData.csv <- function (file)
{
  # library(readr)
  dataset <- read_csv(file)
  dataset <- as.data.frame(dataset);
  return(dataset);
}
#' 读取spss数据
#'
#' @param file 文件为class =spss
#' @import haven
#' @return 返回数据框
#' @export
#'
#' @examples
#' readData(fileSpss);
readData.spss <- function(file)
{
  #library(haven)
  dataset <- read_sav(file)
  dataset <- as.data.frame(dataset);
  return(dataset);
}
#' 读取sas数据
#'
#' @param file 数据源，class=sas
#'
#' @return 返回数据框
#' @export
#'
#' @examples
#' readData(fileSAS);
readData.sas <- function (file)
{
  #library(haven)
  dataset <- read_sas(file);
  dataset <-as.data.frame(dataset);
  return(dataset);
}

#' 读取stata数据
#'
#' @param file 数据源为stata
#' @import haven
#' @return 返回数据框
#' @export
#'
#' @examples
#' readData(fileStata);
readData.stata <- function (file)
{
  # library(haven)
  dataset <- read_stata(file)
  dataset <- as.data.frame(dataset);
  return(dataset);
}




