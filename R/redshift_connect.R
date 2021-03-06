#' Connect to an FT Redshift cluster
#'
#' Creates a Redshift connection object.
#'
#' @param cluster_name The Redshift cluster you wish to connect to. Can be one
#'   of "prod", "int" or "int2".
#' @param username Your Redshift username
#' @param password Your Redshift password
#'
#' @return A Redshift connection object.
#' @export
#'
#' @examples
#' \dontrun{
#' ft_redshift_connection <- redshift_connection(
#'   cluster_name = "prod",
#'   rstudioapi::askForPassword("Database user"),
#'   rstudioapi::askForPassword("Database password")
#'  )
#' }
redshift_connection <- function(cluster_name, username, password){
  driver <- ftRtools:::redshift_driver()
  url <- ftRtools:::connect_url(cluster_name, username, password)
  RJDBC::dbConnect(driver, url)
}

select_cluster <- function(cluster_name = "int"){
  cluster_name <- tolower(cluster_name)
  if(length(cluster_name) != 1) stop("Invalid input: length > 1")
  if(!cluster_name %in% c("int","int2","prod")) stop("Cluster name not recognised")
  base::switch(cluster_name,
         int = "redshift-dev.dw.in.ft.com:5439/int",
         int2 = "ft-dw-dev-2.cdujhbzm5hjg.eu-west-1.redshift.amazonaws.com:5439/int",
         prod = "ft-dw-prod.csttwzlr0uam.eu-west-1.redshift.amazonaws.com:5439/prod")
}


connect_url <- function(cluster_name, username, password){
  if(!(length(username) == 1 & length(password) == 1)) stop("Invalid credentials")
  if(is.na(username) | is.na(password)) stop("Redshift credentials missing")
  if(!(is.character(username) & is.character(password))) stop("Invalid credentials")
  host <- ftRtools:::select_cluster(cluster_name)
  base::paste0("jdbc:redshift://",
         host,
         "?user=",
         username,
         "&password=",
         password,
         "&ssl=true&sslfactory=com.amazon.redshift.ssl.NonValidatingFactory")
}
