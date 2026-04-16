# CryoSPARC v4.7.1 Installation Guide for Stanford Sherlock Cluster

Complete installation guide for CryoSPARC v4.7.1 on Stanford's Sherlock HPC cluster.

**Author:** Bharti Singal  
**Email:** bsingal@stanford.edu  
**Date:** April 13, 2026  
**CryoSPARC Version:** v4.7.1  
**Cluster:** Stanford Sherlock  
**License:** NONE

---

## 📋 Table of Contents

- [Overview](#overview)
- [Critical Information](#critical-information)
- [Quick Start](#quick-start)
- [Full Documentation](#full-documentation)
- [Installation Summary](#installation-summary)
- [Daily Usage](#daily-usage)
- [Slurm Scripts] (#slurm-Lanes)
- [Helper Scripts](#helper-scripts)
- [Troubleshooting](#troubleshooting)
- [Support](#support)

---

## Overview

This repository contains a **complete, tested installation guide** for CryoSPARC v4.7.1 on Stanford's Sherlock cluster. The installation was successfully completed on April 13, 2026.

### Why This Guide?

```
Sherlock runs **GLIBC 2.17**, which is incompatible with CryoSPARC v5.0.0+. This guide provides:
- ✅ Tested installation procedure for v4.7.1
- ✅ Optimized directory structure (software on /home, data on /oak)
- ✅ Multi-node flexibility for compute sessions
- ✅ Helper scripts for daily operations
- ✅ Complete troubleshooting solutions
```
---

## Critical Information

### ⚠️ GLIBC Version Compatibility

**IMPORTANT:** CryoSPARC v5.0.0+ requires GLIBC 2.28, but Sherlock uses GLIBC 2.17.

| CryoSPARC Version | GLIBC Required | Sherlock Compatible? |
|-------------------|----------------|----------------------|
| **v5.0.0+**      | **2.28+**     | ❌ **NO**           |
| **v4.7.1**       | **2.17+**     | ✅ **YES**          |
| **v4.x series**  | **2.17+**     | ✅ **YES**          |

**Verify your GLIBC version:**
```
ldd --version
```
Expected: ldd (GNU libc) 2.17
> DO NOT install CryoSPARC v5.0.0 or later until Sherlock upgrades GLIBC!

---

## Quick Start

### Prerequisites
```
  -Stanford SUNet ID with Sherlock access  
  -Access to /home/groups/mjewett/bsingal/ (software location)  
  -Access to /oak/stanford/groups/mjewett/bsingal/ (database location)  
  -Valid CryoSPARC license ID  
```
### Installation Steps
```
1. Request compute node
    ssh bsingal@login.sherlock.stanford.edu  
    sh_dev -c 4 -g 1 -t 02:00:00

2. Follow full installation guide
    See docs/INSTALLATION.md for complete instructions
```
### Access Web Interface
```
1. From your local computer:
  ssh -NfL localhost:55550:COMPUTE_NODE:55550 bsingal@sherlock.stanford.edu  

2. Open browser to:
  http://localhost:55550  
```
---

## Full Documentation
  📚 Detailed guides in the docs/ directory:  
    📘 Complete Installation Guide  
    📗 Daily Usage Guide  
    📙 Troubleshooting Guide  

---

## Installation Summary
System Specifications
  Cluster: Stanford Sherlock  
  GLIBC: 2.17  
  CUDA: 12.8.0  
  GPU: NVIDIA A30 MIG 1g.6gb (6GB)  
  CPU: 32 cores  
  RAM: 257 GB  
```
Installation Locations
  Software: /home/groups/mjewett/bsingal/cryosparc/software/  
    ├── cryosparc_master/  
    └── cryosparc_worker/  

  Data: /oak/stanford/groups/mjewett/bsingal/cryosparc/  
    ├── database/  
    ├── projects/  
    ├── cache/  
    └── backups/  

Configuration
  Port: 55550  
  License ID: XXXXX (recieved in email from Cryosparc)  
  Master: Dynamic hostname (updates per node)  
  Worker Lane: default  
```
---

## Daily Usage
```
squeue -u bsingal
```
Once master node is known from squeue, SSH tunnel from local computer  

```  
1. From your local computer:
  ssh -NfL localhost:55550:COMPUTE_NODE:55550 bsingal@sherlock.stanford.edu  

2. Open browser to:
  http://localhost:55550  
  Login:
  Email: bsingal@stanford.edu
  Password: (your password)
```
Stop CryoSPARC

```
~/stop_cryosparc.sh
```

---

## SLURM Lanes

CryoSPARC is configured with 4 SLURM lanes for flexible job submission:

### Available Lanes

| Lane Name | Partition | Max Time | QOS | GPUs | Use Case |
|-----------|-----------|----------|-----|------|----------|
| **hinshaw_gpu** | hinshaw | 7 days | long/normal | Yes | Priority access, long jobs |
| **owners_gpu** | owners | 2 days | normal | Yes | Owner pool, medium jobs |
| **gpu_public** | gpu | 2 days | auto | Yes | Public GPU access |
| **cpu_normal** | normal | 7 days | normal | No | CPU-only jobs |

### Using Lanes in CryoSPARC

1. Build your job in CryoSPARC GUI
2. Go to **"Queue to Lane"** tab
3. Select appropriate lane based on job requirements
4. Set number of GPUs (CryoSPARC auto-calculates CPU/RAM)
5. Queue the job

**See [docs/LANE_SETUP.md](docs/LANE_SETUP.md) for complete lane documentation.**

---

## Helper Scripts

| Script | Purpose |
|--------------------|----------------|
|~/start_cryosparc.sh| Start CryoSPARC |
|~/stop_cryosparc.sh | Stop CryoSPARC  |
|~/check_cryosparc.sh| Check status    | 
|~/backup_cryosparc.sh | Backup database | 

---

## Troubleshooting

  ### Common Issues:  
  #### 1. Cannot access web interface:  
    Verify CryoSPARC is running: ~/check_cryosparc.sh
    Check SSH tunnel is active
    Verify hostname: hostname -f
    
  #### 2. Account not found:
  ```
cryosparcm createuser \
  --email bsingal@stanford.edu \
  --password "YourPassword" \
  --username bsingal \
  --firstname "Bharti" \
  --lastname "Singal"
  ```

#### 3. Worker not connected:
```
cryosparcm cli "get_scheduler_targets()"
See docs/TROUBLESHOOTING.md for more solutions
```
### Storage Management

#### Check usage
```
du -sh /home/groups/mjewett/bsingal/cryosparc/
du -sh /oak/stanford/groups/mjewett/bsingal/cryosparc/
```
#### Clean cache
```
rm -rf /oak/stanford/groups/mjewett/bsingal/cryosparc/cache/*
```

### Important Notes
```
⚠️ Session Limits:
Dev sessions: 2 hours max
CryoSPARC stops when session ends
Always stop cleanly before timeout

💾 Backups:
Backup before major changes
Weekly backups recommended
Store on /oak

🔄 Version Upgrades:

Stay on v4.x until Sherlock upgrades GLIBC
When GLIBC 2.28+ available, can upgrade to v5.x
Quick Reference
```

---

### Support
  CryoSPARC: https://guide.cryosparc.com/  
  Sherlock: https://www.sherlock.stanford.edu/docs/  
  Issues: Open an issue in this repository

---

### Acknowledgments
  Stanford Research Computing (Sherlock)  
  Structura Biotechnology (CryoSPARC)  
  Jewett Lab (support and resources)

---
### Version History
  v1.0.0 (April 13, 2026) - Initial release  
  CryoSPARC v4.7.1 successfully installed
  Complete documentation
  Helper scripts configured
  Last Updated: April 13, 2026

Maintained by: Bharti Singal (bsingal@stanford.edu)
