Coupled Human-Natural Systems (CHANS) Tools
=============================================

![R_ArcGIS_logo](/img/logo_V2.png)

Collections of geoprocessing tools for coupled human-natural systems (CHANS) analysis using R scripts within ESRI's ArcGIS.

* Sample ArcMap MXD and Dataset
* ArcGIS toolbox (.tbx) files
* Documentation


Look at R code to see how it works.


Requirements
------------

 - [ArcGIS R bridge](https://github.com/R-ArcGIS/r-bridge-install)
 - [R Statistical Computing Software](http://www.r-project.org)

### (optional)

 - Geostatistical Analyst Extension for ArcGIS

Factor Analysis for Mixed Data
-------------------------------

Uses the [FactoMineR](http://factominer.free.fr/) and [missMDA](http://math.agrocampus-ouest.fr/infoglueDeliverLive/developpement/missMDA) packages from the R software to perform factor analysis on mixed quantitative/qualitative data. See tool documentation for more information.

![FAMD_logo](/img/famd_V2.png)

Network Analysis Grouping
-------------------------------

Uses the [igraph](http://igraph.org/r/), [dplyr](https://cran.r-project.org/web/packages/dplyr/vignettes/dplyr.html), [sp](https://www.rdocumentation.org/packages/sp/versions/1.3-1), [RColorBrewer](https://moderndata.plot.ly/create-colorful-graphs-in-r-with-rcolorbrewer-and-plotly/) packages from the R software to find similar groups (clusters) from network connectivity data using social network analysis (SNA) techniques. This tool uses network information (i.e. nodes, links, and directions) of units (e.g. countries, areas, administrative units) and aggregates them into groups (clusters) based on their network connectivity. See tool documentation for more information.

![NetworkAnalysis_logo](/img/network_union_V2.png)

## Credits

Factor Analysis for Mixed Data uses the [FactoMineR](http://factominer.free.fr/) and [missMDA](http://math.agrocampus-ouest.fr/infoglueDeliverLive/developpement/missMDA) packages for R:

> `FactoMineR`: Exploratory data analysis methods such as principal component methods and clustering. By Francois Husson, Julie Josse, Sebastien Le, Jeremy Mazet. Email: francois.husson@agrocampus-ouest.fr. Licensed under the GPL-2 and GPL-3 (expanded from: GPL (≥ 2))

> `missMDA`: Imputation of incomplete continuous or categorical datasets; Missing values are imputed with a principal component analysis (PCA), a multiple correspondence analysis (MCA) model or a multiple factor analysis (MFA) model; Perform multiple imputation with and in PCA. By Francois Husson, Julie Josse. Email: francois.husson@agrocampus-ouest.fr. Licensed under the GPL-2 and GPL-3 (expanded from: GPL (≥ 2))

Network Analysis Grouping uses the [igraph](http://igraph.org/r/), [dplyr](https://cran.r-project.org/web/packages/dplyr/vignettes/dplyr.html), [sp](https://www.rdocumentation.org/packages/sp/versions/1.3-1), [RColorBrewer](https://moderndata.plot.ly/create-colorful-graphs-in-r-with-rcolorbrewer-and-plotly/) packages for R:

> `igraph`: Routines for simple graphs and network analysis. It can handle large graphs very well and provides functions for generating random and regular graphs, graph visualization, centrality methods and much more

> `dplyr`: A fast, consistent tool for working with data frame like objects, both in memory and out of memory

> `sp`: Classes and methods for spatial data; the classes document where the spatial location information resides, for 2D or 3D data. Utility functions are provided, e.g. for plotting data as maps, spatial selection, as well as methods for retrieving coordinates, for subsetting, print, summary, etc.

> `RColorBrewer`: Provides color schemes for maps (and other graphics) designed by Cynthia Brewer as described at http://colorbrewer2.org

All tools depend on the R Statistical Computing Software:

> Copyright (C) 2018 The R Foundation for Statistical Computing
> R is free software and comes with ABSOLUTELY NO WARRANTY.

## Author

All tools in this repository are developed by Francesco Tonini. 
For questions or issues related to these tools, please contact me at:

* Email: ftonini84@gmail.com
* Website: [www.FrancescoTonini.com](http://www.francescotonini.com/)
* Twitter: [@f_tonini](https://twitter.com/f_tonini)
* Github: [f-tonini](https://github.com/f-tonini)
