# Complete CryoSPARC Setup Summary - April 15, 2026

**User:** Bharti Singal (bsingal@stanford.edu)  
**Cluster:** Stanford Sherlock  
**CryoSPARC Version:** v4.7.1  
**Setup Date:** April 15, 2026  
**Status:** ✅ Successfully Running

---

## What We Accomplished

### Successfully Installed and Configured:

1. ✅ **CryoSPARC v4.7.1** - Compatible with Sherlock's GLIBC 2.17
2. ✅ **Master Node** - Running on Hinshaw partition (7-day limit)
3. ✅ **5 SLURM Lanes** - For different job types and partitions
4. ✅ **9 Helper Scripts** - Automated management scripts
5. ✅ **Auto-Resubmitting Master** - Continuous operation
6. ✅ **Multi-Partition Support** - GPU, Hinshaw, Owners lanes

---

## Directory Structure

### Installation Locations

Software (Home - Fast I/O):
/home/groups/mjewett/bsingal/cryosparc/
├── software/
│   ├── cryosparc_master/
│   └── cryosparc_worker/
├── slurm_templates/
│   ├── gpu_partition.sh
│   ├── hinshaw_partition.sh
│   ├── owners_partition.sh
│   ├── motion_partition.sh
│   └── ctf_partition.sh
├── cs-master.sh
├── submit-cs-master.sh
├── stop-cs-master.sh
├── check-cs-master.sh
└── setup-lanes.sh

Data (Oak - Large Storage):
/oak/stanford/groups/mjewett/bsingal/cryosparc/
├── database/
├── projects/
├── cache/
└── backups/

ruby
Copy code

---

## Account and Partition Configuration

### Your Sherlock Access

**Primary Account:** `hinshaw`  
**QOS Access:** `normal`, `long`

### Available Partitions

| Partition | Time Limit | Account | Use Case |
|:----------|:-----------|:--------|:---------|
| `hinshaw` | 7 days | hinshaw | Master node (dedicated) |
| `normal` | 48 hours | N/A | General compute |
| `gpu` | 48 hours | N/A | GPU jobs |
| `owners` | 48 hours | hinshaw | Shared owners nodes |

---

## Scripts Created

### Main Management Scripts

1. **cs-master.sh** - Self-resubmitting master job (7 days on hinshaw partition)
2. **submit-cs-master.sh** - Submit master job
3. **stop-cs-master.sh** - Stop master gracefully
4. **check-cs-master.sh** - Check status and connection info
5. **setup-lanes.sh** - Configure all SLURM lanes

### SLURM Templates

1. **gpu_partition.sh** - GPU partition (48h)
2. **hinshaw_partition.sh** - Hinshaw dedicated (7 days)
3. **owners_partition.sh** - Owners partition (48h)
4. **motion_partition.sh** - Motion correction (48h)
5. **ctf_partition.sh** - CTF estimation (48h, 1 GPU)

---

## Master Node Setup

**Configuration:**
- Partition: hinshaw
- Account: hinshaw
- CPUs: 4
- Memory: 32 GB
- Time: 7 days
- Port: 55550
- Auto-resubmit: Every 7 days

---

## SLURM Lane Configuration

| Lane Name | Partition | Time | Use Case |
|:----------|:----------|:-----|:---------|
| gpu_lane | gpu | 48h | General GPU jobs |
| hinshaw_lane | hinshaw | 7d | Long refinements |
| owners_lane | owners | 48h | Shared owners |
| motion_lane | gpu | 48h | Patch Motion |
| ctf_lane | gpu | 48h | Patch CTF |
| default | local | N/A | Import/Export |

---

## Daily Usage

### Start Master
```bash
cd /home/groups/mjewett/bsingal/cryosparc
./submit-cs-master.sh
Check Status
bash
Copy code
./check-cs-master.sh
cat cs-master-connection.txt
Access Web Interface
bash
Copy code
# From local computer
ssh -L 55550:NODE:55550 bsingal@login.sherlock.stanford.edu
# Open: http://localhost:55550
Key Issues Resolved
✅ GLIBC 2.17 incompatibility → Used v4.7.1
✅ File descriptor limits → Used compute nodes
✅ Account access → Used hinshaw account
✅ 7-day time limit → Used hinshaw partition
✅ Sleeper job detection → Used log tailing
✅ Auto-resubmission → Implemented SIGUSR1 handler
Setup completed successfully on April 15, 2026
