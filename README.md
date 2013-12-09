Vagrant Ceph
============

Vagrant Ceph is designed to allow developers to quickly spin up Ceph clusters.
Currently, clusters can be provisioned locally using Virtual Box or in any cloud
that boasts EC2 API compatability. As a prerequisite you will need the minimum
of Virtual Box and Vagrant installed, for installation instructions please visit
the official Vagrant docs:

http://docs-v1.vagrantup.com/v1/docs/getting-started/index.html

This Vagrantfile will initially launch a Open Source Chef server on Ubuntu
Precise. The rest of the nodes in your cluster will register with the Chef
server and use a set of Ceph cookbooks with a run\_list injected by Vagrant.

Minimum Viable Cluster
======================

Once you have finished setting up Virtual Box and Vagrant you can launch your
first Ceph cluster using Vagrant Ceph. To provision a Ceph cluster using
Virtual Box on your local machine run:

```VAGRANT_CEPH_NUM_OSDS=2 vagrant up```

The first cluster you launch will take longer boot because base boxes and
packages need to be downloaded, both are cached to speed up subsequent launches.

Launching Additional Components
===============================

If you would like to launch additional nodes in your Ceph cluster you can set
any of the following environmental variables to the string 'y'.

```
VAGRANT_CEPH_MDS
VAGRANT_CEPH_RGW
VAGRANT_CEPH_KRBD
```

```VAGRANT_CEPH_NUM_OSDS``` can be set to any integer between 1 and 150, representing
the number of OSDs you desire in your cluster.

Remote Cluster on Amazon EC2
============================

TODO: Add instructions for launching cluster on Amazon.

Remote Cluster on OpenStack
===========================

TODO: Add instructions for launching cluster on OpenStack.
