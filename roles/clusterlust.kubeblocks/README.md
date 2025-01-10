kubeblocks
==========

A role to install kbcli to work with KubeBlocks

https://kubeblocks.io

Run Databases on Kubernetes? Run with KubeBlocks.

KubeBlocks is crafted for managing databases on Kubernetes, designed by domain experts with decades of experience.
It supports a wide range of stateful workloads, including relational databases, NoSQL, message queues.
By streamlining operations, enhancing flexibility, and offering extensions, KubeBlocks makes database management easier in cloud-native environments.

Requirements
------------

EL or Ubuntu Linux.

Role Variables
--------------

```yml
# defaults
desired_state: present  # or absent
```

Dependencies
------------
None.

Example Playbook
----------------


```yaml
    - hosts: controller
      roles:
         - role: clusterlust.kubeblocks
```
