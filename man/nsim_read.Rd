% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/040A-sqlserver_nsim.R
\name{nsim_read}
\alias{nsim_read}
\title{从数据库中读取数据}
\usage{
nsim_read(table_name = "test2", id_var = NULL, field_vars = NULL)
}
\arguments{
\item{table_name}{表名称}

\item{id_var}{内码字段名}

\item{field_vars}{指定需要查询的字段列表}
}
\value{
返回值
}
\description{
从数据库中读取数据
}
\examples{
nsim_read();
}
