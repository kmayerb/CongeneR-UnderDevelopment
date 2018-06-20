
#' merge_with_coeluted_aroclors
#'
#' @param results
#' @param coelution_object
#' @param database
#'
#' @return
#' @export
#'
#' @examples
merge_with_coeluted_aroclors <-function(results, coelution_object, database = "Frame"){
  if ("PATTERN.y" == names(results)[1]){

      df <- results %>%
      dplyr::left_join(CongeneR::coelute_aroclors(coelution_object, database), by = c("PATTERN.y" = "PATTERN.y")) %>%
      CongeneR::sort_pattern_by_min_congener(call = "PATTERN.y") %>%
      dplyr::left_join(congener_information, by = c("MIN"="CONGENER"))
    return(df)

  }else if ("PATTERN" == names(results)[1] ){

    names(results)[1] <-"PATTERN.y"
    df <- results %>%
      dplyr::left_join(CongeneR::coelute_aroclors(coelution_object, database), by = c("PATTERN.y" = "PATTERN.y")) %>%
      CongeneR::sort_pattern_by_min_congener(call = "PATTERN.y") %>%
      dplyr::left_join(congener_information, by = c("MIN"="CONGENER"))

    }else{

    stop("results object needs PATTERN.y or PATTERN in the column names")

  }

  return(df)
}


#' A sorting function
#'
#' @param x
#'
#' @return
sort_pattern_by_min_congener <- function(x, call = "PATTERN.y"){
  x$MIN<- sapply(lapply(stringr::str_split(x[[call]],","), as.numeric), function(j) min(j, na.rm = T))
  y <- dplyr::arrange(x, MIN)
  return(y)
}




#D = s1.unif %>% left_join(coelute_standards(graph = unified_graph, database = d)) %>%
#  sort_pattern_by_min_congener(call = "PATTERN.y") %>%
#  left_join(congener_info, by = c("MIN"="CONGENER"))
