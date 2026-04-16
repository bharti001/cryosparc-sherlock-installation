#!/usr/bin/env bash
#### cryoSPARC cluster submission script template for SLURM - CPU Lane

#SBATCH --job-name=cryosparc_{{ job_name }}_{{ project_uid }}_{{ job_uid }}
#SBATCH --partition=normal
#SBATCH --qos=normal
#SBATCH --account=hinshaw
#SBATCH --time=7-00:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task={{ num_cpu }}
#SBATCH --mem={{ ram_gb | int }}G
#SBATCH --output={{ job_log_path_abs }}
#SBATCH --error={{ job_log_path_abs }}
#SBATCH --open-mode=append

{{ run_cmd }}
