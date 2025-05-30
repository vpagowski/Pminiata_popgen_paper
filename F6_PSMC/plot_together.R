#Plot figures together
setwd("/Users/veronicapagowski/Desktop/MOLECOL/F6_PSMC/")
fig6a <- readRDS("/Users/veronicapagowski/Desktop/MOLECOL/F6_PSMC/plt_fig6a.rds")
fig6b <- readRDS("/Users/veronicapagowski/Desktop/MOLECOL/F6_PSMC/plt_fig6b.rds")
library(ggpubr)
library(ggplot2)
#Align legend
fig6a <- fig6a +
  theme(
    legend.title = element_text(size = 10),
    legend.text = element_text(size = 9),
    legend.key.size = unit(0.5, "lines")  # shrink key boxes
  )

fig6b <- fig6b +
  theme(
    legend.title = element_text(size = 10),
    legend.text = element_text(size = 9),
    legend.key.size = unit(0.5, "lines")
  )

both <- ggarrange(
  fig6a, fig6b,
  labels = c("A", "B"),
  font.label = list(face = "bold", size = 14),
  ncol = 2, nrow = 1,
  align = "hv",               
  common.legend = TRUE,
  legend = "right"
)

ggsave(filename = "Figure6_final.pdf", 
       plot = both, 
       width = 8, 
       height =5, 
       units = "in")

