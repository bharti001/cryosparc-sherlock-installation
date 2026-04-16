#!/usr/bin/env bash
#### cryoSPARC cluster submission script template for SLURM - GPU Public Lane

#SBATCH --job-name=cryosparc_{{ job_name }}_{{ project_uid }}_{{ job_uid }}
#SBATCH --partition=gpu
#SBATCH --account=hinshaw
#SBATCH --time=2-00:00:00
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
