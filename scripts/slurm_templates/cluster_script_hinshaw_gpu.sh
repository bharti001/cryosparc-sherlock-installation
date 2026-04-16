#!/usr/bin/env bash
#### cryoSPARC cluster submission script template for SLURM - Hinshaw GPU Lane
## Available variables:
## {{ run_cmd }}            - the complete command string to run the job
## {{ num_cpu }}            - the number of CPUs needed
## {{ num_gpu }}            - the number of GPUs needed
## {{ ram_gb }}             - the amount of RAM needed in GB
## {{ job_dir_abs }}        - absolute path to the job directory
## {{ project_dir_abs }}    - absolute path to the project dir
## {{ job_log_path_abs }}   - absolute path to the log file for the job
## {{ worker_bin_path }}    - absolute path to the cryosparc worker command
## {{ run_args }}           - arguments to be passed to cryosparcw run
## {{ project_uid }}        - uid of the project
## {{ job_uid }}            - uid of the job
## {{ job_creator }}        - name of the user that created the job (may contain spaces)
## {{ cryosparc_username }} - cryosparc username of the user that created the job (usually an email)
##
## Available for 'qsub' only - SLURM position variables:
## {{ job_name }}           - name of the job
## {{ cs_account }}         - SLURM account name

#SBATCH --job-name=cryosparc_{{ job_name }}_{{ project_uid }}_{{ job_uid }}
#SBATCH --partition=hinshaw
#SBATCH --qos=long
#SBATCH --account=hinshaw
#SBATCH --time=7-00:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task={{ num_cpu }}
#SBATCH --mem={{ ram_gb | int }}G
#SBATCH --gres=gpu:{{ num_gpu }}
#SBATCH --output={{ job_log_path_abs }}
#SBATCH --error={{ job_log_path_abs }}
#SBATCH --open-mode=append

available_devs=""
for devidx in $(seq 0 15);
do
    if [[ -z $(nvidia-smi -i $devidx --query-compute-apps=pid --format=csv,noheader) ]] ; then
        if [[ -z "$available_devs" ]] ; then
            available_devs=$devidx
        else
            available_devs=$available_devs,$devidx
        fi
    fi
done
export CUDA_VISIBLE_DEVICES=$available_devs

{{ run_cmd }}
