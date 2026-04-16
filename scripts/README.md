# CryoSPARC Scripts

Management and SLURM configuration scripts for CryoSPARC on Sherlock.

## Management Scripts

Located in `management/`:

| Script | Purpose |
|--------|---------|
| `submit-cs-master.sh` | Submit CryoSPARC master as SLURM job |
| `check-cs-master.sh` | Check master status and connection info |
| `stop-cs-master.sh` | Stop CryoSPARC master cleanly |
| `cs-master.sh` | Main master startup script (called by submit) |
| `setup-lanes.sh` | Configure SLURM lanes for job submission |

## SLURM Templates

Located in `slurm_templates/`:

### Active Lane Templates (v2 - April 2026)

| Template | Partition | QOS | Max Time | GPU |
|----------|-----------|-----|----------|-----|
| `cluster_script_hinshaw_gpu.sh` | hinshaw | long/normal | 7d | Yes |
| `cluster_script_owners_gpu.sh` | owners | normal | 2d | Yes |
| `cluster_script_gpu_public.sh` | gpu | auto | 2d | Yes |
| `cluster_script_cpu.sh` | normal | normal | 7d | No |

### Legacy Templates (v1 - April 2026)

Original single-partition templates (kept for reference):
- `ctf_partition.sh`
- `gpu_partition.sh`
- `hinshaw_partition.sh`
- `motion_partition.sh`
- `owners_partition.sh`

## Usage

```
### Starting CryoSPARC

cd /home/groups/mjewett/bsingal/cryosparc
./submit-cs-master.sh

### Checking Status

./check-cs-master.sh

### Stopping CryoSPARC

./stop-cs-master.sh

### Setting Up Lanes

./setup-lanes.sh

```


## Notes

-All scripts assume installation at /home/groups/mjewett/bsingal/cryosparc/
-SLURM templates use CryoSPARC variables (e.g., {{ num_cpu }}, {{ ram_gb }})
-Lane templates automatically calculate resources based on job type

For detailed lane configuration, see ../docs/LANE_SETUP.md
