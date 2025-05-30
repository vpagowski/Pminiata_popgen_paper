setwd("/Users/veronicapagowski/Desktop/MOLECOL/F6_PSMC/bPSMC")
source("psmc_func.R") #PSMC plotting functions from PSMC paper
setwd("/Users/veronicapagowski/Desktop/MOLECOL/F6_PSMC/bPSMC_supplement")
library(ggplot2)
library(scales)

# Load in different population datasets
#gen=5
HG_18x <- read.table("24145Pal_Ba22_S67_b20_combined_gen5_9.13e-9.0.txt")
HG_18x_df <- data.frame(ya = HG_18x[-1, 1] , ne = HG_18x[-1, 2])

Central <- read.table("24145Pal_C50_S68_b20_b20_combined_gen5_9.13e-9.0.txt")
Central_df <- data.frame(ya = Central[-1, 1] , ne = Central[-1, 2])

SB_18x <- read.table("23442Pal_SB-4_S187_18X_b20_combined_gen5_9.13e-9.0.txt")
SB_18x_df <- data.frame(ya = SB_18x[-1, 1] , ne = SB_18x[-1, 2])

Baja <- read.table("24145Pal_Ba22_S67_b20_combined_gen5_9.13e-9.0.txt")
Baja_df <- data.frame(ya = Baja[-1, 1] , ne = Baja[-1, 2])

# Create a list to store data frames for bootstrap iterations
boot_list_HG_18x <- list()
boot_list_Central <- list()
boot_list_SB_18x <- list()
boot_list_Baja <- list()

#HG_18x
for (i in 0:35) {
  path <- paste0("24145Pal_Ba22_S67_b20_combined_gen5_9.13e-9.", i, ".txt")
  boot.iter <- read.table(path)
  ya <- boot.iter[-1, 1]
  ne <- boot.iter[-1, 2]
  boot_list_HG_18x[[i+1]] <- data.frame(ya = ya[ya > 1000], ne = ne[ya > 1000], iter = i)
}
#Central
for (i in 0:35) {
  path <- paste0("24145Pal_C50_S68_b20_b20_combined_gen5_9.13e-9.", i, ".txt")
  boot.iter <- read.table(path)
  ya <- boot.iter[-1, 1]
  ne <- boot.iter[-1, 2]
  boot_list_Central[[i+1]] <- data.frame(ya = ya[ya > 1000], ne = ne[ya > 1000], iter = i)
}
#SB_18X
for (i in 0:35) {
  path <- paste0("23442Pal_SB-4_S187_18X_b20_combined_gen5_9.13e-9.", i, ".txt")
  boot.iter <- read.table(path)
  ya <- boot.iter[-1, 1]
  ne <- boot.iter[-1, 2]
  boot_list_SB_18x[[i+1]] <- data.frame(ya = ya[ya > 1000], ne = ne[ya > 1000], iter = i)
}
#Baja
for (i in 0:35) {
  path <- paste0("24145Pal_Ba22_S67_b20_combined_gen5_9.13e-9.", i, ".txt")
  boot.iter <- read.table(path)
  ya <- boot.iter[-1, 1]
  ne <- boot.iter[-1, 2]
  boot_list_Baja[[i+1]] <- data.frame(ya = ya[ya > 1000], ne = ne[ya > 1000], iter = i)
}


# Combine all bootstrap data frames
boot_df_HG_18x <- do.call(rbind, boot_list_HG_18x)
boot_df_Central <- do.call(rbind, boot_list_Central)
boot_df_SB_18x <- do.call(rbind, boot_list_SB_18x)
boot_df_Baja <- do.call(rbind, boot_list_Baja)

combined_boot_df <- rbind(
  cbind(do.call(rbind, boot_list_HG_18x), Population = "Haida Gwaii 18X"),
  cbind(do.call(rbind, boot_list_Central), Population = "Central"),
  cbind(do.call(rbind, boot_list_SB_18x), Population = "Santa Barbara 18X"),
  cbind(do.call(rbind, boot_list_Baja), Population = "Ensenada")
)


# Create the plot
custom_order<-c("Haida Gwaii 18X","Central","Santa Barbara 18X","Ensenada")          
combined_boot_df$Population <- factor(combined_boot_df$Population, levels = custom_order)
cols2 <- c("deeppink4","burlywood3","dodgerblue","blueviolet")

plt_fig6_supp<-ggplot() +
  geom_step(data = combined_boot_df, 
            aes(x = ya*0.2, y = ne*10000, group = interaction(Population, iter), color = Population), #output scaled by default to 10^4 
            alpha = 0.3, size = 0.2) +
  geom_step(data = subset(combined_boot_df, iter == 0),
            aes(x = ya*0.2, y = ne*10000, group = Population, color=Population),
            size = 0.8,alpha = 0.5) +
  scale_color_manual(values = cols2) +
  scale_x_log10(limits = c(1000, 31623), #10^4.5
                breaks = c(1e3,10^3.5,1e4, 10^4.5), expand = c(0, 0),
                labels = trans_format("log10", math_format(10^.x))) +
  scale_y_continuous(limits = c(0, 8e5),  # Linear scale starting from 0
                     breaks = seq(0, 8e5, by = 1e5),
                     labels = label_number(scale = 1e-5)) + 
  labs(x = "Generations ago",  y = expression(N[e]~"x"~10^5), title = "") +
  theme_minimal() +
  theme_bw()

plt_fig6_supp
###
ggsave(filename = "Figure_bPSCM_supp_final.png", 
       plot = plt_fig6_supp, 
       width = 6, 
       height =5, 
       units = "in",
       dpi = 300)


