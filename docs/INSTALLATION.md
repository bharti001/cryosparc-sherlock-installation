# CryoSPARC v4.7.1 Installation Guide for Sherlock

Complete step-by-step installation guide for CryoSPARC v4.7.1 on Stanford's Sherlock cluster.

## Prerequisites

### Required Access

- Stanford SUNet ID with Sherlock access
- Access to `/home/groups/mjewett/bsingal/` (software storage)
- Access to `/oak/stanford/groups/mjewett/bsingal/` (data storage)
- Valid CryoSPARC license ID (obtain from https://cryosparc.com/)

### System Requirements

- **GLIBC**: 2.17 (Sherlock's version)
- **CryoSPARC Version**: v4.7.1 (NOT v5.x - incompatible with GLIBC 2.17)
- **CUDA**: 12.8.0 (available on Sherlock)
- **Python**: Included with CryoSPARC

---

## Step 1: Verify System Compatibility

### Check GLIBC Version

```bash
ssh bsingal@login.sherlock.stanford.edu
ldd --version
Expected output:

scss
Copy code
ldd (GNU libc) 2.17
⚠️ CRITICAL: If GLIBC is 2.17, you MUST use CryoSPARC v4.7.1 or earlier. Do NOT install v5.x!

Check Available Partitions
bash
Copy code
sh_part
sacctmgr show assoc where user=$USER
Verify you have access to:

hinshaw partition
owners partition
gpu partition
normal partition
Step 2: Request Compute Node
CryoSPARC installation requires a compute node (not login node).

bash
Copy code
# Request 2-hour interactive session
sh_dev -c 4 -g 1 -t 02:00:00
Wait for node allocation. Once on compute node:

bash
Copy code
# Verify you're on compute node
hostname  # Should show something like sh02-08n30

# Load CUDA
module load cuda/12.8.0
Step 3: Create Directory Structure
Software Directory (on /home - fast I/O)
bash
Copy code
mkdir -p /home/groups/mjewett/bsingal/cryosparc/software
cd /home/groups/mjewett/bsingal/cryosparc/software
Data Directory (on /oak - large storage)
bash
Copy code
mkdir -p /oak/stanford/groups/mjewett/bsingal/cryosparc/{database,projects,cache,backups}
Step 4: Download CryoSPARC v4.7.1
bash
Copy code
cd /home/groups/mjewett/bsingal/cryosparc/software

# Download master and worker (replace with actual v4.7.1 download links)
curl -L https://get.cryosparc.com/download/master-latest/LICENSE_ID > cryosparc_master.tar.gz
curl -L https://get.cryosparc.com/download/worker-latest/LICENSE_ID > cryosparc_worker.tar.gz
⚠️ Replace LICENSE_ID with your actual CryoSPARC license ID.

Note: If v4.7.1 is not available at "latest", contact CryoSPARC support for archive access.

Step 5: Extract and Install
Extract Archives
bash
Copy code
tar -xzf cryosparc_master.tar.gz
tar -xzf cryosparc_worker.tar.gz
Install Master
bash
Copy code
cd cryosparc_master

./install.sh \
  --standalone \
  --license LICENSE_ID \
  --hostname $(hostname -f) \
  --port 55550 \
  --dbpath /oak/stanford/groups/mjewett/bsingal/cryosparc/database
⚠️ Replace LICENSE_ID with your actual license.

Wait for installation to complete (10-15 minutes).

Install Worker
bash
Copy code
cd ../cryosparc_worker

./install.sh \
  --license LICENSE_ID \
  --cudapath /share/software/user/open/cuda/12.8.0
Step 6: Connect Worker to Master
bash
Copy code
cd /home/groups/mjewett/bsingal/cryosparc/software/cryosparc_worker

./bin/cryosparcw connect \
  --worker $(hostname -f) \
  --master $(hostname -f) \
  --port 55550 \
  --ssdpath /oak/stanford/groups/mjewett/bsingal/cryosparc/cache
Step 7: Create User Account
bash
Copy code
cd /home/groups/mjewett/bsingal/cryosparc/software/cryosparc_master

./bin/cryosparcm createuser \
  --email bsingal@stanford.edu \
  --password "ChooseSecurePassword" \
  --username bsingal \
  --firstname "Bharti" \
  --lastname "Singal"
Step 8: Configure SLURM Master Job
Create Master Script
Copy from this repository:

bash
Copy code
cd /home/groups/mjewett/bsingal/cryosparc
cp /path/to/repo/scripts/management/cs-master.sh .
cp /path/to/repo/scripts/management/submit-cs-master.sh .
cp /path/to/repo/scripts/management/stop-cs-master.sh .
cp /path/to/repo/scripts/management/check-cs-master.sh .
chmod +x *.sh
Submit Master Job
bash
Copy code
./submit-cs-master.sh
Check it's running:

bash
Copy code
./check-cs-master.sh
Step 9: Configure SLURM Lanes
Copy Templates
bash
Copy code
mkdir -p /home/groups/mjewett/bsingal/cryosparc/slurm_templates

cp /path/to/repo/scripts/slurm_templates/cluster_script_*.sh \
   /home/groups/mjewett/bsingal/cryosparc/slurm_templates/
Register Lanes
bash
Copy code
cd /home/groups/mjewett/bsingal/cryosparc
cp /path/to/repo/scripts/management/setup-lanes.sh .
./setup-lanes.sh
Verify lanes are registered:

bash
Copy code
./software/cryosparc_master/bin/cryosparcm cli "get_scheduler_lanes()"
Should show: hinshaw_gpu, owners_gpu, gpu_public, cpu_normal

Step 10: Access Web Interface
From Your Local Computer
bash
Copy code
# Get connection info
cat /home/groups/mjewett/bsingal/cryosparc/cs-master-connection.txt

# Create SSH tunnel (use node and port from above file)
ssh -L 55550:sh03-11n10.int:55550 bsingal@login.sherlock.stanford.edu
Open Browser
Navigate to: http://localhost:55550

Login:

Email: bsingal@stanford.edu
Password: (what you set in Step 7)
Step 11: Test Installation
Import Test Data
In CryoSPARC GUI, create new project
Add "Import Movies" job
Point to test movies (or use sample data)
Queue to gpu_public lane
Run job
Monitor Job
bash
Copy code
# Check SLURM queue
squeue -u bsingal

# Watch job log in CryoSPARC GUI
Post-Installation
Create Backup Script
bash
Copy code
nano ~/backup_cryosparc.sh
Add:

bash
Copy code
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
cp -r /oak/stanford/groups/mjewett/bsingal/cryosparc/database \
      /oak/stanford/groups/mjewett/bsingal/cryosparc/backups/db_${DATE}
echo "Backup created: db_${DATE}"
Make executable:

bash
Copy code
chmod +x ~/backup_cryosparc.sh
Schedule Regular Backups
Add to crontab or run manually weekly.

Verification Checklist
 GLIBC version is 2.17
 CryoSPARC v4.7.1 installed (NOT v5.x)
 Master node running on hinshaw partition
 4 SLURM lanes configured and visible in GUI
 Can access web interface via SSH tunnel
 User account created and can log in
 Test job runs successfully
 Database is on /oak
 Software is on /home
 Backup strategy in place
Troubleshooting Installation
Master Won't Start
Check logs:

bash
Copy code
cat /home/groups/mjewett/bsingal/cryosparc/cs-master.log
cat /home/groups/mjewett/bsingal/cryosparc/cs-master.err.*
Worker Connection Failed
Verify paths and ports:

bash
Copy code
./bin/cryosparcw connect --help
Can't Access GUI
Verify SSH tunnel is active
Check master is running: ./check-cs-master.sh
Try different browser
See TROUBLESHOOTING.md for detailed solutions.

Next Steps
Read USAGE.md for daily operations
Review LANE_SETUP.md for lane details
Explore CryoSPARC documentation: https://guide.cryosparc.com/
Installation completed! 🎉

Installed by: Bharti Singal

Date: April 13, 2026

Last Updated: April 15, 2026
