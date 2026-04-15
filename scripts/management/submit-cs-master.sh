#!/bin/bash
# Helper script to submit CryoSPARC master job

cd /home/groups/mjewett/bsingal/cryosparc

# Check if master job is already running
RUNNING_JOB=$(squeue -u $USER -n cs-master -h -o "%i")

if [ -n "$RUNNING_JOB" ]; then
    echo "================================================================"
    echo "CryoSPARC master job already running!"
    echo "Job ID: $RUNNING_JOB"
    echo "================================================================"
    echo ""
    scontrol show job $RUNNING_JOB
    echo ""
    echo "To view connection info: cat cs-master-connection.txt"
    echo "To cancel: scancel $RUNNING_JOB"
    echo ""
    exit 0
fi

# Submit new job
echo "================================================================"
echo "Submitting CryoSPARC master job..."
echo "================================================================"

JOB_ID=$(sbatch cs-master.sh | awk '{print $NF}')

echo ""
echo "✓ CryoSPARC master job submitted!"
echo "Job ID: $JOB_ID"
echo ""
echo "================================================================"
echo "Monitor Commands:"
echo "================================================================"
echo ""
echo "Check job status:"
echo "  squeue -j $JOB_ID"
echo ""
echo "View live output:"
echo "  tail -f cs-master.out.$JOB_ID"
echo ""
echo "View CryoSPARC log:"
echo "  tail -f cs-master.log"
echo ""
echo "Check connection info (after job starts):"
echo "  cat cs-master-connection.txt"
echo ""
echo "Check status:"
echo "  ./check-cs-master.sh"
echo ""
echo "================================================================"
