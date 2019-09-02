library(RJDBC)
drv <- JDBC("com.mysql.jdbc.Driver","/usr/share/java/mysql-connector-java.jar",identifier.quote="`")
con <- dbConnect(drv, "jdbc:mysql://localhost:3306/rdkc", "root", "Hoolilay889@")
brand <- dbGetQuery(con,' select user_name from tsuser;')


library(RJDBC)
drv <- JDBC("com.mysql.cj.jdbc.Driver","/opt/jdbc/mysql/mysql-connector-java-8.0.16.jar",identifier.quote="`")
con <- dbConnect(drv, "jdbc:mysql://localhost:3306/rdkc", "root", "Hoolilay889@")
brand <- dbGetQuery(con,' select user_name from tsuser;')




library(RJDBC)
drv <- JDBC("com.mysql.jdbc.Driver","/opt/jdbc/mysql/mysql-connector-java-8.0.16.jar",identifier.quote="`")
con <- dbConnect(drv, "jdbc:mysql://118.190.205.117:3306/sendplan?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC", "admin", "1qaz2wsx")
brand <- dbGetQuery(con,' select * from brand;')


library(RJDBC)

con <- mysql_conn_pms();
brand <- dbGetQuery(con,' select * from brand;')




