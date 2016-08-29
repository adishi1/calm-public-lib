Redis Master-Slave Blueprint
=======================

Blueprint creates the Redis Master-Slave nodes. 

Requirements
------------
### Provider
- Aws (Default)
- Azure
- Openstack

Global Variables
----------
- `PASSWORD` - Set the root password of the redis. Same password is replicated to master and slave.


Flows
-------
### StartService
Start the services in given order.
### StopService
Stops the services.


Usage
-----
1. Upload the blueprint to calm.
2. Create Master-Slave.
3. Change Aws provider in overview tab, to your existing Aws settings.
4. Change PASSWORD in the global variables.
5. Run the deployment.

TODO
-----
* Backup the data.
* Restore the data.


IMAGE
-----
<img src="http://s3.amazonaws.com/backup-calm-bucket/calm-github-images/RedisMaster-slave.png" alt="Elastic Cluster" width="640" height="480" border="10" /></a>

![alt text](http://p5.zdassets.com/hc/settings_assets/663149/200053878/mN1xL8tNpRRq3ws1id2YiA-calm_logo_white.png "Calm.io")
