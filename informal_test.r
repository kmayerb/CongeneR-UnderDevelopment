# Vingette Skelleton

# The package contains two example samples (s1, s2) with different coelution patterns
s1 # (SPB-octyl Column)
s2 # (DB-5 Column)

# The first step is generate a coelution graph for both types of samplse
s1.elutions <- create_coelution_graph(s1)
s2.elutions <- create_coelution_graph(s2)

# CongeneR simplifies the task of comparing our samples to Aroclors.
# we can call the coelute_aroclors() function
# it has two arguments:
  # coelution_object - the object generated by create_coelution_graph_from_analyte_list()
  # database - options are "Frame" or "Rushneck
s1.aroclor <- coelute_aroclors(coelution_object = s1.elutions,
                               database = "Frame" )

# We can call merge_with_coeluted_aroclors() to append the aroclors to our datatable
s1.plus.aroclors <- merge_with_coeluted_aroclors(results = s1,
                                                 coelution_object = s1.elutions,
                                                 database = "Frame")

s2.plus.aroclors <- merge_with_coeluted_aroclors(results = s2,
                                                 coelution_object = s2.elutions,
                                                 database = "Frame")



par(mfrow = c(2,1))
fingerprint_plot(s1.plus.aroclors, sample = A1254g, main= "Aroclor 1254 (GE/118-peak analytical standard) on your SPB-octyl Column")
fingerprint_plot_overlay(s1.plus.aroclors, sample = SAMPLE1)
fingerprint_plot(s2.plus.aroclors, sample = A1254g, main= "Aroclor 1254 (GE/118-peak analytical standard) on your DB-5 Column")
fingerprint_plot_overlay(s2.plus.aroclors, sample = SAMPLE1)

# use a built in or custom function to compare samples to standards
cor(s1.plus.aroclors[,2:10])
cor(s2.plus.aroclors[,2:10])


  # Frame" generates aroclors from the data generated by Frame et al. (1996)
      # it includes
        # A1016c - Aroclor 1016 Lot A2
        # A1242d - Mean of three Lots of Aroclor 1242
        # A1248e - Lot A3.5 Aroclor 1248
        # A1248f - Lot G3.5 Aroclor 1248
        # A1254g - Lot A4 Aroclor Arolcor 1254 (Monsanto Lot KI-02-6024) from abnormal late production
        # A1254h - Lot G4 Aroclor 1254 (GE/118-peak analytical standard)
        # A1260i - Mean of three Lots of Aroclor 1260
  # "Rushneck" Aroclors Chemosphere 54 (2004) 79-87
        # Includes 1221	1232	1016	1242	1248	1254	1260	1262	1268



# CongeneR can handle the more advanced task of combining samples eluted on different columns


# We can create a unified graph
s1.s2.elutions <- unify_graphs(s1.elutions,
                                s2.elutions)


s1.unified <- aggregate_over_unified_coelutions(s1.elutions, s1.s2.unified_graph)
s2.unified <- aggregate_over_unified_coelutions(s2.elutions, s1.s2.unified_graph)

# get standards expected from your custom coelution pattern
coelute_aroclors(coelution_object = s1.s2.elutions, database = "Frame")

# or get standards joined to your new data
s1.unifed.aroclors <- merge_with_coeluted_aroclors(results = s1.unified,
                             coelution_object = s1.s2.elutions,
                             database = "Frame")

s2.unifed.aroclors <- merge_with_coeluted_aroclors(results = s2.unified,
                                                   coelution_object = s1.s2.elutions,
                                                   database = "Frame")


require(magrittr)

fingerprint_plot(s1.unifed.aroclors, sample = A1254h, main = "Aroclor 1254 Unified Coelution SPB-octyl and DB-5")
fingerprint_plot_overlay(s1.unifed.aroclors, SAMPLE1)
fingerprint_plot(s1.unifed.aroclors, sample = A1254g, main = "Aroclor 1254 (late production) Unified Coelution SPB-octyl and DB-5")
s1.unifed.aroclors %>% fingerprint_plot_overlay(SAMPLE1)


s1.unifed.aroclors %>% fingerprint_plot(SAMPLE1, main = "s1,SAMPLE1 SPB-octyl")
s2.unifed.aroclors %>% fingerprint_plot(SAMPLE1, main = "s2,SAMPLE1 DB-5")


#s1.coelution_object <- create_coelution_graph_from_analyte_list(s1, prefix = "", sep = ",")
#s2.coelution_object <- create_coelution_graph_from_analyte_list(s2, prefix = "", sep = ",")


# We can also work  work with legacy congener data with far fewer congeners
s3
s3.elutions <- create_coelution_graph(s3)
s3.plus.aroclors <- merge_with_coeluted_aroclors(s3, s3.elutions)
fingerprint_plot(s3.plus.aroclors, sample = A1260i, main="Legacy Elutions for Aroclor 1260", add_summary = F, cex.names = 1)
fingerprint_plot(s3.plus.aroclors, sample = A1242d, main="Legacy Elutions for Aroclor 1242")


