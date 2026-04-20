#!/usr/bin/env bash
#### cryoSPARC cluster submission script template for SLURM - Hinshaw GPU Lane

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
#SBATCH --signal=B:USR1@300

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

# Increase heartbeat timeout for long operations
export CRYOSPARC_DEVELOP=true

{{ run_cmd }}
