#!/bin/bash
# Setup all CryoSPARC SLURM lanes

MASTER_DIR="/home/groups/mjewett/bsingal/cryosparc/software/cryosparc_master"
TEMPLATE_DIR="/home/groups/mjewett/bsingal/cryosparc/slurm_templates"

echo "================================================================"
echo "CryoSPARC Cluster Lanes Setup"
echo "================================================================"
echo ""

# Check if CryoSPARC master is installed
if [ ! -f "$MASTER_DIR/bin/cryosparcm" ]; then
    echo "ERROR: CryoSPARC master not found at $MASTER_DIR"
    echo "Please install CryoSPARC first"
    exit 1
fi

# Check if templates exist
if [ ! -d "$TEMPLATE_DIR" ]; then
    echo "ERROR: Templates directory not found at $TEMPLATE_DIR"
    exit 1
fi

cd "$MASTER_DIR"

echo "Removing existing lanes (if any)..."
./bin/cryosparcm cluster remove gpu_lane 2>/dev/null || true
./bin/cryosparcm cluster remove hinshaw_lane 2>/dev/null || true
./bin/cryosparcm cluster remove owners_lane 2>/dev/null || true
./bin/cryosparcm cluster remove motion_lane 2>/dev/null || true
./bin/cryosparcm cluster remove ctf_lane 2>/dev/null || true

echo ""
echo "Adding new lanes..."
echo ""

# Add GPU lane
echo "1. Adding gpu_lane (GPU partition, 48 hours)..."
./bin/cryosparcm cluster new \
  --name gpu_lane \
  --title "GPU Partition (48h)" \
  --desc "Standard GPU partition, 48 hour limit" \
  --scheduler slurm \
  --script "$TEMPLATE_DIR/gpu_partition.sh"

# Add Hinshaw lane
echo "2. Adding hinshaw_lane (Hinshaw dedicated, 7 days)..."
./bin/cryosparcm cluster new \
  --name hinshaw_lane \
  --title "Hinshaw Dedicated (7 days)" \
  --desc "Hinshaw group dedicated nodes, 7 day limit" \
  --scheduler slurm \
  --script "$TEMPLATE_DIR/hinshaw_partition.sh"

# Add Owners lane
echo "3. Adding owners_lane (Owners partition, 48 hours)..."
./bin/cryosparcm cluster new \
  --name owners_lane \
  --title "Owners Partition (48h)" \
  --desc "Owners partition, 48 hour limit" \
  --scheduler slurm \
  --script "$TEMPLATE_DIR/owners_partition.sh"

# Add Motion lane
echo "4. Adding motion_lane (Patch Motion, 48 hours)..."
./bin/cryosparcm cluster new \
  --name motion_lane \
  --title "Patch Motion (48h)" \
  --desc "For motion correction jobs, 48 hour limit" \
  --scheduler slurm \
  --script "$TEMPLATE_DIR/motion_partition.sh"

# Add CTF lane
echo "5. Adding ctf_lane (Patch CTF, 48 hours)..."
./bin/cryosparcm cluster new \
  --name ctf_lane \
  --title "Patch CTF (48h)" \
  --desc "For CTF estimation jobs, 48 hour limit, 1 GPU" \
  --scheduler slurm \
  --script "$TEMPLATE_DIR/ctf_partition.sh"

echo ""
echo "================================================================"
echo "All lanes configured successfully!"
echo "================================================================"
echo ""
echo "Available lanes:"
./bin/cryosparcm cluster list

echo ""
echo "================================================================"
echo "Lane Summary:"
echo "================================================================"
echo "gpu_lane      - GPU partition (48h) - General GPU jobs"
echo "hinshaw_lane  - Hinshaw dedicated (7 days) - Long jobs, priority"
echo "owners_lane   - Owners partition (48h) - Shared owners nodes"
echo "motion_lane   - Motion correction (48h) - Patch motion jobs"
echo "ctf_lane      - CTF estimation (48h) - Patch CTF jobs"
echo "default       - Local worker (runs on master node)"
echo ""
echo "================================================================"
echo "Usage in CryoSPARC GUI:"
echo "================================================================"
echo "1. Queue a job"
echo "2. Select 'Queue to Lane' dropdown"
echo "3. Choose appropriate lane"
echo "4. Adjust resources if needed"
echo "5. Click 'Queue Job'"
echo ""
echo "Recommended lane selection:"
echo "  - Patch Motion      → motion_lane"
echo "  - Patch CTF         → ctf_lane"
echo "  - Short GPU jobs    → gpu_lane"
echo "  - Long refinements  → hinshaw_lane"
echo "  - Import/Export     → default (runs on master)"
echo ""
echo "================================================================"
