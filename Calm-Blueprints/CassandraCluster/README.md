Cassandra Cluster Blueprint
=======================

Blueprint creates Cassandra Cluster with 3 node cluster.

Requirements
------------
### Provider
- Aws (Default)
- Azure
- Openstack

### OS
- Ubuntu 14.04

Flows
-------
### StartService
Start the services in given order.
### StopService
Stops the services.
### RestartService
Restart the service.
### Scale Up.
Scales up the cluster by number 1.
### Scale Down.
Scales down the cluster by number 1.


Usage
-----
1. Upload the blueprint to Calm.
2. Change Aws provider in overview tab, to your existing Aws settings.
3. Run the deployment.


Output
------
1.Spins 3 node Cassandra Cluster.


TODO
-----
1. Restore needs to be done.

OUTPUT
------
Brings up 3 node cassandra cluster.

Image
------

<img src="http://s3.amazonaws.com/backup-calm-bucket/calm-github-images/Cassandra.png" alt="Cassandra Cluster" width="640" height="480" border="10" /></a>

![alt text](http://p5.zdassets.com/hc/settings_assets/663149/200053878/mN1xL8tNpRRq3ws1id2YiA-calm_logo_white.png "Calm.io")
