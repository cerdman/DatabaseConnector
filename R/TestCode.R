
# Temporary placeholder for testing code until we figure out unit testing with DB and filesys dependencies
localTestCode <- function(){
  #library(DatabaseConnector)
  pw <- ""
  
  #Test MySQL:
  connectionDetails <- createConnectionDetails(dbms="mysql", server="localhost",user="root",password=pw,schema="fake_data")
  conn <- connect(connectionDetails)
  dbGetQuery(conn,"SELECT COUNT(*) FROM person")
  dbDisconnect(conn)
  
  #Test PDW with integrated security:
  connectionDetails <- createConnectionDetails(dbms="pdw", server="JRDUSAPSCTL01",port=17001, schema="CDM_Truven_MDCR")
  conn <- connect(connectionDetails)
  querySql(conn,"SELECT COUNT(*) FROM person")
  dbDisconnect(conn)
  
  #Test PDW without integrated security:
  connectionDetails <- createConnectionDetails(dbms="pdw", server="JRDUSAPSCTL01",port=17001, schema="CDM_Truven_MDCR", user = "hix_writer", password=pw)
  conn <- connect(connectionDetails)
  querySql(conn,"SELECT COUNT(*) FROM person")
  dbDisconnect(conn)
 
  #Test SQL Server without integrated security:
  connectionDetails <- createConnectionDetails(dbms="sql server", server="RNDUSRDHIT06.jnj.com",user="eu/mschuemi",password=pw,schema="cdm_hcup",port=1433)
  conn <- connect(connectionDetails)
  querySql(conn,"SELECT COUNT(*) FROM person")
  x <- dbGetQuery.ffdf(conn,"SELECT TOP 1000000 * FROM person")
  dbDisconnect(conn)
  
  #Test SQL Server with integrated security:
  connectionDetails <- createConnectionDetails(dbms="sql server", server="RNDUSRDHIT06.jnj.com",schema="cdm_hcup")
  conn <- connect(connectionDetails)
  querySql(conn,"SELECT COUNT(*) FROM person")
  dbGetQuery.ffdf(conn,"SELECT TOP 100 * FROM person")
  executeSql(conn,"CREATE TABLE #temp (x int)")
  querySql(conn,"SELECT COUNT(*) FROM #temp")
  #x <- dbGetQuery.ffdf(conn,"SELECT * FROM person")
  dbDisconnect(conn)
  
  #Test Oracle:
  connectionDetails <- createConnectionDetails(dbms="oracle", server="xe",user="system",password=pw,schema="cdm_truven_ccae_6k")
  conn <- connect(connectionDetails)
  dbGetQuery(conn,"SELECT COUNT(*) FROM person")
  dbDisconnect(conn)
  
  #Test PostgreSQL:
  connectionDetails <- createConnectionDetails(dbms="postgresql", server="localhost/ohdsi",user="postgres",password=pw,schema="cdm4_sim")
  conn <- connect(connectionDetails)
  querySql(conn,"SELECT COUNT(*) FROM person")
  dbDisconnect(conn)
    
  #Test Redshift:
  connectionDetails <- createConnectionDetails(dbms="postgresql", server="localhost/cdm4_sim",user="postgres",password=pw,schema="public")
  conn <- connect(connectionDetails)
  dbGetQuery(conn,"SELECT COUNT(*) FROM person")
  dbDisconnect(conn)
  
  ### Tests for dbInsertTable ###
  day.start <- "1900/01/01"
  day.end <- "2012/12/31"
  dayseq <- seq.Date(as.Date(day.start),as.Date(day.end),by="day")
  makeRandomStrings <- function(n=1, lenght=12) {
    randomString <- c(1:n)                 
    for (i in 1:n)  
      randomString[i] <- paste(sample(c(0:9, letters, LETTERS), lenght, replace=TRUE), collapse="")
    return(randomString)
  }
  data <- data.frame(start_date = dayseq, person_id = as.integer(round(runif(length(dayseq),1,10000000))), value = runif(length(dayseq)), id = makeRandomStrings(length(dayseq)))
  str(data)
  tableName <- "#temp"
  connectionDetails <- createConnectionDetails(dbms="sql server", server="RNDUSRDHIT06.jnj.com",schema="cdm_hcup")  
  connection <- connect(connectionDetails)
  dbInsertTable(connection, tableName, data, dropTableIfExists = TRUE)
  
  d <- querySql(connection, "SELECT * FROM #temp")
  d <- querySql.ffdf(connection, "SELECT * FROM #temp")
  
  library(ffbase)
  data <- as.ffdf(data)

  dbDisconnect(connection)
}