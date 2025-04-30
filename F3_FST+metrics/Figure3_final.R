#Setup workspace
library(ggplot2)
library(tidyverse)
library(patchwork)
library(pheatmap)
library(RColorBrewer)
library(gridExtra)
library(cowplot)
library(ggplotify)
setwd("/Users/veronicapagowski/Desktop/MOLECOL/F3_FST+metrics")

### Make Fst Plot | Figure 3A ###

#Make Matrix from Fst values, generated with bash scripts pairwise comparisons
pairwise_fst <- read.csv("fst_data.csv", header = TRUE, stringsAsFactors = TRUE)
pairwise_fst <- as.data.frame(pairwise_fst)
pop1_levels <- levels(as.factor(pairwise_fst$pop1))
pop2_levels <- levels(as.factor(pairwise_fst$pop2))
heatmap_matrix <- matrix(NA, nrow = length(pop1_levels), ncol = length(pop2_levels),
                         dimnames = list(pop1_levels, pop2_levels))

#Fill the matrix with the corresponding values from weighted_fst
for (i in 1:nrow(heatmap_matrix)) {
  for (j in 1:ncol(heatmap_matrix)) {
    pop1_val <- rownames(heatmap_matrix)[i]
    pop2_val <- colnames(heatmap_matrix)[j]
    value <- pairwise_fst[pairwise_fst$pop1 == pop1_val & pairwise_fst$pop2 == pop2_val, "weighted_fst"]
    if (length(value) > 0) {
      heatmap_matrix[i, j] <- mean(value)
    }
  }
}

# Colors and asthetics
custom_order<-c("Haida Gwaii (Hi)","Central BC (Hi)","Winter Harbor (Hi)","Ucluelet","Bamfield","Bamfield (Hi)","Fort Bragg","Fort Bragg (AQ)","Monterey","Hazard Canyon","Santa Barbara","Santa Barbara (AQ)","LA (AQ)","San Diego (AQ)","Ensenada")
heatmap_matrix_reordered <- heatmap_matrix[custom_order, custom_order]
num_colors <- 100  # Specify the number of colors you want
color_palette <- rev(c("#FA8072","#EEB4B4", "mistyrose3","#CDC1C5","#B9D3EE", "#A4BEE1", "#6892CD", "#4A7CC3","#3A5FCD", "#2C66B9", "#0E50AF", "#08306B","#05004B"))
breaks <- seq(0, 0.035, length.out = length(color_palette) + 1)


# Mask the lower triangle of the matrix
upper_tri <- heatmap_matrix_reordered
upper_tri[lower.tri(upper_tri)] <- NA  # Set lower triangle to NA
diag(upper_tri) <- 0
formatted_numbers <- ifelse(is.na(upper_tri) | upper_tri == 0, "", sprintf("%.3f", upper_tri))
# Plot the heatmap
library(gridExtra)
library(grid)
fig3a_real <- pheatmap(upper_tri, 
                  display_numbers = formatted_numbers, 
                  cluster_rows = FALSE,
                  cluster_cols = FALSE,
                  color = color_palette,
                  breaks = breaks,
                  number_color = "white",
                  na_col = "ivory2",
                  border_color = "black",
                  angle_col = 90,
                  silent = TRUE,
                  legend = FALSE)
g <- fig3a_real$gtable #actual plot

#make a dummy just to put scalebar on left
fig3a_dummy <- pheatmap(upper_tri, 
                    display_numbers = formatted_numbers, 
                    cluster_rows = FALSE,
                    cluster_cols = FALSE,
                    color = color_palette,
                    breaks = breaks,
                    number_color = "white",
                    na_col = "ivory2",
                    border_color = "black",
                    angle_col = 90,
                    silent = TRUE,
                    legend = TRUE)

legend_grob <- fig3a_dummy$gtable$grobs[[4]]
#custom viewport for the legend
legend_vp <- viewport(
  width = unit(0.95, "grobwidth", legend_grob),  # Use legend's natural width
  height = unit(0.85, "npc"),  # Match parent viewport height
  just = "left"
)
legend_grob <- editGrob(legend_grob, vp = legend_vp)

