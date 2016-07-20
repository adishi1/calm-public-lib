Solr Blueprint
============================

Installs Sensu-server on a single node ubuntu instance. 

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
### Create Action.
Creates a node installs the Sensu-server. 

Versions
---------
* Sensu-server -> 0.25
* Redis -> >= 1.3.14
* RabbitMq -> 3.6.0-1
* Erlang -> 1:18.2

Ports to be open
-----------------
* 80 -> HTTP
* 22 -> SSH
* 3000 -> Uchiwa
* 5671 -> RabbitMQ
* 15671 -> RabbitMQ Web Console
* 6379 -> Redis
	
Usage
-----
1. Upload the blueprint to calm.
2. Create a new SensuServer.
3. Change Aws provider in overview tab, to your existing Aws settings.
4. Run the deployment.

Image
------

<img src="http://s3.amazonaws.com/calm-github-images/Uchiwa.png" alt="Hadoop Master Slave Cluster" width="640" height="480" border="10" /></a>

![alt text](http://p5.zdassets.com/hc/settings_assets/663149/200053878/mN1xL8tNpRRq3ws1id2YiA-calm_logo_white.png "Calm.io")
