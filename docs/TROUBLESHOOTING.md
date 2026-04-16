# CryoSPARC Troubleshooting Guide

Common issues and solutions for CryoSPARC on Stanford Sherlock.

## Table of Contents

- [Master Node Issues](#master-node-issues)
- [Job Submission Issues](#job-submission-issues)
- [Connection Issues](#connection-issues)
- [SLURM Lane Issues](#slurm-lane-issues)
- [Storage Issues](#storage-issues)
- [Performance Issues](#performance-issues)

---

## Master Node Issues

### Master Not Running

**Check status:**
```bash
cd /home/groups/mjewett/bsingal/cryosparc
./check-cs-master.sh
Check SLURM job:

bash
Copy code
squeue -u bsingal
If not running, restart:

bash
Copy code
./submit-cs-master.sh
Master Job Stuck in Queue
Check queue reason:

bash
Copy code
squeue -u bsingal -o "%.18i %.9P %.50j %.8u %.2t %.10M %.6D %R"
Common reasons:

(Priority) - Other jobs ahead, wait
(Resources) - No nodes available, wait or use different partition
(QOSMaxWallDurationPerJobLimit) - Time limit exceeded
Master Keeps Restarting
Check logs:

bash
Copy code
cat cs-master.err.*
cat cs-master.log
Common causes:

Port already in use
Database corruption
Out of memory
Fix port conflict:
Edit cs-master.sh and change port to different number (e.g., 55551)

Job Submission Issues
Invalid QOS Specification
Error:

vbnet
Copy code
sbatch: error: Batch job submission failed: Invalid qos specification
Solution:
Check available QOS:

bash
Copy code
sacctmgr show qos
sacctmgr show assoc where user=$USER
Use normal QOS for most jobs. Only use long for jobs >48 hours.

Invalid Memory Specification
Error:

lua
Copy code
sbatch: error: Invalid --mem specification
Solution:
Template must use {{ ram_gb | int }}G not {{ ram_gb }}G

Check template:

bash
Copy code
grep "mem=" /home/groups/mjewett/bsingal/cryosparc/slurm_templates/cluster_script_*.sh
Should show: #SBATCH --mem={{ ram_gb | int }}G

Requested Node Configuration Not Available
Error:

vbnet
Copy code
sbatch: error: Batch job submission failed: Requested node configuration is not available
Solutions:

Check partition has GPUs:
bash
Copy code
sinfo -p PARTITION_NAME -o "%P %G %N"
Try different partition:
If hinshaw is full → try owners_gpu lane
If owners is full → try gpu_public lane
Check GPU specification:
bash
Copy code
sinfo -p gpu -o "%P %G"
Jobs Stuck in Pending
Check status:

bash
Copy code
squeue -u bsingal
Common reasons:

(Priority) - Lower priority, will run eventually
(Resources) - Waiting for GPUs/nodes
(QOSMaxWallDurationPerJobLimit) - Time limit too long
Solutions:

Wait for resources
Use different lane with lower demand
Reduce time limit if possible
Connection Issues
Cannot Access Web Interface
1. Check master is running:

bash
Copy code
./check-cs-master.sh
cat cs-master-connection.txt
2. Check SSH tunnel:

On your local computer:

bash
Copy code
# Check if tunnel is active
ps aux | grep "ssh -L"

# If not, create new tunnel (use correct node from cs-master-connection.txt)
ssh -L 55550:sh03-11n10.int:55550 bsingal@login.sherlock.stanford.edu
3. Check browser:

Go to http://localhost:55550 (not https)
Clear browser cache
Try different browser
4. Verify port:

bash
Copy code
# On Sherlock, check what port master is using
cat cs-master-connection.txt
Account Not Found
Create user:

bash
Copy code
cd /home/groups/mjewett/bsingal/cryosparc/software/cryosparc_master

./bin/cryosparcm createuser \
  --email bsingal@stanford.edu \
  --password "YourPassword" \
  --username bsingal \
  --firstname "Bharti" \
  --lastname "Singal"
Worker Not Connected
Check scheduler targets:

bash
Copy code
cd /home/groups/mjewett/bsingal/cryosparc/software/cryosparc_master
./bin/cryosparcm cli "get_scheduler_targets()"
Should show lanes, if missing:

bash
Copy code
cd /home/groups/mjewett/bsingal/cryosparc
./setup-lanes.sh
SLURM Lane Issues
Lane Not Appearing in GUI
List registered lanes:

bash
Copy code
cd /home/groups/mjewett/bsingal/cryosparc/software/cryosparc_master
./bin/cryosparcm cli "get_scheduler_lanes()"
If lane missing, re-register:

bash
Copy code
cd /home/groups/mjewett/bsingal/cryosparc
./setup-lanes.sh
Wrong Partition Being Used
Check lane configuration:

bash
Copy code
./bin/cryosparcm cli "get_scheduler_lanes()"
Re-register lane with correct settings (see docs/LANE_SETUP.md)

Queue Shows All Users' Jobs
Problem: Event log shows hundreds of jobs from other users

Solution: Lane was registered with old qstat_cmd_tpl

Fix:

Remove lane: ./bin/cryosparcm cluster remove LANE_NAME
Re-register with: "qstat_cmd_tpl": "squeue -u bsingal -j {{ job_id_list }}"
Storage Issues
Out of Space on /home
Check usage:

bash
Copy code
du -sh /home/groups/mjewett/bsingal/cryosparc/
Clean up:

bash
Copy code
# Remove old logs
rm -f /home/groups/mjewett/bsingal/cryosparc/cs-master.out.*
rm -f /home/groups/mjewett/bsingal/cryosparc/cs-master.err.*

# Keep only latest logs
ls -lt cs-master.out.* | tail -n +5 | awk '{print \$9}' | xargs rm -f
Out of Space on /oak
Check usage:

bash
Copy code
du -sh /oak/stanford/groups/mjewett/bsingal/cryosparc/*
Clean cache:

bash
Copy code
rm -rf /oak/stanford/groups/mjewett/bsingal/cryosparc/cache/*
Archive old projects:

bash
Copy code
# Move to backup location
mv /oak/stanford/groups/mjewett/bsingal/cryosparc/projects/OLD_PROJECT \
   /oak/stanford/groups/mjewett/bsingal/cryosparc/backups/
Database Corruption
Symptoms:

Master won't start
"Database error" messages
Solution - Restore from backup:

bash
Copy code
cd /oak/stanford/groups/mjewett/bsingal/cryosparc

# Stop master
/home/groups/mjewett/bsingal/cryosparc/stop-cs-master.sh

# Restore database
rm -rf database/*
cp -r backups/LATEST_BACKUP/* database/

# Restart
/home/groups/mjewett/bsingal/cryosparc/submit-cs-master.sh
Performance Issues
Jobs Running Slowly
Check node resources:

bash
Copy code
# While job is running, find the node
squeue -u bsingal

# SSH to compute node
ssh NODE_NAME

# Check GPU usage
nvidia-smi

# Check CPU/memory
htop
Common causes:

Sharing GPU with other jobs
Insufficient memory
I/O bottleneck
Solutions:

Use hinshaw_gpu lane for dedicated resources
Increase memory allocation
Check network storage performance
GPU Not Being Used
Check in job:

bash
Copy code
# On compute node
nvidia-smi
Should show CryoSPARC process using GPU

If not:

Check CUDA_VISIBLE_DEVICES is set
Verify GPU is requested in SLURM script
Check CryoSPARC job is GPU-enabled
Getting Help
Check Logs
Master logs:

bash
Copy code
tail -f /home/groups/mjewett/bsingal/cryosparc/cs-master.log
Job logs:

bash
Copy code
# Find in CryoSPARC GUI under job directory
# Or:
tail -f /oak/stanford/groups/mjewett/bsingal/cryosparc/projects/PROJECT/JOB/job.log
SLURM logs:

bash
Copy code
# Check job output
cat slurm-JOBID.out
Useful Commands
bash
Copy code
# Check all your jobs
squeue -u bsingal

# Check specific partition
sinfo -p hinshaw

# Check partition availability
sh_part

# Check account associations
sacctmgr show assoc where user=$USER

# Check QOS options
sacctmgr show qos

# Kill all your jobs
scancel -u bsingal

# Kill specific job
scancel JOBID
Resources
CryoSPARC Guide: https://guide.cryosparc.com/
Sherlock Docs: https://www.sherlock.stanford.edu/docs/
SLURM Documentation: https://slurm.schedmd.com/
This Repository: Issues tab on GitHub
Last Updated: April 15, 2026

Maintained by: Bharti Singal (bsingal@stanford.edu)
