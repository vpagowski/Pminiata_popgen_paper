#setwd("/Users/veronicapagowski/Desktop/Patiria_popgen/GWAS")
setwd("/scratch/groups/spalumbi/Veronica/Patiria_sequencing_r2/low_cov/vcf/")
library(ggplot2)
library(dplyr)
library(qqman)
file<-"corrected_GWAS_JustSouth.qassoc"
assoc <- read.table("corrected_GWAS_JustSouth.qassoc", header = TRUE)
assoc <- assoc[!is.na(assoc$P), ]
assoc2 <-subset(assoc,assoc$P< 0.01)
assoc2$CHR <- factor(assoc2$CHR, levels = unique(assoc2$CHR))
assoc2$BP <- as.numeric(assoc2$BP)
assoc2 <- assoc2 %>%
  arrange(CHR, BP) %>%
  group_by(CHR) %>%
  mutate(chr_len = max(BP)) %>%
  ungroup() %>%
  mutate(
    chr_offset = cumsum(c(0, chr_len[-n()])),
    x_pos = BP + chr_offset)
chrom_midpoints <- assoc2 %>%
  group_by(CHR) %>%
  summarize(mid = (min(x_pos) + max(x_pos)) / 2)

#cols2 <- c("mistyrose3","plum4")
cols2 <- c("grey", "cadetblue")
cols2 <- rep(cols2,15)

p <- ggplot(assoc2, aes(x = as.numeric(x_pos), y = -log10(P))) +
  geom_point(aes(color = CHR), alpha = 0.3, shape = 19, size = 0.005) +
  geom_hline(yintercept = 8.3, color = "black", linetype = "dashed",linewidth = 0.3) +
  scale_color_manual(values = cols2) +
  scale_x_continuous(breaks = chrom_midpoints$mid, labels = chrom_midpoints$CHR, expand = c(0, 0)) +
  scale_y_continuous( expand = c(0, 0)) +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        panel.border = element_rect(color = "black", fill = NA, linewidth = 1)) +
  guides(size = "none")+
  theme(axis.text.x = element_blank(),axis.ticks.x = element_line())+
  theme(legend.position = "none") +
  labs(y = "-log10(P)", x = "Position")

jpeg_filename <- paste0(tools::file_path_sans_ext(basename(file)), "gwas.jpg")
jpeg(jpeg_filename, width = 1920, height = 1080, units = "px", res = 300)
print(p)
dev.off()

