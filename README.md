# Patiria miniata Population Genomics Paper
This Github contains scripts to reproduce figures for the paper: Population Genomics in P. miniata along the Pacific Coastline Reveal Subtly Diverging Genomics Along an Extensive Range Gap
To re-run anything, you'll need to navigate to the .R or .Rmd script within each folder (organized by the figures from the paper) 
You should be able to run all scripts using the files provided in each folder. Make sure to adjust your working directory accordingly and unzip any large files - there are posted at: [https://www.dropbox.com/scl/fo/z6yv7ejkynsj367s3tuu8/ACcblTvg7QoHBthy62Q8NlE?rlkey=u6hwcqk72hinsrv5yu36shdr1&st=1d9zooem&dl=0] and only relevant for the GWAS plots. 

R scripts process outputs from software run on the cluster. These were generated using bash scrips in the **Bash_scripts** folder. 

Here is a short summary of the files and scripts:
F1_Map: A simple map showing sample location, plot with **Figure1_final.R**

F2_PCA: NMDS plots using covariance matrices generated from plink/ANGSD for samples split in different ways to highlight the genetic split, range gap, and sex differences. Plot these with **Figure2_final.R**

F3_FST_metrics: Pairwise FST, coverage, Tajima's D, inbreeding coefficient, nucleotide diversity for populations with at least 8 samples. Plot with **Figure3_final.R** and toggle adding in aquarium samples (commented out) to reproduce the analogous supplemental figure. 

F4_FST_GWAS: These were plotted in the cluster, generating image files arranged in illustrator. The R scipt **outlier_loop3.R** generates the Fst plots (replace with appropriate .fst file or run in a loop to plot everything - but remember that these take a long time. If using a laptop, consider subsetting). **GWAS.R** works similarly, but for the GWAS plots. Input files are too large, but linked here **Link**

F5_Sweep: This folder contains two .Rmd scripts. **Sweep_plots_outlier_R2.Rmd** plots the top panel of Figure 5. and **Sweep_plots_zoom.Rmd** plots the bottom panel with annotations. 

F6_PSMC: This folder contains scripts to plot PSMC and betaPSMC output files (modified from PSMC [https://github.com/lh3/psmc] and bPSMC documentation [https://github.com/ChenHuaLab/Beta-PSMC]). Input files are in the corresponding subfolders for each analysis. 

F7_Admix: This folder contains scripts to plot ngsADMIX output files (modified from tutorials from the paper by Lou et al. (2021) [https://onlinelibrary.wiley.com/doi/10.1111/mec.16077].

This manuscript also includes a good bit of supplemental data - please feel free to email me for any of these scripts. If you find this useful, please consider citing the paper (in prep). If you find mistakes or have questions - please email me at vpagowski@gmail.com