fig3a <- grid.arrange(legend_grob, g, ncol = 2, widths = c(1, 5))


### Make Coverage Plot | Figure 3B ###
cov_data <- read.csv("sample_cov_all.csv", header = TRUE, stringsAsFactors = TRUE)
cov_data<-subset(cov_data,cov_data$Group!="Fort Bragg (AQ)") 

custom_order2<- c("Haida Gwaii (Hi)","Central BC (Hi)","Winter Harbor (Hi)","Ucluelet","Bamfield","Bamfield (Hi)","Fort Bragg", "Fort Bragg (Hi)","Monterey","Monterey Male","Monterey Female","Hazard Canyon","Santa Barbara","Santa Barbara (AQ)","LA (AQ)","San Diego (AQ)","San Diego (Hi)","Ensenada")
cov_data$Group <- factor(cov_data$Group, levels = custom_order2)
droplevels(cov_data$Group)
cols3 <- c("deeppink4","burlywood3","lightsalmon","hotpink2","darkorange","darkorange","lightgoldenrod2","lightgoldenrod2","olivedrab3","olivedrab3","olivedrab3","mediumseagreen","dodgerblue","dodgerblue","lightskyblue1","plum","plum","blueviolet")

fig3b<-ggplot(data = cov_data, aes(Group, av_cov, color = Group)) +
  geom_pointrange(size = 0.2, alpha=0.5,aes(ymin = av_cov - stdev, ymax = av_cov + stdev), 
                  position = position_jitter(width = 0.25)) +
  geom_hline(aes(yintercept = 5.13), linetype = "dashed", color = "black")+
  geom_text(aes(1.7, 4, label = "5.13", vjust = -1.5), colour = "black",size=3) +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        panel.border = element_rect(color = "black", fill = NA, linewidth = 1)) +
  labs(y = "Avg. Coverage", x = "") +
  scale_color_manual(values = cols3)+
  theme(legend.position = "none")

### Make Inbreeding Coefficient Plot | Figure 3C ###
#load dataframe
het <- read.csv("FINAL_R1_R2_geno0.8_mindpop0.5_hetero.csv", header=TRUE, stringsAsFactors = TRUE)

#For excluding our high coverage variation - Fort Bragg aquarium sample
het<-subset(het,het$group!="Fort Bragg (AQ)")
het$group <- factor(het$group, levels = c("Haida Gwaii (Hi)","Central BC (Hi)","Winter Harbor (Hi)","Ucluelet","Bamfield","Bamfield (Hi)","Fort Bragg","Monterey","Hazard Canyon","Santa Barbara","Santa Barbara (AQ)","LA (AQ)","San Diego (AQ)","Ensenada"))

# Calculate sample sizes
sample_sizes <- het %>%
  group_by(group) %>%
  summarise(n = n())

# Create a new column in `het` with group names and sample sizes
het <- het %>%
  left_join(sample_sizes, by = "group") %>%
  mutate(group_with_n = paste0(group, " (", n, ")"))
het <- subset(het, !is.nan(as.numeric(het$F)))

# color data again
cols3 <- c("deeppink4","burlywood3","lightsalmon","hotpink2","darkorange","darkorange","lightgoldenrod2","olivedrab3","mediumseagreen","dodgerblue","dodgerblue","lightskyblue1","plum","blueviolet")

#Plot
fig3c<-ggplot(het, aes(x = as.factor(group), y = as.numeric(F), fill = as.factor(group))) +
  geom_boxplot(outlier.size = 0.2,alpha = 0.5) +  # Reduced outlier size
  scale_fill_manual(values = cols3) +
  ylab("Inbreeding Coefficient") +
  xlab("")+
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        panel.border = element_rect(color = "black", fill = NA, linewidth = 1)) +
  guides(fill = FALSE, size = "none")


