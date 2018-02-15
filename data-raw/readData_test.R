library(tsda);
file <-'./data-raw/acct_revenue_structure.xlsx';
class(file) <-'excel';
rs <- readData(file);
rs;
class(rs);
