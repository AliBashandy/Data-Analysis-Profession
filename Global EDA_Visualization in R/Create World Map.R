install.packages("ggplot2")
install.packages("rgl")
install.packages("extrafont")

library(rgdal) #OgrListlayers
library(ggplot2) #plotting ***
library(ggspatial) #Spatial Layer***
library(extrafont) #for font Rstudio***


# Natural Earth shape files -- global (Robinson) projections
# get shapefiles from http://www.naturalearthdata.com
shape_path <- "D:/Github/Data-Analysis/Global EDA/Natural Earth Shapes/Used Shapes"
coastline_shapefile <- paste(shape_path, "/ne_50m_coastline.shp", sep="")
ocean_shapefile <- paste(shape_path, "/ne_50m_ocean.shp", sep="")
countries_shapefile <- paste(shape_path, "/ne_50m_admin_0_countries.shp", sep="")
boundingbox_shapefile <- paste(shape_path, "/ne_50m_wgs84_bounding_box.shp", sep="")
graticules30_shapefile <- paste(shape_path, "/ne_50m_graticules_30.shp", sep="")
rivers_shapefile <- paste(shape_path, "/ne_50m_rivers_lake_centerlines.shp", sep="")
lakes_shapefile <- paste(shape_path, "/ne_50m_lakes.shp", sep="")
snowareas_shapefile <- paste(shape_path, "/ne_50m_glaciated_areas.shp", sep="")

# read the shape file

layer <- ogrListLayers(coastline_shapefile) # find out kind of shapefile (lines vs. polygons)
ogrInfo(coastline_shapefile, layer=layer)
coast_lines <- readOGR(coastline_shapefile, layer=layer) # read the shape file

layer <- ogrListLayers(rivers_shapefile)
ogrInfo(rivers_shapefile, layer=layer)
rivers_lines <- readOGR(rivers_shapefile, layer=layer)

layer <- ogrListLayers(ocean_shapefile)
ogrInfo(ocean_shapefile, layer=layer)
ocean_poly <- readOGR(ocean_shapefile, layer=layer)

layer <- ogrListLayers(snowareas_shapefile)
ogrInfo(snowareas_shapefile, layer=layer)
snowareas_poly <- readOGR(snowareas_shapefile, layer=layer)

layer <- ogrListLayers(lakes_shapefile)
ogrInfo(lakes_shapefile, layer=layer)
lakes_poly <- readOGR(lakes_shapefile, layer=layer)

layer <- ogrListLayers(countries_shapefile)
ogrInfo(countries_shapefile, layer=layer)
countries_poly <- readOGR(countries_shapefile, layer=layer)

layer <- ogrListLayers(graticules30_shapefile)
ogrInfo(graticules30_shapefile, layer=layer)
graticules30_lines <- readOGR(graticules30_shapefile, layer=layer)

layer <- ogrListLayers(boundingbox_shapefile)
ogrInfo(boundingbox_shapefile, layer=layer)
boundingbox_poly <- readOGR(boundingbox_shapefile, layer=layer)

# set Robinson CRS
robin_crs <- CRS("+proj=robin +lon_0=0w")

# do projections
boundingbox_poly_proj <- spTransform(boundingbox_poly, robin_crs)
coast_lines_proj <- spTransform(coast_lines, robin_crs)
rivers_lines_proj <- spTransform(rivers_lines, robin_crs)
countries_poly_proj <- spTransform(countries_poly, robin_crs)
graticules30_lines_proj <- spTransform(graticules30_lines, robin_crs)
ocean_poly_proj <- spTransform(ocean_poly, robin_crs)
snowareas_poly_proj <- spTransform(snowareas_poly, robin_crs)
lakes_poly_proj <- spTransform(lakes_poly, robin_crs)

#options(repr.plot.width=14, repr.plot.height=8) # Set the figures dimensions
wmap<- ggplot() +
  layer_spatial(boundingbox_poly_proj, fill="white", col="black") +
  layer_spatial(ocean_poly_proj, col = 'black',fill="#3880b2") +
  layer_spatial(countries_poly_proj, fill='#9fcf2b', col="black") +
  layer_spatial(snowareas_poly_proj, fill='white', col = "white") +
  layer_spatial(lakes_poly_proj, fill="#3880b2", col = "#3880b2") +
  layer_spatial(rivers_lines_proj, col="#3880b2")+
  layer_spatial(graticules30_lines_proj, col="#6ba8c4") +  
  
  # labs(
  #      caption = "World Map In Robinson Projection Based on Maps in R\n
  #    https://pjbartlein.github.io/REarthSysSci/RMaps.html" 
  # ) +
  theme(panel.background = element_blank(),
        plot.background = element_blank()
        #text = element_text(),
        #plot.title = element_text(color = '#01016b',
        #                          family = 'Algerian',
        #                          size = 16,
        #                          face = 'bold', 
        #                          hjust = 0.5, 
        #                          vjust = 0),
        #plot.caption = element_text(size =12)
        )
wmap

