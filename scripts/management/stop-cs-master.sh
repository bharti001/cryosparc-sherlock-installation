#!/bin/bash
# Helper script to stop CryoSPARC master job

cd /home/groups/mjewett/bsingal/cryosparc

# Find running master job
RUNNING_JOB=$(squeue -u $USER -n cs-master -h -o "%i")

if [ -z "$RUNNING_JOB" ]; then
    echo "================================================================"
    echo "No CryoSPARC master job running"
    echo "================================================================"
    echo ""
    echo "To start: ./submit-cs-master.sh"
    echo ""
    exit 0
fi

echo "================================================================"
echo "Stopping CryoSPARC master"
echo "================================================================"
echo "Job ID: $RUNNING_JOB"
echo ""

# Stop CryoSPARC gracefully
echo "Stopping CryoSPARC processes..."
if [ -f ./software/cryosparc_master/bin/cryosparcm ]; then
    ./software/cryosparc_master/bin/cryosparcm stop
    sleep 5
fi

# Cancel SLURM job
echo "Cancelling SLURM job $RUNNING_JOB..."
scancel $RUNNING_JOB

sleep 2

# Verify cancellation
if squeue -j $RUNNING_JOB -h > /dev/null 2>&1; then
    echo "⚠ Job still in queue, may take a moment to cancel"
else
    echo "✓ SLURM job cancelled"
fi

echo ""
echo "✓ CryoSPARC master stopped"
echo ""
echo "To restart: ./submit-cs-master.sh"
echo "================================================================"
