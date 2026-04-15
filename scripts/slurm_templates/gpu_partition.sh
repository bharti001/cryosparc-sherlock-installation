#!/bin/bash
#SBATCH --job-name=cs-{{ project_uid }}-{{ job_uid }}
#SBATCH --output={{ job_log_path_abs }}
#SBATCH --error={{ job_log_path_abs }}
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --ntasks={{ num_cpu }}
#SBATCH --gpus={{ num_gpu }}
#SBATCH --mem={{ (ram_gb)|int }}G
#SBATCH --time=48:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=bsingal@stanford.edu

echo "================================================================"
echo "CryoSPARC Job: {{ job_uid }}"
echo "Job ID: $SLURM_JOBID"
echo "Node: $SLURM_NODELIST"
echo "Partition: gpu"
echo "Start: $(date)"
echo "================================================================"

module load cuda/12.8.0

{{ run_cmd }}

echo "================================================================"
echo "Job finished: $(date)"
echo "================================================================"
