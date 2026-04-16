# CryoSPARC Daily Usage Guide

Guide for daily operations of CryoSPARC on Stanford Sherlock.

## Table of Contents

- [Starting CryoSPARC](#starting-cryosparc)
- [Accessing the Interface](#accessing-the-interface)
- [Submitting Jobs](#submitting-jobs)
- [Monitoring Jobs](#monitoring-jobs)
- [Stopping CryoSPARC](#stopping-cryosparc)
- [Best Practices](#best-practices)

---

## Starting CryoSPARC

### Check if Master is Already Running

```bash
ssh bsingal@login.sherlock.stanford.edu

cd /home/groups/mjewett/bsingal/cryosparc
./check-cs-master.sh
If running, you'll see:

yaml
Copy code
CryoSPARC Master Status: RUNNING
Job ID: 21650935
Node: sh03-11n10
Port: 55550
If not running, start it:

bash
Copy code
./submit-cs-master.sh
Wait 1-2 minutes, then check again:

bash
Copy code
./check-cs-master.sh
Accessing the Interface
Get Connection Information
bash
Copy code
cat cs-master-connection.txt
Example output:

yaml
Copy code
CryoSPARC Master Connection Information
========================================
Job ID: 21650935
Node: sh03-11n10.int (hinshaw partition)
Started: Wed Apr 15 16:13:00 PDT 2026

SSH Tunnel Command:
ssh -L 55550:sh03-11n10.int:55550 bsingal@login.sherlock.stanford.edu

Web Interface:
http://localhost:55550

Login:
Email: bsingal@stanford.edu
Password: (your password)
Create SSH Tunnel
On your local computer (laptop/desktop), open terminal:

bash
Copy code
ssh -L 55550:sh03-11n10.int:55550 bsingal@login.sherlock.stanford.edu
⚠️ Important:

Replace sh03-11n10.int with the actual node from cs-master-connection.txt
Keep this terminal window open while using CryoSPARC
Open Web Browser
Navigate to: http://localhost:55550

Login credentials:

Email: bsingal@stanford.edu
Password: Your CryoSPARC password
Submitting Jobs
Workflow Overview
Create/Open Project
Build Job
Select SLURM Lane
Configure Resources
Queue Job
Step-by-Step
1. Create or Open Project
In CryoSPARC GUI:

Click "Projects" → "New Project"
Or open existing project
2. Build Job
Click "+ New Job" or select from workspace
Choose job type (Import Movies, Motion Correction, etc.)
Configure job parameters
3. Select SLURM Lane
In job parameters, find "Queue to Lane" tab

Choose lane based on job requirements:

Job Type	Recommended Lane	Why
Long refinement (>2 days)	hinshaw_gpu	Priority, 7-day limit
Ab-initio, Refinement (<2 days)	owners_gpu	Good GPU access
Motion Correction	gpu_public or owners_gpu	Quick turnaround
Particle Extraction	cpu_normal	CPU-only, save GPUs
CTF Estimation	gpu_public	Light GPU use
4. Configure Resources
For GPU lanes:

Set "Number of GPUs to parallelize": Usually 1
Use 2-4 for large refinements
CryoSPARC auto-calculates:

CPU cores (based on job type)
RAM (based on data size)
5. Queue Job
Click "Queue Job"
Job appears in workspace with status "Queued"
Check "Event Log" tab for SLURM submission details
Monitoring Jobs
In CryoSPARC GUI
Job Status Colors:

🟦 Blue (queued): Waiting in SLURM queue
🟨 Yellow (running): Currently processing
🟩 Green (completed): Finished successfully
🟥 Red (failed): Error occurred
View Details:

Click job to see parameters
"Event Log" tab: SLURM submission details, queue status
"Outputs" tab: Results and intermediate outputs
From Command Line
Check your SLURM jobs:

bash
Copy code
squeue -u bsingal
Example output:

sql
Copy code
JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
21668956       gpu cryospar  bsingal  R    0:15:30      1 sh02-08n30
21650935   hinshaw cs-maste  bsingal  R    2:11:14      1 sh03-11n10
Check specific job:

bash
Copy code
squeue -j 21668956
View job details:

bash
Copy code
scontrol show job 21668956
Understanding Queue Status
Status	Meaning	Action
PD (None)	Just queued	Wait
PD (Priority)	Waiting for higher priority jobs	Wait or use different lane
PD (Resources)	Waiting for GPUs/nodes	Wait or try different partition
R	Running	Monitor progress in GUI
CG	Completing	Almost done
Managing Jobs
Cancel a Job
From CryoSPARC GUI:

Click job → "Kill Job" button
From command line:

bash
Copy code
# Cancel specific job
scancel 21668956

# Cancel all your jobs
scancel -u bsingal
Pause/Resume
CryoSPARC doesn't support pause/resume. Instead:

Kill job
Re-queue (will restart from last checkpoint if supported)
Clone a Job
To run same job with different parameters:

Right-click job → "Clone Job"
Modify parameters
Queue to same or different lane
Stopping CryoSPARC
Clean Shutdown
Before session ends or for maintenance:

bash
Copy code
cd /home/groups/mjewett/bsingal/cryosparc
./stop-cs-master.sh
Verify it stopped:

bash
Copy code
squeue -u bsingal  # Should not show cs-master job
Emergency Stop
If normal stop doesn't work:

bash
Copy code
# Find master job ID
squeue -u bsingal | grep cs-master

# Cancel it
scancel JOB_ID
Best Practices
Lane Selection
✅ DO:

Use hinshaw_gpu for important, long jobs (>2 days)
Use owners_gpu or gpu_public for routine processing
Use cpu_normal for particle extraction, imports
Check queue before submitting: squeue -p hinshaw
❌ DON'T:

Don't use hinshaw_gpu for quick tests (wastes priority access)
Don't queue many jobs to hinshaw simultaneously (limited nodes)
Don't use GPU lanes for CPU-only jobs
Resource Management
✅ DO:

Let CryoSPARC auto-calculate CPU/RAM
Use 1 GPU for most jobs
Monitor job efficiency in Event Log
❌ DON'T:

Don't request excessive resources "just in case"
Don't run multiple heavy jobs on hinshaw simultaneously
Don't leave completed jobs queued
Data Management
✅ DO:

Regularly clean cache: rm -rf /oak/.../cache/*
Archive completed projects to /oak/.../backups/
Delete failed/test jobs
❌ DON'T:

Don't fill up /home (software location) with data
Don't keep all intermediate results
Don't accumulate hundreds of old jobs
Session Management
✅ DO:

Check master status before starting work
Keep SSH tunnel open during session
Stop master cleanly when done (if no overnight jobs)
❌ DON'T:

Don't close tunnel while jobs are running
Don't let master run unnecessarily (wastes allocation)
Don't submit jobs then immediately log out without checking
Common Workflows
Preprocessing Workflow
Import Movies → Queue to cpu_normal
Motion Correction → Queue to gpu_public or owners_gpu
CTF Estimation → Queue to gpu_public
Particle Picking → Queue to gpu_public
Particle Extraction → Queue to cpu_normal
Reconstruction Workflow
2D Classification → Queue to owners_gpu (1 GPU)
Ab-initio → Queue to owners_gpu (1-2 GPUs)
Heterogeneous Refinement → Queue to owners_gpu (2 GPUs)
Homogeneous Refinement → Queue to hinshaw_gpu if >2 days, else owners_gpu
Local Refinement → Queue to hinshaw_gpu (long job)
Quick Test Workflow
Import subset of movies (10-20) → cpu_normal
Motion Correction → gpu_public
Quick pick → gpu_public
Fast 2D classification → gpu_public
Use gpu_public for quick turnaround testing.

Useful Commands
CryoSPARC Master
bash
Copy code
# Check status
./check-cs-master.sh

# Start
./submit-cs-master.sh

# Stop
./stop-cs-master.sh

# View connection info
cat cs-master-connection.txt

# Check master logs
tail -f cs-master.log
SLURM Monitoring
bash
Copy code
# Your jobs
squeue -u bsingal

# Specific partition
squeue -p hinshaw

# Detailed job info
scontrol show job JOB_ID

# Job history
sacct -u bsingal --starttime today

# Partition availability
sinfo -p hinshaw,owners,gpu
sh_part
Storage Management
bash
Copy code
# Check usage
du -sh /home/groups/mjewett/bsingal/cryosparc/
du -sh /oak/stanford/groups/mjewett/bsingal/cryosparc/*

# Clean cache
rm -rf /oak/stanford/groups/mjewett/bsingal/cryosparc/cache/*

# Find large directories
du -h /oak/stanford/groups/mjewett/bsingal/cryosparc/projects/ | sort -rh | head -20
Tips and Tricks
Speed Up Job Submission
Keep commonly used parameters as job templates
Clone successful jobs instead of rebuilding
Use default lane for routine work
Optimize Queue Times
Check partition availability before submitting: sh_part
If hinshaw is busy, use owners_gpu
Submit long jobs during off-peak hours (evenings/weekends)
Monitor Efficiency
Check GPU utilization in Event Log
If GPU usage is low, consider using fewer GPUs
CPU-bound jobs should use cpu_normal lane
Backup Strategy
bash
Copy code
# Weekly backup
./backup_cryosparc.sh

# Before major changes
cp -r database database.backup.$(date +%Y%m%d)
Troubleshooting
For detailed troubleshooting, see TROUBLESHOOTING.md

Quick fixes:

Can't connect: Check SSH tunnel, verify master is running
Job stuck in queue: Check squeue -u bsingal, try different lane
Job failed: Check Event Log for errors, see TROUBLESHOOTING.md
Out of space: Clean cache, archive old projects
Getting Help
CryoSPARC Guide: https://guide.cryosparc.com/
Sherlock Docs: https://www.sherlock.stanford.edu/docs/
This Repository: See TROUBLESHOOTING.md and LANE_SETUP.md
Last Updated: April 15, 2026

Maintained by: Bharti Singal (bsingal@stanford.edu)
