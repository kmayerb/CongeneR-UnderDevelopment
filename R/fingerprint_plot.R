#' fingerprint_plot2
#'
#' @param df
#' @param sample
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
fingerprint_plot <-function(df,
                            sample =NULL,
                            backdoor = NULL,
                            call = "PATTERN.y",
                            colors = c("#8dd3c7","#ffffb3","#bebada","#fb8072","#80b1d3","#fdb462","#b3de69","#fccde5","#d9d9d9"),
                            add_summary = TRUE,
                            cex.names = .5,
                            verbose = FALSE,
                            ...){
  
  if (!is.null(backdoor)){
    sample1 = backdoor
  }else{
    sample1 = as.character((substitute(sample)))
  }
  
  barplot(df[[sample1]],
          names.arg = df[[call]],
          las = 2 ,
          col= colors[df$CHLORINE],
          space = 0,
          cex.names = cex.names,
          ylab = "Percent",
          ...)

  df$SMALL <- NA
  df$SMALL[df[[sample1]] < .05 & df[[sample1]] > 0 ] <- df[[call]][df[[sample1]] < .05 & df[[sample1]] > 0 ]
  text(seq_along(df[[call]]), df[[sample1]]+.25, labels = df$SMALL, cex = 0.7, pos = 3,  srt = 90)
  breaks<-which(diff(df$CHLORINE) == 1)
  abline(v = breaks, lty = 2)
  top = max(df[[sample1]])




  if (!is.null(backdoor)){
    df_group <- df %>%
      dplyr::group_by(CLASS, CHLORINE) %>%
      #dplyr::summarise(SUM = sum(!!expr, na.rm = T) ) %>%
      dplyr::summarise(SUM = sum(!!rlang::sym(backdoor), na.rm = T) ) %>%
      dplyr::arrange(CHLORINE)
  }else{
    expr <- dplyr::enquo(sample)
    df_group <- df %>%
      dplyr::group_by(CLASS, CHLORINE) %>%
      dplyr::summarise(SUM = sum(!!expr, na.rm = T) ) %>%
      #dplyr::summarise(SUM = sum(!!rlang::sym(backdoor), na.rm = T) ) %>%
      dplyr::arrange(CHLORINE)
  }

  
  if(verbose){print(df_group)}
  total_sum <- sum(df_group$SUM)
  df_group$SUM <- 100*(df_group$SUM / total_sum)
  if(verbose){print(df_group)}
  df_group$SUM <- round(df_group$SUM, 1)
  if (add_summary){
    text(c(breaks), c(rep(top-.5, times = length(breaks)-1), top-4), labels=c("1-CB","2-CB","3-CB","4-CB","5-CB","6-CB","7-CB","8-CB","9-CB"), pos =2, cex = .75)
    text(c(breaks), c(rep(top-1.5, times = length(breaks)-1), top-4.5), labels=paste(df_group$SUM, "%"), pos =2)

  }
}



#' fingerprint_plot_overlay
#'
#'
#'
#' @param test
#' @param sample
#' @param sample2
#' @param call
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
fingerprint_plot_overlay <- function(df,sample,
                                     call = "PATTERN.y",
                                     color = "#00000020",
                                     add = TRUE, ...){
  sample1 = as.character((substitute(sample)))
  print(sample1)
  barplot(df[[sample1]],
          names.arg = df[[call]],
          las = 2 ,
          col= color,
          space = 0,
          cex.names = .5,
          ylab = "Percent",
          add = add,
          ...)
}
