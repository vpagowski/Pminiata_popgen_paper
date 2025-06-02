In this folder you will find a master script that calls multiple submit scripts and waits for them to finish.
Adjust paths and SBATCH commands (if using SLURM) accordingly (any time you see path_to).
Run the master script to run the full pipeline and adjust parallel -j flag to set the maximum number of jobs you'd like to run
With parallel and any time you see module run - be sure to have the relevant software installed. 
