# SLURM Lane Configuration Guide

Complete guide for CryoSPARC SLURM lanes on Stanford Sherlock.

## Overview

CryoSPARC is configured with 4 SLURM lanes for flexible job submission across different partitions and priorities.

## Available Lanes

### 1. hinshaw_gpu (Priority GPU)
- **Partition**: `hinshaw`
- **QOS**: `long` (jobs >48h) or `normal` (jobs <48h)
- **Account**: `hinshaw`
- **Time Limit**: 7 days maximum
- **Resources**: 4 GPUs per node (NVIDIA)
- **Use Case**: Long-running jobs with priority access to group nodes

### 2. owners_gpu (Owner Pool GPU)
- **Partition**: `owners`
- **QOS**: `normal`
- **Account**: `hinshaw`
- **Time Limit**: 2 days maximum
- **Resources**: Shared owner GPU pool
- **Use Case**: GPU jobs when hinshaw partition is busy

### 3. gpu_public (Public GPU)
- **Partition**: `gpu`
- **Account**: `hinshaw`
- **Time Limit**: 2 days maximum
- **Resources**: Public GPU nodes
- **Use Case**: General GPU computing, public access

### 4. cpu_normal (CPU Only)
- **Partition**: `normal`
- **QOS**: `normal`
- **Account**: `hinshaw`
- **Time Limit**: 7 days maximum
- **Resources**: CPU only, no GPU
- **Use Case**: CPU-intensive jobs

## Usage in CryoSPARC GUI

### Submitting Jobs

1. Build your job (Motion Correction, Particle Picking, etc.)
2. Go to "Queue to Lane" tab in job parameters
3. Select appropriate lane
4. Set "Number of GPUs to parallelize" (for GPU lanes)
5. Queue the job

### Resource Allocation

CryoSPARC automatically calculates CPU and RAM based on job type and data size. You only specify the number of GPUs.

## Monitoring Jobs

### In CryoSPARC GUI
Event log shows only YOUR jobs with clean output using qstat.

### From Command Line
Check your jobs:
squeue -u bsingal

Cancel a job:
scancel JOB_ID

## Important Notes

- **QOS long**: Requires minimum 48-hour runtime
- **Memory format**: Templates use `{{ ram_gb | int }}G` to avoid decimals
- **Automatic resources**: CryoSPARC optimizes CPU/RAM per job type

## Best Practices

1. Long jobs (>2 days) → `hinshaw_gpu` with `qos=long`
2. Short GPU jobs → `owners_gpu` or `gpu_public`
3. CPU preprocessing → `cpu_normal`
4. Let CryoSPARC manage resources automatically

## Files Location
```
Templates:
/home/groups/mjewett/bsingal/cryosparc/slurm_templates/
├── cluster_script_hinshaw_gpu.sh
├── cluster_script_owners_gpu.sh
├── cluster_script_gpu_public.sh
└── cluster_script_cpu.sh
```
---

**Maintained by**: Bharti Singal (bsingal@stanford.edu)  
**Last Updated**: April 15, 2026
