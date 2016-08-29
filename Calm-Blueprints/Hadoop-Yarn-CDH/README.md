Hadoop Master-Slave
=======================

Blueprint creates single master(Namenode) and single slave(Datanode) on Ubuntu 14.04. Using cdh package manager.


Versions
--------
Hadoop - 2.6.0
CDH - 5.7.0

Requirements
------------
### Provider
- Aws (Default)
- Azure
- Openstack

Global Variables
----------
- `master_public_dns_name` - Specify the master node's public DNS Name.

Packages
--------

Master node will have following packages installed.

* Name node
* Zookeeper
* Resource Manager
* Hadoop-client

Slave node will have following packages installed.

* yarn-nodemanager
* hdfs-datanode
* hadoop-mapreduce


Flows
-------
### StartService
Start the services in given order.
### StopService
Stops the services.
### ScaleUp
Scales Up the instance by given number of nodes.
### ScaleDown
Scales Down the instance by given number of nodes. 

Usage
-----
1. Upload the blueprint to calm.
2. Change Aws provider in overview tab, to your existing Aws settings.
3. Change the credentials like username password and private key and public key.
4. Change the node names accordingly.
5. Set the number of slave node as array.


Image
-----

<img src="http://s3.amazonaws.com/backup-calm-bucket/calm-github-images/hadoop-master-slave.png" alt="Hadoop Master Slave Cluster" width="640" height="480" border="10" /></a>

![alt text](http://p5.zdassets.com/hc/settings_assets/663149/200053878/mN1xL8tNpRRq3ws1id2YiA-calm_logo_white.png "Calm.io")
