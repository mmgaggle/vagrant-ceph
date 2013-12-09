Vagrant Ceph
============

Vagrant Ceph is designed to allow developers to quickly spin up Ceph clusters.
Currently clusters can be provisioned locally using Virtual Box or in any cloud
that boasts EC2 API compatability. As a prerequisite you will need the minimum
of Virtual Box and Vagrant installed, for instructions please visit the official
Vagrant docs:

http://docs-v1.vagrantup.com/v1/docs/getting-started/index.html

Minimum Viable Cluster
======================

Once you have finished setting up Virtual Box and Vagrant you can launch your
first Ceph cluster using Vagrant Ceph. To provision a Ceph cluster using
Virtual Box on your local machine run:

VAGRANT\_CEPH\_NUM\_OSDS=2 vagrant up

The first cluster you launch will take longer boot because base boxes and
packages need to be downloaded, both are cached to speed up subsequent launches.

Launching Additional Components
===============================

If you would like to launch additional nodes in your Ceph cluster you can set
any of the following environmental variables to the string 'y'.

VAGRANT\_CEPH\_MDS
VAGRANT\_CEPH\_RGW
VAGRANT\_CEPH\_KRBD

VAGRANT\_CEPH\_NUM\_OSDS can be set to any integer between 1 and 150, representing
the number of OSDs you desire in your cluster.

Remote Cluster on Amazon EC2
============================

TODO: Add instructions for launching cluster on Amazon.

Remote Cluster on OpenStack
===========================

TODO: Add instructions for launching cluster on OpenStack.
