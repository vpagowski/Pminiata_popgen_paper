#Load libraries
library(dplyr) 
library(ggplot2)
setwd("/Users/veronicapagowski/Desktop/MOLECOL/F1_Map")
samples <- read.csv("samples.csv", header=TRUE) #comp1 and 2 for wsn comp #samples2.csv for Figure1

#Import a map
world <- rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")
map<-ggplot2::ggplot(data = world) +
  ggplot2::geom_sf() +
  ggplot2::coord_sf(
    xlim = c(-135, -112),#-138, -105
    ylim = c(23, 58),#20, 60
    expand = FALSE
  )

custom_order<-c("Haida Gwaii","Central BC","Winter Harbor","Ucluelet","Bamfield","Fort Bragg","Monterey","Hazard Canyon","Santa Barbara","LA","San Diego","San Diego (Hi)","Ensenada")  
cols2 <- c("deeppink4","burlywood3","lightsalmon","hotpink2","darkorange","lightgoldenrod2","olivedrab3","mediumseagreen","dodgerblue","lightskyblue1","plum","blueviolet")
samples$Location <- factor(samples$Location, levels = custom_order)

map2<-map + 
  geom_point(data=samples, alpha=0.6,
             position = position_jitter(width = 0, height = 0, seed = 123),
             aes(x=long, y=lat, size=Number, fill=Location),
             shape=21, stroke=0) +
  geom_point(data=samples, alpha=0.8, 
             position = position_jitter(width = 0, height = 0, seed = 123),
             aes(x=long, y=lat, size=Number, color=Collection),
             fill=NA, shape=21, stroke=0.8) +
  scale_fill_manual(values = cols2) +
  scale_color_manual(values = c("Aquarium" = "pink3", "New" = "purple4", "Historic" = "aquamarine4")) +
  theme_classic()+
  theme(axis.title.x=element_blank(), axis.title.y=element_blank())+
  guides(size = "none") +
  theme(panel.border = element_rect(color = "black", fill = NA, linewidth = 1))

#FOR pdf
ggsave(filename = "Figure1_Final.pdf", 
       plot = map2, 
       width = 5, 
       height = 7, 
       units = "in")
