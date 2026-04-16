# Complete CryoSPARC Setup Summary - April 15, 2026

**User:** Bharti Singal (bsingal@stanford.edu)  
**Cluster:** Stanford Sherlock  
**CryoSPARC Version:** v4.7.1  
**Setup Date:** April 15, 2026  
**Last Updated:** April 15, 2026  
**Status:** ✅ Successfully Running

---

## What We Accomplished

### Successfully Installed and Configured:

1. ✅ **CryoSPARC v4.7.1** - Compatible with Sherlock's GLIBC 2.17
2. ✅ **Master Node** - Running on Hinshaw partition (7-day limit)
3. ✅ **4 SLURM Lanes** - Multi-partition job submission with auto-resource allocation
4. ✅ **Management Scripts** - Automated master control
5. ✅ **Auto-Resubmitting Master** - Continuous operation
6. ✅ **Clean Queue Monitoring** - Shows only user jobs

---

## Directory Structure

### Installation Locations

**Software (Home - Fast I/O):**

/home/groups/mjewett/bsingal/cryosparc/
├── software/
│   ├── cryosparc_master/
│   └── cryosparc_worker/
├── slurm_templates/
│   ├── cluster_script_hinshaw_gpu.sh
│   ├── cluster_script_owners_gpu.sh
│   ├── cluster_script_gpu_public.sh
│   └── cluster_script_cpu.sh
├── cs-master.sh
├── submit-cs-master.sh
├── stop-cs-master.sh
├── check-cs-master.sh
└── setup-lanes.sh

**Data (Oak - Large Storage):**

/oak/stanford/groups/mjewett/bsingal/cryosparc/
├── database/
├── projects/
├── cache/
└── backups/

---

## Account and Partition Configuration

### Your Sherlock Access

**Primary Account:** `hinshaw`  
**QOS Access:** `normal`, `long`

### Available Partitions

| Partition | Time Limit | Account | GPUs | Use Case |
|:----------|:-----------|:--------|:-----|:---------|
| `hinshaw` | 7 days | hinshaw | 4/node | Master + priority jobs |
| `owners` | 2 days | hinshaw | Varied | Shared owners pool |
| `gpu` | 2 days | public | Varied | Public GPU access |
| `normal` | 7 days | public | No | CPU-only jobs |

---

## SLURM Lane Configuration

### Active Lanes (v2 - April 2026)

| Lane Name | Partition | QOS | Time Limit | GPUs | Use Case |
|:----------|:----------|:----|:-----------|:-----|:---------|
| **hinshaw_gpu** | hinshaw | long/normal | 7 days | Yes | Priority access, long refinements |
| **owners_gpu** | owners | normal | 2 days | Yes | Owner pool, medium jobs |
| **gpu_public** | gpu | auto | 2 days | Yes | Public GPU, general use |
| **cpu_normal** | normal | normal | 7 days | No | CPU preprocessing |

### Key Features

- ✅ **Auto-resource allocation** - CryoSPARC calculates CPU/RAM based on job type
- ✅ **Clean queue monitoring** - Shows only your jobs (not entire cluster)
- ✅ **Dynamic GPU selection** - Automatic CUDA device allocation
- ✅ **Flexible partitions** - Choose based on priority and time needs

---

## Master Node Setup

**Configuration:**
- Partition: `hinshaw`
- Account: `hinshaw`
- CPUs: 4
- Memory: 32 GB
- Time Limit: 7 days
- Port: 55550
- Auto-resubmit: Every 7 days

**Connection:**
```bash
# SSH tunnel from local computer
ssh -L 55550:sh03-11n10.int:55550 bsingal@login.sherlock.stanford.edu

# Web interface
http://localhost:55550

Daily Usage
Start Master

cd /home/groups/mjewett/bsingal/cryosparc
./submit-cs-master.sh

Check Status

./check-cs-master.sh
cat cs-master-connection.txt

Submit Jobs
Log into CryoSPARC web interface
Build job (Motion Correction, Refinement, etc.)
Select lane in "Queue to Lane" tab:
hinshaw_gpu for long jobs
owners_gpu for medium jobs
gpu_public for quick jobs
cpu_normal for CPU work
Set number of GPUs (CryoSPARC auto-calculates CPU/RAM)
Queue

Monitor Jobs

squeue -u bsingal

Key Issues Resolved
✅ GLIBC 2.17 incompatibility → Used v4.7.1

✅ File descriptor limits → Used compute nodes

✅ Account access → Used hinshaw account

✅ 7-day time limit → Used hinshaw partition

✅ Multi-partition access → Configured 4 SLURM lanes

✅ Resource management → Auto-calculation by CryoSPARC

✅ Queue clutter → Filtered to show only user jobs

✅ Memory format errors → Fixed with {{ ram_gb | int }}G

Documentation
Main README: Quick start and overview
LANE_SETUP.md: Complete SLURM lane documentation
REPOSITORY_STRUCTURE.md: File organization
Setup completed successfully on April 15, 2026

Maintained by: Bharti Singal (bsingal@stanford.edu)
