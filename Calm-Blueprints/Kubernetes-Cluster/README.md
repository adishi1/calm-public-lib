# Kubernetes 3 node Cluster Blueprint

This blueprint creates a kubernetes cluster with given number of nodes as input parameter.
##Infra

 1. AWS

##OS
 1. Centos

## Quick Start
 1. Upload the blueprint to calm.
 2. Change to Aws provider in overview tab.
 3. Change Credentials for KUBE and local i.e. calm server, under credentials tab.
 4. Deploy the blueprint.
 5. By default it creates 3 node cluster master + 2 nodes, you can edit "KUBE_NODES" global variable according to your requirement.

OUTPUT
------
Brings up 3 node kubernetes cluster.

Image
------

<img src="http://s3.amazonaws.com/backup-calm-bucket/calm-github-images/KubernetesCluster.png" alt="Kubernetes Cluster" width="640" height="480" border="10" /></a>

![alt text](http://p5.zdassets.com/hc/settings_assets/663149/200053878/mN1xL8tNpRRq3ws1id2YiA-calm_logo_white.png "Calm.io")
