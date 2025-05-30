setwd("/Users/veronicapagowski/Desktop/MOLECOL/F6_PSMC/bPSMC")
source("psmc_func.R") #PSMC plotting functions from PSMC paper
library(ggplot2)
library(scales)

# Load in different population datasets
#gen=5
HG6 <- read.table("23442Pal_G6_S192_b20_combined_gen5_9.13e-9.0.txt")
HG6_df <- data.frame(ya = HG6[-1, 1] , ne = HG6[-1, 2])
HG4 <- read.table("23442Pal_G4_S191_b20_combined_gen5_9.13e-9.0.txt")
HG4_df <- data.frame(ya = HG4[-1, 1] , ne = HG4[-1, 2])
Bam <- read.table("23442Pal_B4_S190_b20_combined_gen5_9.13e-9.0.txt")
Bam_df <- data.frame(ya = Bam[-1, 1] , ne = Bam[-1, 2])
FB <- read.table("23442Pal_F3_S189_b20_combined_gen5_9.13e-9.0.txt")
FB_df <- data.frame(ya = FB[-1, 1] , ne = FB[-1, 2])
H <- read.table("23442Pal_H9_S186_b20_combined_gen5_9.13e-9.0.txt")
H_df <- data.frame(ya = H[-1, 1] , ne = H[-1, 2])
Mon <- read.table("23442Pal_M1_S188_b20_combined_gen5_9.13e-9.0.txt")
Mon_df <- data.frame(ya = Mon[-1, 1] , ne = Mon[-1, 2])
SB <- read.table("23442Pal_SB-4_S187_b20_combined_gen5_9.13e-9.0.txt")
SB_df <- data.frame(ya = SB[-1, 1] , ne = SB[-1, 2])

# Create a list to store data frames for bootstrap iterations
boot_list_HG6 <- list()
boot_list_HG4 <- list()
boot_list_Bam <- list()
boot_list_FB <- list()
boot_list_H <- list()
boot_list_Mon <- list()
boot_list_SB <- list()

#HG6
for (i in 0:35) {
  path <- paste0("23442Pal_G6_S192_b20_combined_gen5_9.13e-9.", i, ".txt")
  boot.iter <- read.table(path)
  ya <- boot.iter[-1, 1]
  ne <- boot.iter[-1, 2]
  boot_list_HG6[[i+1]] <- data.frame(ya = ya[ya > 1000], ne = ne[ya > 1000], iter = i)
}
#HG4
for (i in 0:35) {
  path <- paste0("23442Pal_G4_S191_b20_combined_gen5_9.13e-9.", i, ".txt")
  boot.iter <- read.table(path)
  ya <- boot.iter[-1, 1]
  ne <- boot.iter[-1, 2]
  boot_list_HG4[[i+1]] <- data.frame(ya = ya[ya > 1000], ne = ne[ya > 1000], iter = i)
}
#Bam
for (i in 0:35) {
  path <- paste0("23442Pal_B4_S190_b20_combined_gen5_9.13e-9.", i, ".txt")
  boot.iter <- read.table(path)
  ya <- boot.iter[-1, 1]
  ne <- boot.iter[-1, 2]
  boot_list_Bam[[i+1]] <- data.frame(ya = ya[ya > 1000], ne = ne[ya > 1000], iter = i)
}
#FB
for (i in 0:35) {
  path <- paste0("23442Pal_F3_S189_b20_combined_gen5_9.13e-9.", i, ".txt")
  boot.iter <- read.table(path)
  ya <- boot.iter[-1, 1]
  ne <- boot.iter[-1, 2]
  boot_list_FB[[i+1]] <- data.frame(ya = ya[ya > 1000], ne = ne[ya > 1000], iter = i)
}
#H
for (i in 0:35) {
  path <- paste0("23442Pal_H9_S186_b20_combined_gen5_9.13e-9.", i, ".txt")
  boot.iter <- read.table(path)
  ya <- boot.iter[-1, 1]
  ne <- boot.iter[-1, 2]
  boot_list_H[[i+1]] <- data.frame(ya = ya[ya > 1000], ne = ne[ya > 1000], iter = i)
}