### Make Tajima and Nucleotide diversity Plots | Figure 3D,E ###
plot_metrics <- function(metric,name,label) {
  HG <- read.table(paste0("HG",metric),header=T)
  Central <- read.table(paste0("Central",metric),header=T)
  WH <- read.table(paste0("WH",metric),header=T)
  Ucluelet <- read.table(paste0("Ucluelet",metric),header=T)
  Bam <- read.table(paste0("Bam_old",metric),header=T)
  Bam_new <- read.table(paste0("Bam_new",metric),header=T)
  FBragg <- read.table(paste0("Fbragg",metric),header=T)
  FBraggA <- read.table(paste0("Noyo",metric),header=T)
  Monterey <- read.table(paste0("Monterey",metric),header=T)
  Hazard <- read.table(paste0("Hazard",metric),header=T)
  SB <- read.table(paste0("SB_new",metric),header=T)
  SB_aq <- read.table(paste0("Seacenter",metric),header=T)
  LA <- read.table(paste0("LA",metric),header=T)
  SD_aq <- read.table(paste0("SD_aq",metric),header=T)
  Baja <- read.table(paste0("Baja",metric),header=T)
  HG$Location <- 'Haida Gwaii (Hi)'
  Central$Location <- 'Central BC (Hi)'
  WH$Location <- 'Winter Harbor (Hi)'
  Ucluelet$Location <- 'Ucluelet'
  Bam$Location <- 'Bamfield (Hi)'
  Bam_new$Location <- 'Bamfield'
  FBragg$Location <- 'Fort Bragg'
  FBraggA$Location <- 'Fort Bragg (AQ)'
  Monterey$Location <- 'Monterey'
  Hazard$Location <- 'Hazard Canyon'
  SB$Location <- 'Santa Barbara'
  SB_aq$Location <- 'Santa Barbara (AQ)'
  LA$Location <- 'LA (AQ)'
  SD_aq$Location <- 'San Diego (AQ)'
  Baja$Location <- 'Ensenada'
  combined_data <- rbind(HG,Central,WH,Ucluelet,Bam_new,Bam,FBragg,Monterey,Hazard,SB,SB_aq,LA,SD_aq,Baja)
  combined_data$Location <- factor(combined_data$Location, levels = c("Haida Gwaii (Hi)","Central BC (Hi)","Winter Harbor (Hi)","Ucluelet","Bamfield","Bamfield (Hi)","Fort Bragg","Monterey","Hazard Canyon","Santa Barbara","Santa Barbara (AQ)","LA (AQ)","San Diego (AQ)","Ensenada"))
  combined_data <- subset(combined_data, !is.nan(as.numeric(combined_data[[name]])))
  cols3 <- c("deeppink4","burlywood3","lightsalmon","hotpink2","darkorange","darkorange","lightgoldenrod2","olivedrab3","mediumseagreen","dodgerblue","dodgerblue","lightskyblue1","plum","blueviolet")
  boxes<-ggplot(combined_data, aes(x = as.factor(Location), y = as.numeric(.data[[name]]), fill = as.factor(Location))) +
    geom_boxplot(outlier.size = 0.2,alpha = 0.5) +  # Reduced outlier size
    scale_fill_manual(values = cols3) +
    ylab(label) +
    xlab("Location") +
    theme_classic() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1),
          panel.border = element_rect(color = "black", fill = NA, linewidth = 1)) +
    guides(fill = FALSE, size = "none")
  return(boxes)
  }
fig3d<-plot_metrics("_tajima10kb.Tajima.D","TajimaD","Tajima D")
fig3e<-plot_metrics("_pi_10kb.windowed.pi","PI", "Nucleotide Diversity")

### Make Combined Figure ####
fig3a_grob <- as.grob(fig3a)
left <- ggdraw() +
  draw_grob(fig3a_grob) +
  draw_label("A", x = 0.03, y = 0.98, hjust = 0, size = 14,fontface = "bold") +
  draw_label("FST", x = 0.05, y = 0.78, hjust = 0, size = 12,angle=90)
left
right <- plot_grid(fig3b, fig3c, fig3d, fig3e, ncol=2, labels=c("B","C","D","E"))

all <- plot_grid(
  left, 
  NULL,  # Spacer
  right, 
  nrow = 1, 
  rel_widths = c(1, 0.12, 1)  # Middle column = 10% spacer
)

#Save
ggsave(filename = "Figure3_final.pdf", 
       plot = all, 
       width = 16, 
       height =7, 
       units = "in")
