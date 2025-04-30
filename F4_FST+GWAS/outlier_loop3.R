library(ggplot2)
library(dplyr)
setwd("/scratch/groups/spalumbi/Veronica/Patiria_sequencing_r2/low_cov/vcf/")

# Get list of all .fst files in the current folder
#fst_files <- list.files(pattern = "\\.fst$")
#Or just run with a single file
fst_files <- "Male_Female_Mon_R2_mindpop0.5_fst.fst" 
# Loop over each file and create a plot, arrange by chromosome
for (file in fst_files) {
  Fst_com <- read.table(file, header = TRUE)
  Fst_com$CHR <- factor(Fst_com$CHR, levels = unique(Fst_com$CHR))
  Fst_com$POS <- as.numeric(Fst_com$POS)
  Fst_com <- Fst_com %>%
  arrange(CHR, POS) %>%
  group_by(CHR) %>%
  mutate(chr_len = max(POS)) %>%
  ungroup() %>%
  mutate(
    chr_offset = cumsum(c(0, chr_len[-n()])),
    x_pos = POS + chr_offset
  )
  chrom_midpoints <- Fst_com %>%
  group_by(CHR) %>%
  summarize(mid = (min(x_pos) + max(x_pos)) / 2)
  cols2 <- c("mistyrose3","plum4")
  cols2 <- rep(cols2,15)
  
  p <- ggplot(Fst_com, aes(x = as.numeric(x_pos), y = FST)) +
    geom_point(aes(color = CHR), alpha = 0.3, shape = 19, size = 0.005) +
    scale_color_manual(values = cols2) +
    scale_x_continuous(breaks = chrom_midpoints$mid, labels = chrom_midpoints$CHR, expand = c(0, 0)) +
    scale_y_continuous(limits = c(0, 1), expand = c(0, 0)) +
    theme_classic() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1),
        panel.border = element_rect(color = "black", fill = NA, linewidth = 1)) +
    guides(size = "none")+
    theme(axis.text.x = element_blank(),axis.ticks.x = element_line())+
    theme(legend.position = "none") +
    labs(y = "FST", x = "Position")

  # Save the plot to a JPEG file
  jpeg_filename <- paste0(tools::file_path_sans_ext(basename(file)), "w.jpg")
  jpeg(jpeg_filename, width = 1920, height = 1080, units = "px", res = 300)
  print(p)
  dev.off()
  Fst_com <- 0
}

