
#' reaggregate_over_unified_table
#'
#' @param t1
#' @param t2
#'
#' @return
#' @export
#'
#' @examples
aggregate_over_unified_tables <- function(table1,table2){
  t3 = t1$table %>%
    dplyr::left_join(t2$table, by = "CONGENER") %>%
    dplyr::group_by(PATTERN.x) %>% slice(1) %>%
    dplyr::group_by(PATTERN.y) %>%
    dplyr::select(-c(CLUSTER, CONGENER)) %>%
    dplyr::summarise_if(is.numeric, sum, na.rm = T)
}
