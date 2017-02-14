#!/bin/bash
set -ex
eval $(python -c '
ips = "@@{calm_array_vm_ip}@@".split(",")
if len(ips) == 0:
    print "ES_NODES="
else:
    print "ES_NODES='"'"'\"%s\"'"'"'" % '"'"'", "'"'"'.join(ips)
')
qu=$(($(($(echo "@@{calm_array_vm_ip}@@" | tr "," "\n" | wc -l)/2))+1))
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
sudo apt-get update && sudo apt-get -y install elasticsearch
echo 'network.host: 0.0.0.0
cluster.name: "@@{CLUSTER_NAME}@@"
node.name: elnode@@{calm_array_index}@@
discovery.zen.ping.multicast.enabled: false' | sudo tee -a /etc/elasticsearch/elasticsearch.yml
echo "discovery.zen.minimum_master_nodes: $qu" | sudo tee -a /etc/elasticsearch/elasticsearch.yml
sudo cp /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.template
echo "discovery.zen.ping.unicast.hosts: [${ES_NODES}]" | sudo tee -a /etc/elasticsearch/elasticsearch.yml
sudo service elasticsearch restart
sudo update-rc.d elasticsearch defaults 95 10
