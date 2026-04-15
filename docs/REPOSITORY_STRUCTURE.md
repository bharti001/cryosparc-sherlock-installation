# Repository Structure

cryosparc-sherlock-installation/
├── README.md
├── docs/
│   ├── INSTALLATION.md
│   ├── USAGE.md
│   ├── TROUBLESHOOTING.md
│   ├── COMPLETE_SETUP_SUMMARY.md
│   └── REPOSITORY_STRUCTURE.md
├── scripts/
│   ├── README.md
│   ├── slurm_templates/
│   │   ├── gpu_partition.sh
│   │   ├── hinshaw_partition.sh
│   │   ├── owners_partition.sh
│   │   ├── motion_partition.sh
│   │   └── ctf_partition.sh
│   └── management/
│       ├── cs-master.sh
│       ├── submit-cs-master.sh
│       ├── stop-cs-master.sh
│       ├── check-cs-master.sh
│       └── setup-lanes.sh
└── images/

markdown
Copy code

## File Descriptions

### Documentation (docs/)

- **INSTALLATION.md** - Complete installation instructions
- **USAGE.md** - Daily usage guide
- **TROUBLESHOOTING.md** - Common problems and solutions
- **COMPLETE_SETUP_SUMMARY.md** - Setup record (April 15, 2026)
- **REPOSITORY_STRUCTURE.md** - This file

### SLURM Templates (scripts/slurm_templates/)

Job submission templates for different partitions:

- **gpu_partition.sh** - GPU partition (48h)
- **hinshaw_partition.sh** - Hinshaw dedicated (7 days)
- **owners_partition.sh** - Owners partition (48h)
- **motion_partition.sh** - Motion correction (48h)
- **ctf_partition.sh** - CTF estimation (48h, 1 GPU)

### Management Scripts (scripts/management/)

Helper scripts for CryoSPARC master:

- **cs-master.sh** - Master node SLURM job (self-resubmitting)
- **submit-cs-master.sh** - Start master
- **stop-cs-master.sh** - Stop master
- **check-cs-master.sh** - Check status
- **setup-lanes.sh** - Configure SLURM lanes

## Installation Paths

**Software:** `/home/groups/mjewett/bsingal/cryosparc/`  
**Data:** `/oak/stanford/groups/mjewett/bsingal/cryosparc/`

## Usage

### Copy scripts to CryoSPARC directory
```bash
cp scripts/management/* /home/groups/mjewett/bsingal/cryosparc/
cp -r scripts/slurm_templates /home/groups/mjewett/bsingal/cryosparc/
chmod +x /home/groups/mjewett/bsingal/cryosparc/*.sh
Start master
bash
Copy code
cd /home/groups/mjewett/bsingal/cryosparc
./submit-cs-master.sh
Configure lanes
bash
Copy code
./setup-lanes.sh
Customization
Edit paths in scripts if different from defaults:

Software location
Database location
Email address
Time limits
See individual script files for customization options.
