#' unify_graphs
#'
#' unifies two co-elution graphs created from create_coelution_graph_from_analyte_list()
#'
#' @param graph1 igraph object from create_coelution_graph_from_analyte_list()
#' @param graph2 igraph object from create_coelution_graph_from_analyte_list()
#'
#' @return unified graph list with table and igraph object
#' @export
unify_graphs <- function(graph1, graph2, verbose = TRUE){
  # cache inputs
  cache_graph1 = graph1
  cache_graph2 = graph2
  # Check that graph1 and graph 2 are both igraph objects
  # or check if graph1$graph are graph2$graph are igraph objects
  # otherwise stop and ask user for correct input types
  if(! ( igraph::is.igraph(graph1) & igraph::is.igraph(graph2) ) ){
    if (! ("graph" %in% names(graph1) & "graph" %in% names(graph2) ) ) {
      stop("input arguments graph1 and graph2 must be igraph objects
         if using output <- create_coelution_graph_from_analyte_list()
         you can use the output or output$graph in unify_graphs(g1= ouptput$graph ... )")
    }else if ( igraph::is.igraph(graph1$graph) & igraph::is.igraph(graph2$graph) ){
        graph1 <- graph1$graph
        graph2 <- graph2$graph
    }else{
      stop("input arguments graph1 and graph2 must be igraph objects
         if using output <- create_coelution_graph_from_analyte_list()
           you can use the output or output$graph in unify_graphs(g1= ouptput$graph ... )")
    }
  }

  # union of two (or more graphs)
  #   %u% sugar is imported in namespace from igraph
  #   %>% sugar is inmported in namespace from magrittr
  g <- graph1 %u% graph2
  g <- igraph::simplify(g)
  x <- igraph::clusters(g, mode = c("weak"))
  # block 4 outputs cluster, congener, and pattern information as dataframe
  df = data.frame(CLUSTER =  x$membership, CONGENER = as.numeric(names(x$membership)) )
  df2 <- df %>% dplyr::group_by(CLUSTER) %>%
    dplyr::summarise(PATTERN = paste(CONGENER, collapse = ","))
  df3 <- df %>% dplyr::left_join(df2, by= "CLUSTER") %>%
    dplyr::arrange(CONGENER) %>%
    dplyr::select(CONGENER, PATTERN) %>%
    data.frame()
  if(verbose){
    x <- igraph::clusters(g, mode = c("weak"))
    number_of_clusters = as.character(x$no)
    message("CongeneR unified_graph created for [graph1, graph2] with " , #, deparse(substitute(graph2)),
            number_of_clusters, " co-eluting groups")
  }
  #if (verbose){
  #  message("  Output <- unify_graphs()  has a $table and a $graph objects" )
  #}
  return(list(table= df3, 
              graph = g, 
              result = cache_graph1$results, 
              result2 = cache_graph2$results,
              cache_graph  = cache_graph1,
              cache_graph2 = cache_graph2
              ) )
}
