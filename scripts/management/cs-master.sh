#!/bin/bash
#
#SBATCH --job-name=cs-master
#SBATCH --error=cs-master.err.%j
#SBATCH --output=cs-master.out.%j
#
#SBATCH --dependency=singleton
#
#SBATCH --partition=hinshaw
#SBATCH --account=hinshaw
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#
#SBATCH --time=7-00:00:00
#SBATCH --signal=B:SIGUSR1@360
#
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=bsingal@stanford.edu

# Function to handle job resubmission before timeout
_resubmit() {
    echo "================================================================"
    echo "$(date): job $SLURM_JOBID received SIGUSR1 signal"
    echo "Time limit approaching, resubmitting job..."
    echo "================================================================"
    
    cd /home/groups/mjewett/bsingal/cryosparc
    
    # Stop CryoSPARC gracefully
    date -R >> cs-master.log
    echo "Stopping CryoSPARC master..." >> cs-master.log
    ./software/cryosparc_master/bin/cryosparcm stop >> cs-master.log 2>&1
    
    # Resubmit this script
    echo "Resubmitting job..." >> cs-master.log
    sbatch $0
    
    echo "$(date): Resubmission complete" >> cs-master.log
}

# Trap SIGUSR1 signal (sent 360 seconds before time limit)
trap _resubmit SIGUSR1

# Change to CryoSPARC directory
cd /home/groups/mjewett/bsingal/cryosparc

echo "================================================================"
echo "CryoSPARC Master Job Starting"
echo "================================================================"
echo "Job ID: $SLURM_JOBID"
echo "Node: $SLURM_NODELIST"
echo "Start Time: $(date)"
echo "Partition: hinshaw (7 days)"
echo "Time Limit: 7 days (auto-resubmits weekly)"
echo "================================================================"

# Load CUDA module
module load cuda/12.8.0

# Get current hostname
CURRENT_HOST=$(hostname -f)
echo "Current hostname: $CURRENT_HOST"

# Update CryoSPARC master hostname configuration
echo "Updating master hostname to $CURRENT_HOST..."
sed -i "s/export CRYOSPARC_MASTER_HOSTNAME=.*/export CRYOSPARC_MASTER_HOSTNAME=\"${CURRENT_HOST}\"/" \
    ./software/cryosparc_master/config.sh

# Log to file
echo "" >> cs-master.log
echo "================================================================" >> cs-master.log
date -R >> cs-master.log
echo "Job $SLURM_JOBID starting on $CURRENT_HOST" >> cs-master.log
echo "Partition: hinshaw (7 days)" >> cs-master.log
echo "================================================================" >> cs-master.log

# Start CryoSPARC master
echo "Starting CryoSPARC master..."
./software/cryosparc_master/bin/cryosparcm restart >> cs-master.log 2>&1

# Wait for master to start
sleep 30

# Verify master is running
if ./software/cryosparc_master/bin/cryosparcm status > /dev/null 2>&1; then
    echo "✓ CryoSPARC master started successfully"
    ./software/cryosparc_master/bin/cryosparcm status >> cs-master.log
else
    echo "✗ ERROR: CryoSPARC master failed to start" | tee -a cs-master.log
    exit 1
fi

echo ""
echo "================================================================"
echo "CryoSPARC Web Interface Information"
echo "================================================================"
echo "Node: $CURRENT_HOST"
echo "Port: 55550"
echo ""
echo "SSH Tunnel Command (run from your local computer):"
echo "ssh -L 55550:${CURRENT_HOST}:55550 bsingal@login.sherlock.stanford.edu"
echo ""
echo "Then open browser to: http://localhost:55550"
echo "================================================================"
echo ""

# Save connection info to file
cat > cs-master-connection.txt << CONN_EOF
CryoSPARC Master Connection Information
========================================
Job ID: $SLURM_JOBID
Node: $CURRENT_HOST (hinshaw partition)
Started: $(date)

SSH Tunnel Command:
ssh -L 55550:${CURRENT_HOST}:55550 bsingal@login.sherlock.stanford.edu

Web Interface:
http://localhost:55550

Login:
Email: bsingal@stanford.edu
Password: (your password)
CONN_EOF

echo "Connection info saved to: cs-master-connection.txt"
echo ""

# Monitor CryoSPARC by tailing its log files
echo "Monitoring CryoSPARC logs..."
echo "Job will auto-resubmit 6 minutes before 7-day limit..."
echo ""

# Follow CryoSPARC logs to keep job active
tail -f ./software/cryosparc_master/run/command_core.log
