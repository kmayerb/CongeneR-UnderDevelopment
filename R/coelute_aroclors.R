#' coelute_aroclors
#'
#' @param graph
#' @param database
#'
#' @return
#' @export
#'
#' @examples
coelute_aroclors <- function(coelution_object, database = "Frame"){
  if (database == "Frame"){
    coelution_object$table %>%
      dplyr::left_join(frame_congener_table, by ="CONGENER") %>%
      dplyr::group_by(PATTERN) %>%
      dplyr::summarise_at(.vars = c("A1016c" ,  "A1242d"  , "A1248e"  , "A1248f"   ,"A1254g" ,  "A1254h"  , "A1260i"  ),
                          .funs = c(sum),
                          na.rm = T) %>%
      dplyr::rename(PATTERN.y = PATTERN)
  }else{
    stop("datbase argument must be set to 'Frame'
         More congener reference aroclor database will be supported soon")
  }
}



