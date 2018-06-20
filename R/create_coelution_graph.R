#' create_coelution_graph
#'
#' This function uses a user provided data.frame with co-elutions patterns to generate
#' a co-elution table and a co-elution graph.
#'
#' These resulting objects are needed to create a merged co-elution graph.
#'
#' @param analyte_list data.frame with coelution patterns such as 4,10  4+10  or PCB 4,10
#' @param pattern_name string indicating column name with PCB congener patterns, recommended as PATTERN
#' @param sep string such "," or "+" designating how congeners in co-eluting patterns are separated
#' @param prefix string such as "PCB", "PCB-", "PCB " designating a prefix to be stripped
#' @param visual boolean for optional co-elution graph
#' @param verbose boolean for optioanl function progress messages
#'
#' @return list with $table and $graph
#' @export

create_coelution_graph <- function(analyte_list,
                                   pattern_name = "PATTERN",
                                   sep = ",",
                                   prefix = "",
                                   visual = FALSE,
                                   verbose = TRUE){
  # Checks validity of data.frame input
  if(pattern_name %in% names(analyte_list)){
    if (verbose){
      message("Using data.frame: ", deparse(substitute(analyte_list)),
              ", column: ", pattern_name, " to generate coelution graph" )
    }
  }else{
    stop("The column name designatiing co-elution patterns must be 'PATTERN'
         or specify a name using argument <pattern_name>")
  }

  # Checks that user provided seperator and prefixes
  if (is.null(sep)){
    stop("You must provide a seperator (e.g. sep = ',' '&' or '+' for the character seperated coeluting congeners")
  }
  if (is.null(prefix)){
    stop("You must provide a prefix (e.g. if your congeners are names PCB001 then the prefix is 'PCB')")
  }

  # Text handling to create list of numeric congeners ids
  elutions = stringr::str_split(analyte_list[[pattern_name]], sep)
  elutions = lapply(elutions, stringr::str_trim)
  elutions = lapply(elutions, function(i) sub(x = i, pattern = prefix, replacement = ""))
  elutions = lapply(elutions, function(i) as.numeric(i))

  # Create {node, node} graph file as dataframe
  l = list()
  j = 1
  for(e in elutions){
    line = e
    line = line[!is.na(line)]
    x1 = line[1]
    for(x in line){
      l[[j]] = c(x,x1); x1 = x; j = j +1
    }
  }
  df = do.call(rbind, l)

  # Extract cluster information
  g  <- igraph::graph_from_data_frame(df, directed = FALSE )
  gx <- igraph::simplify(g)
  igraph::E(gx)$weight<- 10 ; igraph::E(gx)$color <- "red" ; igraph::E(gx)$lty <- 2
  x <- igraph::clusters(g, mode = c("weak"))

  # Plots graph if visual argument is set to TRUE, default is FALSE
  if (visual){
    plot(gx, vertex.size=1, edge.width= 10)
  }


  if (verbose){
    number_of_clusters = as.character(x$no)
    message("CongeneR graph created for [", deparse(substitute(analyte_list)), "] with " ,
            number_of_clusters, " co-eluting groups")
  }


  # Forms cluster, congeners, and pattern information as dataframe
  df = data.frame(CLUSTER =  x$membership, CONGENER = as.numeric(names(x$membership)) )
  df2 <- df %>% dplyr::group_by(CLUSTER) %>%
    dplyr::summarise(PATTERN = paste(CONGENER, collapse = ","))
  df3 <- df %>% dplyr::left_join(df2, by = "CLUSTER") %>%
    dplyr::arrange(CONGENER)
  df4 <- df3 %>% dplyr::left_join(analyte_list, by = "PATTERN")

  #if (verbose){
  #  message(" Output  <-  has $table and $graph objects" )
  #}
  # Outputs table and graph objects to a list
  return(list(table= df4, graph = gx))
  }
