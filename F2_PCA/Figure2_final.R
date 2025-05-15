library(ggplot2)
library(ggrepel)
library(dplyr)
library(ggpubr)
library(psych)

#Load in files
setwd("/Users/veronicapagowski/Desktop/MOLECOL/F2_PCA")
#Min ind 50%, pruning, all individuals excluding re sequenced individuals, n = at least 4
C <- read.table("Pmin_lc_geno_e6_maf0.05_OGsiteprune_R1+R2_minind117.beagle.gz_pca_clean.cov") 

#Match up to fam file and assign colors
final_fam<-read.csv(file="old_new_bams_rmreseq2.csv")
custom_order<-c("Haida Gwaii","Central BC","Winter Harbor","Ucluelet","Bamfield","Fort Bragg","Monterey","Hazard Canyon","Santa Barbara","LA","San Diego","Ensenada","Monterey Male","Monterey Female")  
cols <- c("deeppink4","burlywood3","lightsalmon","hotpink2","darkorange","lightgoldenrod2","olivedrab3","mediumseagreen","dodgerblue","lightskyblue1","plum","blueviolet","blue1","deeppink")

#Do NMDS
d<-cor2dist(C)
is.nan.data.frame <- function(x)
  do.call(cbind, lapply(x, is.nan))
d[is.nan(d)] <- 0

mds <- d %>%
  cmdscale() %>%
  as_tibble()
colnames(mds) <- c("Dim.1", "Dim.2")

# Plot MDS
mds2 <- cbind(mds, group = final_fam$group, Collection=final_fam$Collection)
mds2$group <- factor(mds2$group, levels = custom_order)
fig1a <- ggplot(mds2, aes(x = Dim.1, y = Dim.2, color = group, shape= Collection)) +
  geom_point(size =2.5, alpha=0.5) +  
  scale_color_manual(values = cols) +
  scale_shape_manual(values = c(17, 15, 16), guide = guide_legend(override.aes = list(color = "black"))) +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank()) +
  coord_cartesian(clip = "off") +
  labs(color = "Location",x = "NMDS 1", y = "NMDS 2")+
  theme_bw()
  #stat_ellipse(aes(group = group), level = 0.95, type = "t", alpha=0.3) + #add elipses

fig1a <- fig1a +
  annotate(
    "rect",
    xmin = 0.1, xmax = -0.05, ymin = -0.1, ymax = 0.1,  # Full plot area
    fill = NA, color = "black", linetype = "dashed", linewidth = 0.5)+
  annotate(
    "text",
    x = -0.03,  # X-coordinate near line
    y = 0.14,  # Y-coordinate near line
    label = "B",
    color = "black", size = 5, fontface = "bold")
  

print(fig1a)   
###Figure 1b: Look at same covariance matrix - remove Haida Gwaii,Central BC and Bamfield outliers
C2 <- read.table("Pmin_lc_geno_e6_maf0.05_OGsiteprune_R1+R2_minind117.beagle.gz_pca_clean.cov") 
rows_cols_to_remove <- c(3,9,13,15,7,19:29,57:66)
C2<- C2[-rows_cols_to_remove, -rows_cols_to_remove]
#Match up to fam file and assign colors
final_fam2<-read.csv(file="old_new_bams_rmreseq3.csv")
custom_order2<-c("Winter Harbor","Ucluelet","Bamfield","Fort Bragg","Monterey","Hazard Canyon","Santa Barbara","LA","San Diego","Ensenada")  
cols2 <- c("lightsalmon","hotpink2","darkorange","lightgoldenrod2","olivedrab3","mediumseagreen","dodgerblue","lightskyblue1","plum","blueviolet")

#Do NMDS
d2<-cor2dist(C2)
is.nan.data.frame <- function(x)
  do.call(cbind, lapply(x, is.nan))
d2[is.nan(d2)] <- 0

mds_small <- d2 %>%
  cmdscale() %>%
  as_tibble()
colnames(mds_small) <- c("Dim.1", "Dim.2")

# Plot MDS
mds_small2 <- cbind(mds_small, group = final_fam2$group, Collection=final_fam2$Collection)
mds_small2$group <- factor(mds_small2$group, levels = custom_order2)
fig1b <- ggplot(mds_small2, aes(x = Dim.1, y = Dim.2, color = group, shape= Collection)) +
  geom_point(size =2.5, alpha=0.5) +  
  scale_color_manual(values = cols2) +
  scale_shape_manual(values = c(17, 15, 16), guide = guide_legend(override.aes = list(color = "black"))) +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank()) +
  coord_cartesian(clip = "off") +
  labs(color = "Location",x = "NMDS 1", y = "NMDS 2")+
  theme_bw()

#Plot the covariance matrix generated from removing scaffolds 64/65 - sex differences removed
C3 <- read.table("Pmin_lc_geno_e6_maf0.05_OGsiteprune_R1+R2_minind117.beagle.gz_no645_pca_clean.cov") 
C3<- C3[-rows_cols_to_remove, -rows_cols_to_remove]

