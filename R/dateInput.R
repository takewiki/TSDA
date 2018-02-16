#' @import lubridate
#' @export
ymd <- ymd;
#' @import lubridate
#' @export
yyyymmdd <-function (x,sep='-')
{
  if (sep == '0' | sep =='n' | sep =='N' )
  {
    res <- ymd(x);
  }else if (sep =='-'){
    res <- as.Date(x);
  }else if (sep =='.'){
    res <- as.Date(x,format='%Y.%m.%d');
  }else if(sep == '/'){
    res <- as.Date(x,format='%Y/%m/%d');
  }else{
    warning('请设置正确的日期格式，并且不允许使用\\');
  }

}

#' @import lubridate
#' @export
#' @examples
#' mdy("4/1/17")
#' mmddyyyy('01-14-2018');
#' (mmddyyyy('04-09-2018','-'));
#' (mmddyyyy('04.09.2018','.'));
#' (mmddyyyy('04/09/2018','/'));
 mmddyyyy <-function(x,sep='-'){
  arg_year <-'%Y';
  arg_month <-'%m';
  arg_day <-'%d';
  format <-paste(arg_month,sep,arg_day,sep,arg_year,sep='');
  res <- as.Date(x,format=format);
}
#' 将输入字符为ddmmyyyy形式转化为标准的Date
#' @param x 输入的向量
#'
#' @param sep 分隔符
#'
#' @import lubridate
#' @export
#' @example
#' ddmmyyyy("14/10/1979");
 ddmmyyyy <-function(x,sep='-')
 {
   arg_year <-'%Y';
   arg_month <-'%m';
   arg_day <-'%d';
   format <-paste(arg_day,sep,arg_month,sep,arg_year,sep='');
   res <- as.Date(x,format=format);
 }

#' 获取年份，从lubridate上获取过来
#' @export
#' @import lubridate
year <- year;

#' 针对年份进行赋值
#' @export
#' @import lubridate
"year<-" <- `year<-`;


#'获取月份
#' @export
#' @import lubridate
#' @example month(Sys.Date());
month <- month;

#'设置月份
#' @export
#' @import lubridate
#' @example month(Sys.Date()) <-2012;
"month<-" <- `month<-`

#'获取日期
#' @export
day <- lubridate::day;

#'设置日期
#' @export
"day<-" <- lubridate::`day<-`













