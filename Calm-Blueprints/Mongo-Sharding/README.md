MongoSharding Blueprint
=======================

Blueprint creates a basic mongo shard. By default this blueprint creates 9 (3 Config + 6 Data) nodes.

Requirements
------------
### Provider
- Aws (Default)
- Azure
- Openstack

Version
--------
- Mongo DB version 3.2.3
- Ubuntu 14.04 Server Edition.

Global Variables
----------
- `NO_OF_REPLICASETS` - Number of replicaset required. Ex 3 (It creates 3 node Configset & NO_OF_SHARDS * 3 dataset nodes)
- `NO_OF_SHARDS` - Number of shards to be created. Ex 2
- `Nagios` - Existing Nagios Server ip.
- `NO_OF_DATASETS` - Number of Dataset instance. Ex 6
- `SHARD_TO_MOVE` - Shard number to move the existing data while `scaledown`.
- `MONGO_BACKUP_PATH` - Backup path at which all the nodes backups will be stored. Created only in Configset Node0.

Flows
-------
### Backup
Backups the database data and stores them at `MONGO_BACKUP_PATH` in configset node 0.
### Restore
Restores the database if there is any loss.By default restores latest data.
### StartService
Start the services in given order.
### StopService
Stops the services.
### ScaleUp
Scales Up the instance by given `NO_OF_REPLICASETS`.
### ScaleDown
Scales Down the instance by given `NO_OF_REPLICASETS`. You can give `SHARD_TO_MOVE` value to move existing data in the last shard.
### Resilience
All the mongo instances are monitored by external Nagios server. when Any instance goes down an api request is made to Calm which checks and creates new instance in place of terminated/corrupted instance.

Usage
-----
1. Upload the blueprint to calm.
2. Create a new nagios server/ or use existing.
3. Change Aws provider in overview tab, to your existing Aws settings.
4. Change in `Nagios` variable in global variables.
5. Change Credentials for Mongo & Nagios under credentials tab.
6. Run the deployment.

Video
-----

<a href="http://www.youtube.com/watch?feature=player_embedded&v=05CkcLx7k9U" target="_blank"><img src="http://img.youtube.com/vi/05CkcLx7k9U/sddefault.jpg" alt="MONGO DEMO" width="640" height="480" border="10" /></a>

![alt text](http://p5.zdassets.com/hc/settings_assets/663149/200053878/mN1xL8tNpRRq3ws1id2YiA-calm_logo_white.png "Calm.io")
