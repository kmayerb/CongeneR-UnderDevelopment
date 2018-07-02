# Chain to use CongeneR
# unify(create(s1),create(s2)) %>% reaggregate(coelution = .$ , unified_coeluttion = .$) %>% merge_aroclors(results = .$result1)

#' create()
#' 
#' creates a <coelution graph> object from a data.frame of coelution patterns and samples masses
#'
#' @param analyte_list data.frame with coelution patterns in first column and sample masses or mass percentage
#' @param pattern_name string column name for ce-elutions ('PATTERN' is default) 
#' @param sep string seperator between coelutions (e.g. for 4,10 sep = ",") 
#' @param prefix string for regex pattern to remove (eg. for 'PCB-01', prefix = "PCB-')
#' @param visual boolean if true, plots igraph on function call as a visual check
#' @param verbose boolean if true, reports size of result
#'
#' @return coelution graph object as a list with field $table, $graph, $result
#' @export 
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

#' unify
#'
#' @param graph1 coelution graph1 created with the create() function 
#' @param graph2 coelution graph2 created with the create() function 
#' @param verbose booelan if true, reports the inputs and number of unified synthetic coelution bins
#'
#'
#' @return unified coelution object $
#' @export
unify <- function(graph1, graph2, verbose = TRUE){
  unify_graphs(graph1=graph1, 
               graph2=graph2, 
               verbose = TRUE)
}


#' reaggregate
#'
#' @param coelution coelution object
#' @param unified_coeluttion unified coelution object
#'
#' @return
#' @export
#'
#' @examples
reaggregate <- function(coelution, unified_coeluttion){
  aggregate_over_unified_coelutions(coelution = coelution, unified_coeluttion=unified_coeluttion)
}

merge_aroclors <- function(results, coelution_object, database = "Frame"){
  merge_with_coeluted_aroclors(results=results, coelution_object=coelution_object, database = database )
}


