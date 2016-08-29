# Mysql Replica cluster Blueprint

This blueprint creates 3 instances and configures mysql replication.

## Infra
 1. AWS
 2. Azure
 3. Openstack

##OS
 1. Ubuntu 

## Quick Start
 1. Upload the blueprint to calm
 2. Change AWS provider in overview tab
 3. Change credential `MYSQL`, under `Credentials` tab
 4. Deploy the blueprint

This uses chef-solo to install and configure mysql replication.

Global Variables
-----------------
1.Username 'root'
2.Password 'Pass@word1'

OUTPUT
------
Creates the 3 instances with mysql-server and client with replication configured.


Image
------

<img src="http://s3.amazonaws.com/backup-calm-bucket/calm-github-images/MysqlMaster-Slave.png" alt="Cassandra Cluster" width="640" height="480" border="10" /></a>

![alt text](http://p5.zdassets.com/hc/settings_assets/663149/200053878/mN1xL8tNpRRq3ws1id2YiA-calm_logo_white.png "Calm.io")
