# How Kubespray Works

During the process of setting up a Kubernetes cluster, Kubespray proceeds through a sequence of orchestrated steps. These begin with initiating the first master node after provisioning the control plane machinery with Kubeadm. Subsequent steps involve increasing the number of control-plane nodes in the cluster to ensure high availability.

Kubespray manages the installation and setup of the required container runtime components: containerd, crictl, runc, and nerdctl. These are essential components within a Kubernetes ecosystem for executing and managing the containers. The playbook used downloads and unpacks the necessary binaries for execution.

Apart from configuring the two major components - the control plane and container runtime, Kubespray also operates the etcd cluster - the key-value store optimally used by Kubernetes for all the cluster data. This includes setting up and distributing certificates required for secure communication within the cluster, as well as potentially running etcd on its own dedicated nodes.

In addition, the package sets up the environment through Kubespray by preparing the installation requirements as well as the pre-installation tasks, which include validating that the Kubernetes API server is running.

Finally, it initiates the deployment of the Kubernetes applications and resources, thereby finalizing the cluster setup completion.

**Here are the overall steps that Kubespray follows, with concise descriptions:**

## Step 1: Pre-Configuration Checks and Setup

This step verifies the accessibility and readiness of all the specified host machines in the inventory and ensures that Python dependencies and necessary packages are present on all nodes.

## Step 2: Setting Up Container Runtime

This step installs and configures the container runtime, such as containerd or CRI-O, on all nodes. This is essential for running containerized applications. It also installs the necessary tools for managing the container runtime, such as crictl, runc, and nerdctl.

## Step 3: Network Plugin Installation

This step configures the network plugin (like Calico, Cilium, Flannel, or Multus) for pod-to-pod networking across the cluster. In our example, we will use Calico. Calico is a popular choice for Kubernetes networking and provides a highly scalable networking and network policy solution for connecting Kubernetes pods based on the same IP networking principles as the internet.

## Step 4: Kubernetes Components Installation

This step installs Kubernetes components including kubelet, kubeadm, and kubectl on all nodes. This is required for the rest of the cluster setup.

## Step 5: Initialization of the First Control Plane Node

This step uses kubeadm to initialize the first control plane (master) node. This process sets up the Kubernetes control plane components such as the API server, Controller Manager, and Scheduler. It then creates a token and CA certificate hash that will be used by other control plane and worker nodes to join the cluster.

## Step 6: Setting Up etcd Cluster

If using an external etcd, this step sets up the etcd cluster independently. For embedded etcd (our case), it initializes etcd on the control plane nodes. Without etcd, a Kubernetes cluster cannot function. The API server uses etcd as its backing store. If etcd is unavailable, the Kubernetes API server cannot read or write data. Therefore, it is critical to ensure that etcd is highly available and backed up regularly.

## Step 7: Joining Additional Control Plane Nodes

This step joins additional control plane nodes to the cluster using the token and CA certificate hash, expanding the high availability of the cluster. In our case, we have 3 control plane nodes.

## Step 8: Joining Worker Nodes

Worker nodes are added to the cluster in a similar manner, using kubeadm join. These nodes host the actual workloads.

## Step 9: Cluster Configuration With Addons

This step configures necessary cluster addons like CoreDNS or kube-proxy for DNS resolution and network routing. CoreDNS is a flexible, extensible DNS server, written in Golang, that can serve as an alternative to the traditional Linux DNS server, BIND. It is the default DNS server for Kubernetes and is deployed as a cluster add-on. On the other hand, kube-proxy is a network proxy that runs on each node in the cluster, implementing part of the Kubernetes Service concept.

## Step 10: Cluster Verification And Health Checks

This step verifies the operational status of the cluster, including the health of the control plane and worker nodes. Additionally, it ensures that all nodes are correctly registered and that the Kubernetes API is accessible.

## Step 11: Security Configuration

This step applies security configurations, including setting up RBAC (Role-Based Access Control) and network policies.

## Step 12: Applying Custom Configurations

Any additional custom configurations specified in the playbook (like specific Kubernetes version, network policies, storage options) are applied in this step.

## Step 13: Cluster Ready For Deployment

The cluster is now ready for deploying applications and services.
