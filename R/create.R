## Wrappers for clean names

create <- function(analyte_list,
                   pattern_name = "PATTERN",
                   sep = ",",
                   prefix = "",
                   visual = FALSE,
                   verbose = TRUE){
  
  create_coelution_graph(analyte_list,
                         pattern_name = pattern_name,
                         sep = sep,
                         prefix = prefix,
                         visual = visual,
                         verbose = verbose)
}


unify <- function(graph1, graph2, verbose = TRUE){
  unify_graphs(graph1=graph1, 
               graph2=graph2, 
               verbose = TRUE)
}


reaggregate <- function(coelution, unified_coeluttion){
  aggregate_over_unified_coelutions(coelution = coelution, unified_coeluttion=unified_coeluttion)
}

merge_aroclors <- function(results, coelution_object, database = "Frame"){
  merge_with_coeluted_aroclors(results=results, coelution_object=coelution_object, database = database )
}


