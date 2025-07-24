# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Clusterlust is an Ansible-based Kubernetes deployment system built on top of Kubespray. It provides a structured approach to deploying and managing Kubernetes clusters with custom roles for node preparation, OpenEBS storage, and KubeBlocks integration.

## Common Commands

### Environment Setup
```bash
# Setup Python virtual environment and install dependencies
source ansible.sh
./prepare.sh
```

### Cluster Management
```bash
# Deploy/manage a Kubernetes cluster
./cluster.yml -i inventory/yourcluster/hosts --become -K

# Initialize host machines before cluster deployment
./host-initialization.yml -i inventory/yourcluster/hosts --become -K

# Reset/destroy a cluster
./reset.yml -i inventory/yourcluster/hosts --become -K

# Copy kubeconfig after cluster deployment
./kube-config.yml -i inventory/yourcluster/hosts --become -K
```

### Makefile Targets
```bash
# Using Vagrant (VMware Fusion default)
make up       # Start VMs with Vagrant
make cluster  # Deploy cluster using cluster.yml
make clean    # Destroy VMs and reset Galaxy collections
make all      # Complete workflow: clean -> up -> cluster

# Enable SecureBoot for Hyper-V (Windows)
make secureboot
```

### Testing and Validation
```bash
# Test connectivity to all hosts
ansible all -m ping -i inventory/yourcluster/hosts

# Lint Ansible playbooks (if ansible-lint is installed)
ansible-lint cluster.yml
```

## Architecture

### Directory Structure
- **inventory/**: Contains environment-specific configurations (dev, test, ha, mini, hyperv)
  - Each inventory has `hosts` file, `group_vars/all/vars.yml`, and optional secrets
- **roles/**: Custom Ansible roles specific to Clusterlust
  - `clusterlust.controller`: Controller node configuration
  - `clusterlust.hosts`: /etc/hosts management
  - `clusterlust.nodepreparation`: Node initialization and sudo setup
  - `clusterlust.kbcli`: KubeBlocks CLI management
  - `clusterlust.openebs`: OpenEBS storage provider setup
- **files/**: Static files used by roles

### Core Playbooks
- **cluster.yml**: Main cluster deployment (calls Kubespray + custom post-tasks)
- **host-initialization.yml**: Prepares nodes before Kubernetes installation
- **reset.yml**: Tears down Kubernetes cluster
- **kube-config.yml**: Copies kubeconfig to controller and specified users
- **kubeblocks.yml**: Installs KubeBlocks for database management
- **openebs.yml**: Deploys OpenEBS storage classes and operators

### Key Dependencies
- **Kubespray v2.25.1**: Main Kubernetes deployment engine
- **Ansible Collections**: kubernetes.core, ansible.posix, community.docker
- **Python Requirements**: ansible-core, kubernetes, molecule, pre-commit, etc.

### Inventory Configuration
Each inventory environment should have:
- `hosts`: Ansible inventory file with node IP addresses and groups
- `group_vars/all/vars.yml`: Environment-specific variables (timezone, proxies, etc.)
- Optional `secrets` file for sensitive configurations
- Group definitions: `kube_control_plane`, `kube_node`, `etcd`, `k8s_cluster`

### Testing Approach
- Uses Molecule for role testing with Vagrant provider
- Default test inventory points to `inventory/test/hosts`
- SSH key checking disabled for development environments
- Vagrant integration for local development and testing

## Environment Variables
- `VAGRANT_DEFAULT_PROVIDER`: Set to vmware_fusion by default
- `STAGE`: Can be set to 'dev' or 'test' for Vagrant environments

## Important Notes
- Requires sudo/become privileges for most operations
- SSH connectivity to all target nodes is required
- Default ansible.cfg points to test inventory
- Host key checking is disabled for ephemeral Vagrant environments
- Supports proxy configuration through group variables
