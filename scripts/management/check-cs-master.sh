#!/bin/bash
# Check CryoSPARC master job status

cd /home/groups/mjewett/bsingal/cryosparc

echo "================================================================"
echo "CryoSPARC Master Status"
echo "================================================================"
echo ""

# Check SLURM job
RUNNING_JOB=$(squeue -u $USER -n cs-master -h -o "%i %T %M %l %R")

if [ -z "$RUNNING_JOB" ]; then
    echo "SLURM Job: NOT RUNNING"
    echo ""
    echo "To start CryoSPARC master:"
    echo "  ./submit-cs-master.sh"
    echo ""
else
    echo "SLURM Job Status:"
    echo "┌────────────────────────────────────────────────────────────┐"
    printf "│ %-10s %-12s %-10s %-12s %-10s │\n" "Job ID" "State" "Runtime" "Time Limit" "Node"
    echo "├────────────────────────────────────────────────────────────┤"
    printf "│ %-58s │\n" "$RUNNING_JOB"
    echo "└────────────────────────────────────────────────────────────┘"
    echo ""
    
    # Show connection info if file exists
    if [ -f cs-master-connection.txt ]; then
        echo "----------------------------------------------------------------"
        cat cs-master-connection.txt
        echo "----------------------------------------------------------------"
    fi
fi

echo ""

# Check CryoSPARC process status
if [ -d ./software/cryosparc_master ]; then
    echo "CryoSPARC Process Status:"
    echo "----------------------------------------------------------------"
    if ./software/cryosparc_master/bin/cryosparcm status > /dev/null 2>&1; then
        ./software/cryosparc_master/bin/cryosparcm status | grep -E "version|running"
        echo ""
        echo "✓ CryoSPARC is running"
    else
        echo "✗ CryoSPARC is not running"
    fi
    echo "----------------------------------------------------------------"
fi

echo ""

# Show recent log entries
if [ -f cs-master.log ]; then
    echo "Recent Log Entries:"
    echo "----------------------------------------------------------------"
    tail -5 cs-master.log
    echo "----------------------------------------------------------------"
    echo ""
    echo "View full log: tail -f cs-master.log"
fi

echo ""
echo "================================================================"
echo "Quick Commands:"
echo "================================================================"
echo "Start master:  ./submit-cs-master.sh"
echo "Stop master:   ./stop-cs-master.sh"
echo "View output:   tail -f cs-master.out.*"
echo "View log:      tail -f cs-master.log"
echo "================================================================"
