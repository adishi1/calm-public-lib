Elastic Search Cluster Blueprint
=======================

Blueprint creates a 3 node Elastic search Cluster.

Requirements
------------
### Provider
- Aws 
- Azure
- Nutanix (Default)

### OS
- Ubuntu 14.04

Flows
-------
### StartService
Start the services in given order.
### StopService
Stops the services.

Usage
-----
1. Upload the blueprint to calm.
2. Create a Elastic search Cluster.
3. Change Nutanix provider in overview tab, to your existing Nutanix settings.
4. Run the deployment.

Global Variables
-----------------
CLUSTER_NAME - Name of the elastic search cluster

TODO
-----
1. Backup 
2. Restore

IMAGE
-----
<img src="http://s3.amazonaws.com/backup-calm-bucket/calm-github-images/ElasticSearchCluster.png" alt="Elastic Cluster" width="640" height="480" border="10" /></a>

![alt text](http://p5.zdassets.com/hc/settings_assets/663149/200053878/mN1xL8tNpRRq3ws1id2YiA-calm_logo_white.png "Calm.io")
