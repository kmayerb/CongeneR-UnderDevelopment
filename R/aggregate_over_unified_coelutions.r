#' aggregate_over_unified_coelutions
#'
#' transforms original coelution into a new co-elution based on a unified_coleultion object
#'
#' @param coelution
#' @param unified_coelution
#'
#' @return
#' @export
#'
#' @examples
aggregate_over_unified_coelutions <- function(coelution, unified_coeluttion){

  ifelse(check_user_provided_colution_object(coelution),
         TRUE,
         stop(deparse(substitute(colelution))," is not a colelution object with $table and $igraph fields")
         )
  ifelse(check_user_provided_colution_object(unified_coeluttion),
         TRUE,
         stop(deparse(substitute(unified_coleluttion)) ," is not a colelution object with $table and $igraph fields")
         )
  t1 <- coelution
  t2 <- unified_coeluttion
  t3 <- t1$table %>%
    dplyr::left_join(t2$table, by = "CONGENER") %>%
    dplyr::group_by(PATTERN.x) %>%
    dplyr::slice(1) %>%
    dplyr::group_by(PATTERN.y) %>%
    dplyr::select(-c(CLUSTER, CONGENER)) %>%
    dplyr::summarise_if(is.numeric, sum, na.rm = T)
  return(t3)
}



#' check_user_provided_colution_object
#'
#' ensures that object provided is a coelution object
#'
#' @param x
#'
#' @return boolean
check_user_provided_colution_object <- function(x){
   if ("table" %in% names(x) & "graph" %in% names(x)){
     if (igraph::is.igraph(x$graph)){
       return(TRUE)
     }else{
       return(FALSE)
     }
  }else{
     return(FALSE)
   }
}

