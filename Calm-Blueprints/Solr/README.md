Solr Blueprint
============================

Installs the Solr on a single node. Uses oracle java 8. 

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
Creates a node installs the Solr. 

Versions
---------
* Solr -> 6.1.0
* Java -> Oracle 8

Ports to be open
-----------------
* 80 -> HTTP
* 22 -> SSH
* 8983 -> Solr

	
Usage
-----
1. Upload the blueprint to calm.
2. Create a new Solr.
3. Change Aws provider in overview tab, to your existing Aws settings.
4. Run the deployment.

Image
------

<img src="http://s3.amazonaws.com/calm-github-images/Solr.png" alt="Hadoop Master Slave Cluster" width="640" height="480" border="10" /></a>

![alt text](http://p5.zdassets.com/hc/settings_assets/663149/200053878/mN1xL8tNpRRq3ws1id2YiA-calm_logo_white.png "Calm.io")
