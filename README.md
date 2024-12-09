# Clusterlust Documentation

Clusterlust facilitates the deployment of Kubernetes clusters using the Kubespray Ansible collection. It provides a structured approach to setting up and managing Kubernetes environments.

## Key Components

- **Ansible Playbooks:** Automate the deployment and configuration of Kubernetes clusters.
- **Inventory Management:** Define and manage the nodes within your cluster.
- **Group Definitions:** Specify the groups and responsibilities of each node (control plane, workers, bastion).

## Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/playingfield/clusterlust.git
cd clusterlust
git checkout -b yourcluster
```

### 2. Install Dependencies

Run the included setup scripts to install Ansible in a python virtualenv, and install required collections:

```bash
source ansible.sh
./galaxy.sh
```
### 3. Configure Inventory

In the inventory directory there are several examples of different layouts for Kubernetes clusters.
If you'd like to experiment with 'dev', one master and one worker, then copy the directory and adjust IP addresses and such:

```bash
cd inventory
cp -R dev yourcluster
...
cd ..
```

Edit the `inventory/yourcluster/hosts` file to list your cluster nodes' IP addresses.
Edit the `inventory/yourcluster/group_vars/all/vars.yml` to select features in your cluster.

For detailed information, refer to the Kubespray documentation [https://kubespray.io/#/](https://kubespray.io/#/).

### 4. Manage the Cluster

Run the cluster playbook to deploy the cluster:

```bash
./cluster.yml -i inventory/mycluster/hosts --become -K
```

Run the reset playbook to delete the cluster:

```bash
./reset.yml -i inventory/mycluster/hosts --become -K
```

### Post-Deployment

After deployment, verify the cluster status:
NOTE: `~/.kube/config` is copied to all hosts for convenience. Run the cluster.yml playbook with `--skip-tags kube_config` to avoid that.

```bash
kubectl get nodes
```

### Troubleshooting
- Node Issues: Verify network connectivity and SSH access to all nodes.
```bash
ansible all -m ping -i inventory/yourcluster/hosts
```

- Deployment Failures: Check the Ansible playbook output for errors and consult the logs on the affected nodes.


## Additional Resources