#Mon
for (i in 0:35) {
  path <- paste0("23442Pal_M1_S188_b20_combined_gen5_9.13e-9.", i, ".txt")
  boot.iter <- read.table(path)
  ya <- boot.iter[-1, 1]
  ne <- boot.iter[-1, 2]
  boot_list_Mon[[i+1]] <- data.frame(ya = ya[ya > 1000], ne = ne[ya > 1000], iter = i)
}

#SB
for (i in 0:35) {
  path <- paste0("23442Pal_SB-4_S187_b20_combined_gen5_9.13e-9.", i, ".txt")
  boot.iter <- read.table(path)
  ya <- boot.iter[-1, 1]
  ne <- boot.iter[-1, 2]
  boot_list_SB[[i+1]] <- data.frame(ya = ya[ya > 1000], ne = ne[ya > 1000], iter = i)
}

# Combine all bootstrap data frames
boot_df_HG6 <- do.call(rbind, boot_list_HG6)
boot_df_HG4 <- do.call(rbind, boot_list_HG4)
boot_df_Bam <- do.call(rbind, boot_list_Bam)
boot_df_FB <- do.call(rbind, boot_list_FB)
boot_df_H <- do.call(rbind, boot_list_H)
boot_df_Mon <- do.call(rbind, boot_list_Mon)
boot_df_SB <- do.call(rbind, boot_list_SB)

combined_boot_df <- rbind(
  cbind(do.call(rbind, boot_list_HG6), Population = "Haida Gwaii 2"),
  cbind(do.call(rbind, boot_list_HG4), Population = "Haida Gwaii 1"),
  cbind(do.call(rbind, boot_list_FB), Population = "Fort Bragg"),
  cbind(do.call(rbind, boot_list_H), Population = "Hazard Canyon"),
  cbind(do.call(rbind, boot_list_Mon), Population = "Monterey"),
  cbind(do.call(rbind, boot_list_SB), Population = "Santa Barbara"),
  cbind(do.call(rbind, boot_list_Bam), Population = "Bamfield")
)


# Create the plot
custom_order<-c("Haida Gwaii 1","Haida Gwaii 2","Bamfield","Fort Bragg","Monterey","Hazard Canyon", "Santa Barbara")          
combined_boot_df$Population <- factor(combined_boot_df$Population, levels = custom_order)
cols2 <- c("deeppink4","deeppink3","darkorange","lightgoldenrod3","olivedrab3","mediumseagreen","dodgerblue")

plt_fig6b<-ggplot() +
  geom_step(data = combined_boot_df, 
            aes(x = ya*0.2, y = ne*10000, group = interaction(Population, iter), color = Population), #output scaled by default to 10^4 
            alpha = 0.3, size = 0.2) +
  geom_step(data = subset(combined_boot_df, iter == 0),
            aes(x = ya*0.2, y = ne*10000, group = Population, color=Population),
            size = 0.8,alpha = 0.5) +
  scale_color_manual(values = cols2) +
  scale_x_log10(limits = c(1200, 31623), #10^4.5
                breaks = c(1e3,10^3.5,1e4, 10^4.5), expand = c(0, 0),
                labels = trans_format("log10", math_format(10^.x))) +
  scale_y_continuous(limits = c(0, 3.5e5),  # Linear scale starting from 0
                     breaks = seq(0, 3.5e5, by = 5e4),
                     labels = label_number(scale = 1e-3)) + 
  labs(x = "Generations ago",  y = expression(N[e]~"x"~10^3), title = "") +
  theme_minimal() +
  theme_bw()

ggsave(filename = "Figure6b_PSMC_final.png", 
       plot = plt_fig6b, 
       width = 6, 
       height =5, 
       units = "in",
       dpi = 300)

saveRDS(plt_fig6b, file = "/Users/veronicapagowski/Desktop/MOLECOL/F6_PSMC/plt_fig6b.rds")

