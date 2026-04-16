# Repository Structure

cryosparc-sherlock-installation/
├── README.md                              # Main documentation and quick start
├── docs/
│   ├── LANE_SETUP.md                     # SLURM lane configuration guide
│   ├── COMPLETE_SETUP_SUMMARY.md         # Setup record (April 15, 2026)
│   └── REPOSITORY_STRUCTURE.md           # This file
├── scripts/
│   ├── README.md                          # Scripts documentation
│   ├── slurm_templates/                   # SLURM job templates
│   │   ├── cluster_script_hinshaw_gpu.sh  # Hinshaw GPU lane (7d)
│   │   ├── cluster_script_owners_gpu.sh   # Owners GPU lane (2d)
│   │   ├── cluster_script_gpu_public.sh   # Public GPU lane (2d)
│   │   ├── cluster_script_cpu.sh          # CPU-only lane (7d)
│   │   └── [legacy templates]             # Old single-partition templates
│   └── management/                        # Master management scripts
│       ├── cs-master.sh                   # Master SLURM job (self-resubmitting)
│       ├── submit-cs-master.sh            # Start master
│       ├── stop-cs-master.sh              # Stop master
│       ├── check-cs-master.sh             # Check status
│       └── setup-lanes.sh                 # Configure SLURM lanes


## File Descriptions

### Documentation (docs/)

- **README.md** (root) - Main documentation with quick start and SLURM lanes overview
- **LANE_SETUP.md** - Complete SLURM lane configuration guide
- **COMPLETE_SETUP_SUMMARY.md** - Detailed setup record from April 15, 2026
- **REPOSITORY_STRUCTURE.md** - This file

### SLURM Templates (scripts/slurm_templates/)

#### Active Lane Templates (v2 - April 2026)

Job submission templates with auto-resource allocation:

- **cluster_script_hinshaw_gpu.sh** - Hinshaw partition (7 days, QOS long/normal, GPU)
- **cluster_script_owners_gpu.sh** - Owners partition (2 days, QOS normal, GPU)
- **cluster_script_gpu_public.sh** - GPU partition (2 days, public access, GPU)
- **cluster_script_cpu.sh** - Normal partition (7 days, CPU-only)

**Features:**
- CryoSPARC auto-calculates CPU and RAM based on job type
- Automatic GPU device selection
- Clean queue monitoring (user jobs only)
- Memory format: `{{ ram_gb | int }}G`

#### Legacy Templates (v1 - April 2026)

Original single-partition templates (kept for reference):
- `gpu_partition.sh`
- `hinshaw_partition.sh`
- `owners_partition.sh`
- `motion_partition.sh`
- `ctf_partition.sh`

### Management Scripts (scripts/management/)

Helper scripts for CryoSPARC master:

- **cs-master.sh** - Master node SLURM job (self-resubmitting every 7 days)
- **submit-cs-master.sh** - Submit master job to SLURM
- **stop-cs-master.sh** - Stop master gracefully
- **check-cs-master.sh** - Check master status and display connection info
- **setup-lanes.sh** - Configure all 4 SLURM lanes in CryoSPARC

---

## Installation Paths

**Software:** `/home/groups/mjewett/bsingal/cryosparc/software/`  
**Data:** `/oak/stanford/groups/mjewett/bsingal/cryosparc/`  
**Scripts:** Copied from this repository

---

## Usage

### Initial Setup

```bash
# 1. Copy management scripts
cp scripts/management/* /home/groups/mjewett/bsingal/cryosparc/

# 2. Copy SLURM templates
cp scripts/slurm_templates/cluster_script_*.sh /home/groups/mjewett/bsingal/cryosparc/slurm_templates/

# 3. Make executable
chmod +x /home/groups/mjewett/bsingal/cryosparc/*.sh

# 4. Start CryoSPARC
cd /home/groups/mjewett/bsingal/cryosparc
./submit-cs-master.sh

# 5. Configure Lanes
Lanes are pre-configured. To reconfigure:
./setup-lanes.sh

```

### Daily Operation

```
# Check status
./check-cs-master.sh

# Stop master
./stop-cs-master.sh

# Monitor jobs
squeue -u bsingal

```

SLURM Lane Selection
When submitting jobs in CryoSPARC GUI:

Build your job
Go to "Queue to Lane" tab
Select lane based on needs:
hinshaw_gpu - Long jobs, priority access
owners_gpu - Medium jobs, shared pool
gpu_public - Quick jobs, public access
cpu_normal - CPU preprocessing
Set number of GPUs
Queue (CryoSPARC auto-sets CPU/RAM)
Customization
To customize for different installations:

Edit paths in management scripts:

Software location
Database location
Cache paths
Edit SLURM templates:

Partition names
Account names
Time limits
QOS settings
Edit email in notification scripts

See individual script files for customization comments.

Version History
v2.0 (April 15, 2026) - SLURM lanes with auto-resource allocation
v1.0 (April 13, 2026) - Initial installation
Maintained by: Bharti Singal (bsingal@stanford.edu)

Last Updated: April 15, 2026
