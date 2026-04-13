# CryoSPARC v4.7.1 Installation Guide for Stanford Sherlock Cluster

Complete installation guide for CryoSPARC v4.7.1 on Stanford's Sherlock HPC cluster.

**Author:** Bharti Singal  
**Email:** bsingal@stanford.edu  
**Date:** April 13, 2026  
**CryoSPARC Version:** v4.7.1  
**Cluster:** Stanford Sherlock  
**License:** NONE

---

## 📋 Table of Contents

- [Overview](#overview)
- [Critical Information](#critical-information)
- [Quick Start](#quick-start)
- [Full Documentation](#full-documentation)
- [Installation Summary](#installation-summary)
- [Daily Usage](#daily-usage)
- [Helper Scripts](#helper-scripts)
- [Troubleshooting](#troubleshooting)
- [Support](#support)

---

## Overview

This repository contains a **complete, tested installation guide** for CryoSPARC v4.7.1 on Stanford's Sherlock cluster. The installation was successfully completed on April 13, 2026.

### Why This Guide?

Sherlock runs **GLIBC 2.17**, which is incompatible with CryoSPARC v5.0.0+. This guide provides:
- ✅ Tested installation procedure for v4.7.1
- ✅ Optimized directory structure (software on /home, data on /oak)
- ✅ Multi-node flexibility for compute sessions
- ✅ Helper scripts for daily operations
- ✅ Complete troubleshooting solutions

---

## Critical Information

### ⚠️ GLIBC Version Compatibility

**IMPORTANT:** CryoSPARC v5.0.0+ requires GLIBC 2.28, but Sherlock uses GLIBC 2.17.

| CryoSPARC Version | GLIBC Required | Sherlock Compatible? |
|-------------------|----------------|----------------------|
| **v5.0.0+**      | **2.28+**     | ❌ **NO**           |
| **v4.7.1**       | **2.17+**     | ✅ **YES**          |
| **v4.x series**  | **2.17+**     | ✅ **YES**          |

**Verify your GLIBC version:**
```bash
ldd --version
# Expected: ldd (GNU libc) 2.17
DO NOT install CryoSPARC v5.0.0 or later until Sherlock upgrades GLIBC!

---

## Quick Start

Prerequisites
Stanford SUNet ID with Sherlock access
Access to /home/groups/mjewett/bsingal/ (software location)
Access to /oak/stanford/groups/mjewett/bsingal/ (data location)
Valid CryoSPARC license ID

Installation Steps

# 1. Request compute node
ssh bsingal@login.sherlock.stanford.edu
sh_dev -c 4 -g 1 -t 02:00:00

# 2. Follow full installation guide
# See docs/INSTALLATION.md for complete instructions
Access Web Interface

# From your local computer:
ssh -L 55550:COMPUTE_NODE:55550 bsingal@login.sherlock.stanford.edu

# Open browser to:
http://localhost:55550

Full Documentation
📚 Detailed guides in the docs/ directory:
📘 Complete Installation Guide
📗 Daily Usage Guide
📙 Troubleshooting Guide

Installation Summary
System Specifications
Cluster: Stanford Sherlock
GLIBC: 2.17
CUDA: 12.8.0
GPU: NVIDIA A30 MIG 1g.6gb (6GB)
CPU: 32 cores
RAM: 257 GB
Installation Locations

Software: /home/groups/mjewett/bsingal/cryosparc/software/
├── cryosparc_master/
└── cryosparc_worker/

Data: /oak/stanford/groups/mjewett/bsingal/cryosparc/
├── database/
├── projects/
├── cache/
└── backups/
Configuration
Port: 55550
License ID: 720c036e-34e3-11f1-9a66-2bb931982fae
Master: Dynamic hostname (updates per node)
Worker Lane: default
Daily Usage
Start CryoSPARC

# Request node
sh_dev -c 4 -g 1 -t 02:00:00

# Load CUDA
module load cuda/12.8.0

# Start
~/start_cryosparc.sh
Access Interface

# SSH tunnel from local computer
ssh -L 55550:$(hostname -f):55550 bsingal@login.sherlock.stanford.edu

# Browser
http://localhost:55550
Login:

Email: bsingal@stanford.edu
Password: (your password)
Stop CryoSPARC

~/stop_cryosparc.sh

Helper Scripts
ScriptPurpose
~/start_cryosparc.sh Start CryoSPARC
~/stop_cryosparc.sh Stop CryoSPARC
~/check_cryosparc.sh Check status
~/backup_cryosparc.sh Backup database

Troubleshooting
Common Issues
Cannot access web interface:
Verify CryoSPARC is running: ~/check_cryosparc.sh
Check SSH tunnel is active
Verify hostname: hostname -f
Account not found:

cryosparcm createuser \
  --email bsingal@stanford.edu \
  --password "YourPassword" \
  --username bsingal \
  --firstname "Bharti" \
  --lastname "Singal"
Worker not connected:

cryosparcm cli "get_scheduler_targets()"
See docs/TROUBLESHOOTING.md for more solutions

Storage Management

# Check usage
du -sh /home/groups/mjewett/bsingal/cryosparc/
du -sh /oak/stanford/groups/mjewett/bsingal/cryosparc/

# Clean cache
rm -rf /oak/stanford/groups/mjewett/bsingal/cryosparc/cache/*
Important Notes
⚠️ Session Limits:

Dev sessions: 2 hours max
CryoSPARC stops when session ends
Always stop cleanly before timeout
💾 Backups:

Backup before major changes
Weekly backups recommended
Store on /oak
🔄 Version Upgrades:

Stay on v4.x until Sherlock upgrades GLIBC
When GLIBC 2.28+ available, can upgrade to v5.x
Quick Reference

# Essential commands
~/start_cryosparc.sh
~/check_cryosparc.sh
~/stop_cryosparc.sh
~/backup_cryosparc.sh

# SSH tunnel
ssh -L 55550:HOSTNAME:55550 bsingal@login.sherlock.stanford.edu

# Web access
http://localhost:55550
Support
CryoSPARC: https://guide.cryosparc.com/
Sherlock: https://www.sherlock.stanford.edu/docs/
Issues: Open an issue in this repository

Acknowledgments
Stanford Research Computing (Sherlock)
Structura Biotechnology (CryoSPARC)
Jewett Lab (support and resources)

Version History
v1.0.0 (April 13, 2026) - Initial release
CryoSPARC v4.7.1 successfully installed
Complete documentation
Helper scripts configured
Last Updated: April 13, 2026

Maintained by: Bharti Singal (bsingal@stanford.edu)