#Do NMDS
d3<-cor2dist(C3)
is.nan.data.frame <- function(x)
  do.call(cbind, lapply(x, is.nan))
d3[is.nan(d3)] <- 0

mds_sex <- d3 %>%
  cmdscale() %>%
  as_tibble()
colnames(mds_sex) <- c("Dim.1", "Dim.2")

# Plot MDS
mds_sex2 <- cbind(mds_sex, group = final_fam2$group, Collection=final_fam2$Collection)
mds_sex2$group <- factor(mds_sex2$group, levels = custom_order2)
fig1c <- ggplot(mds_sex2, aes(x = Dim.1, y = Dim.2, color = group, shape= Collection)) +
  geom_point(size =2.5, alpha=0.5) +  
  scale_color_manual(values = cols2) +
  scale_shape_manual(values = c(17, 15, 16), guide = guide_legend(override.aes = list(color = "black"))) +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank()) +
  coord_cartesian(clip = "off") +
  labs(color = "Location",x = "NMDS 1", y = "NMDS 2")+
  theme_bw()

#Plot the covariance matrix generated with sexed individuals - minind filter is 10 (not 117)
C4 <- read.table("Pmin_lc_genolike3_R1+R2_maf0.05_clean.covMat") 
sample_id<-read.csv(file="Sample_list_all.csv")
#Remove resequencesamples and Haida Gwaii, Central BC, Outlier Bamfied
#These make it difficult to see PC2 variation where you can see sex differences
rows_cols_to_remove <- c(1:31,59:68,94:120,146,150,152,153,155,193:195,230)
C4 <- C4[-rows_cols_to_remove, -rows_cols_to_remove]
#We will also add a column with population assingments
sample_id <- sample_id[-c(1:31,59:68,94:120,146,150,152,153,155,193:195,230), ]

#add male and female colors
custom_order3<-c("Winter Harbor","Ucluelet","Bamfield","Fort Bragg","Monterey Male","Monterey Female","Hazard Canyon","Santa Barbara","LA","San Diego","Ensenada")  
cols3 <- c("lightsalmon","hotpink2","darkorange","lightgoldenrod2","mediumseagreen","dodgerblue","lightskyblue1","plum","blueviolet","blue1","deeppink")

#Do NMDS
d4<-cor2dist(C4)
is.nan.data.frame <- function(x)
  do.call(cbind, lapply(x, is.nan))
d4[is.nan(d4)] <- 0

mds_sexlab <- d4 %>%
  cmdscale() %>%
  as_tibble()
colnames(mds_sexlab) <- c("Dim.1", "Dim.2")

# Plot MDS
mds_sexlab2 <- cbind(mds_sexlab, group = sample_id$group, Collection=sample_id$Collection)
mds_sexlab2$group <- factor(mds_sexlab2$group, levels = custom_order3)

fig1d <- ggplot(mds_sexlab2, aes(x = -Dim.1, y = Dim.2, color = group, shape= Collection)) +
  geom_point(data = subset(mds_sexlab2, !(group %in% c("Monterey Male", "Monterey Female"))), 
             alpha = 0.3, size = 2.5) +
  geom_point(data = subset(mds_sexlab2, group %in% c("Monterey Male", "Monterey Female")), 
             alpha = 0.8, size = 2.5) + 
  scale_color_manual(values = cols3) +
  scale_shape_manual(values = c(17, 15, 16), guide = guide_legend(override.aes = list(color = "black"))) +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank()) +
  coord_cartesian(clip = "off") +
  labs(color = "Location",x = "NMDS 1", y = "NMDS 2")+
  theme_bw()
# Add a manual legend to one plot (e.g., fig1d)

fig1d <- fig1d +
  annotate(
    "rect",
    xmin = -0.6, xmax = -0.2,  # X-coordinates (0-1 scale)
    ymin = -0.7, ymax = -0.55,  # Y-coordinates (0-1 scale)
    fill = "white", alpha = 0.8, color = "black"
  ) +
  annotate(
    "point",
    x = -0.54, y = -0.59,  # Position within the box
    color = "blue1", size = 3
  ) +
  annotate(
    "text",
    x = -0.5, y = -0.59,
    label = "Sexed Male", hjust = 0, size = 3
  ) +
  annotate(
    "point",
    x = -0.54, y = -0.65,
    color = "deeppink", size = 3
  ) +
  annotate(
    "text",
    x = -0.5, y = -0.65,
    label = "Sexed Female", hjust = 0, size = 3
  ) +
  
  coord_cartesian(clip = "off")  # Allow drawing outside plot area
fig1d
# Rebuild your combined plot
ggpubr::ggarrange(fig1a, fig1b, fig1c, fig1d, ncol = 2)



all<-ggarrange(
  fig1a, fig1b, fig1c, fig1d,
  labels = c("A", "B", "C", "D"),
  font.label = list(face = "bold", size = 14),
  ncol = 2, nrow = 2,
  common.legend = TRUE,   # Use a single legend for all plots
  legend = "left"        # Position the legend to the left
)


ggsave(filename = "Figure2_final.pdf", 
       plot = all, 
       width = 10, 
       height =8, 
       units = "in")
