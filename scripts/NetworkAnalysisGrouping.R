tool_exec <- function(in_params, out_params)
{
  #### Load library ####
  message("Loading Library...")
  if (!requireNamespace("igraph", quietly = TRUE))
    install.packages("igraph")
  if (!requireNamespace("RColorBrewer", quietly = TRUE))
    install.packages("RColorBrewer")
  if (!requireNamespace("dplyr", quietly = TRUE))
    install.packages("dplyr")
  if (!requireNamespace("sp", quietly = TRUE))
    install.packages("sp")
  
  require(igraph)
  require(dplyr)
  require(sp)
  require(RColorBrewer)
  
  #### Get input parameters ####
  message("Reading Input Parameters...")
  nodes_table <- in_params[[1]]
  nodes_table_join <- in_params[[2]]
  links_table <- in_params[[3]]
  input_geo_layer <- in_params[[4]]
  input_geo_layer_join <- in_params[[5]]
  clustering_algorithm <- in_params[[6]]
  weight_within <- as.numeric(in_params[[7]])
  weight_between <- as.numeric(in_params[[8]])
  color_set <- in_params[[9]]
  node_size <- as.numeric(in_params[[10]])
  edge_width <- as.numeric(in_params[[11]])
  label_size <- as.numeric(in_params[[12]])
    
  #### Set output parameters ####
  output_pdf <- out_params[[1]]
  output_fc <- out_params[[2]]
  output_csv <- out_params[[3]]
  
  # To control thinkness/distances between nodes 
  edge.weights <- function(community, network, weight.within = weight_within, weight.between = weight_between) 
  {
    bridges <- crossing(communities = community, graph = network)
    weights <- ifelse(test = bridges, yes = weight.between, no = weight.within)
    return(weights) 
  }
  
  #### Model Input ####
  nodes_df <- read.csv(file=nodes_table, header=T, stringsAsFactors=FALSE, check.names=FALSE)
  links_df <- read.csv(file=links_table, header=T, stringsAsFactors=FALSE, check.names=FALSE)

  #USE THESE TWO LINES ONLY WHEN YOU WANT A DERIVED OUTPUT SAVED AUTOMATICALLY TO SCRATCH WORKSPACE
  #env <- arc.env()
  #wkspath <- env$workspace	

  message("Creating Network Graph...")
  # change data frame format to igraph format
  network_graph <- graph_from_data_frame(d=links_df, vertices=nodes_df, directed=T)
  
  # create clusters
  message("Creating Clusters...")
  if (clustering_algorithm=="walktrap")
  {
    MyClusters.community <- cluster_walktrap(network_graph)
    community_df <- data.frame(V1 = unique(MyClusters.community)[[4]], cluster_N = as.numeric(unique(MyClusters.community)[[3]]))
    colnames(community_df)[1] <- nodes_table_join
  }
  
  if (clustering_algorithm == "spin_glass"){
    MyClusters.community <- cluster_spinglass(network_graph)
    community_df <- data.frame(V1 = unique(MyClusters.community)[[7]], cluster_N = as.numeric(unique(MyClusters.community)[[1]]))
	colnames(community_df)[1] <- nodes_table_join
  }
  
  community_df[ , which(names(community_df) == nodes_table_join)] <- as.character(community_df[ , which(names(community_df) == nodes_table_join)])
  
  # assign colors to clusters
  NumberOfColors <- length(unique(MyClusters.community))
  Colors <- brewer.pal(NumberOfColors, color_set)
  MyClusters.col <- Colors[membership(MyClusters.community)] 
  
  # change distances among nodes (within the same clusters & between clusters)
  E(network_graph)$weight <- edge.weights(MyClusters.community, network_graph)
  test.Layout.drl <- layout_with_drl(network_graph, weights = E(network_graph)$weight)
  
  # Select the boundary of network graph
  xmin <- min(test.Layout.drl[,1])
  xmax <- max(test.Layout.drl[,1])
  ymin <- min(test.Layout.drl[,2])
  ymax <- max(test.Layout.drl[,2])
  
  # Compute node degrees (number of links) and use that to set node size:
  arrivals.sum <- ((exp(V(network_graph)$larrivals.sender)-1)+(exp(V(network_graph)$larrivals.receiver-1)))
  V(network_graph)$larrivals.total <- log1p((arrivals.sum))
  V(network_graph)$size <- ((V(network_graph)$larrivals.total)^2)*node_size
  
  # Set edge width based on weight:
  E(network_graph)$width <- E(network_graph)$larrivals*edge_width
  
  V(network_graph)$label.color <- "black"
  V(network_graph)$label <- V(network_graph)$name
  V(network_graph)$label.cex <- label_size
  
  message("Reading Geographical Units Layer...")
  geo_layer_arc_dataset <- arc.open(input_geo_layer)
  str_lst <- paste0("'", paste(community_df[ , which(names(community_df) == nodes_table_join)], collapse="', '"), "'")
  geo_layer_df <- arc.select(geo_layer_arc_dataset, where_clause = paste0(input_geo_layer_join, " IN (", str_lst, ")"))

  message("Joining Network Table to Geographical Units Layer...")
  geo_layer_df_join <- inner_join(geo_layer_df, community_df, by = setNames(nm=input_geo_layer_join, nodes_table_join))
  #geo_layer_df_join <- merge(geo_layer_df, community_df, by.x = input_geo_layer_join, by.y = nodes_table_join)
  geo_layer_df_join <- geo_layer_df_join[ , names(geo_layer_df_join) %in% c("FID", "cluster_N")]  #keep only cluster number column
  
  geo_layer_spdf <- arc.shape2sp(arc.shape(geo_layer_df))
  
  message("Creating Output Shapefile...")
  SPDF = SpatialPolygonsDataFrame(geo_layer_spdf, data=geo_layer_df_join)
  shape_info <- list(type="Polygon", WKT=arc.shapeinfo(arc.shape(geo_layer_df))$WKT)

  message("Creating Output CSV file...")
  deg_stat = degree(network_graph)
  clo_stat = closeness(network_graph,normalized = TRUE)
  betw_stat = betweenness(network_graph)
  inte_csv = data.frame(degree = deg_stat, closeness = clo_stat, betweenness = betw_stat)
  print("Network Analysis Report:", quote = FALSE)
  print(inte_csv)

  message("Creating Plots for Clusters...")
  result = tryCatch({
    pdf(output_pdf)
    
    suppressWarnings(plot(x=MyClusters.community, y=network_graph, layout=test.Layout.drl, 
         mark.groups=NULL, edge.color = c("tomato2", "darkgrey")[crossing(MyClusters.community, network_graph)+1],
         edge.arrow.size=0, rescale=F, xlim=c(xmin,xmax),ylim=c(ymin,ymax), asp=0, col = MyClusters.col))
    
  }, finally = {
    dev.off()
  }
  )
  #### Set Output Parameters ####  
  message("Saving Output Files ...")
  arc.write(path=output_fc, data=SPDF, shape_info=shape_info)
  write.csv(inte_csv,file = output_csv)
  return(out_params)
}



