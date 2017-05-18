#!/usr/bin/env python

"""
#name             "google_machine_create"
#maintainer       "Calm.io"
#maintainer_email "ops.calm.io"
#description      "This script creates vm in Google compute engine"

#Input Args:
##PROJECT
##ZONE
##VM_NAME
##CPU
##RAM
##IMAGE_PROJECT
##IMAGE_FAMILY

#Output Args
## HOST_IP
"""

import time

import googleapiclient.discovery
from oauth2client.client import GoogleCredentials


# [START instance_existance]
def instance_existance(compute, project, zone, instance_name):
    try:
        result = compute.instances().get(project=project, zone=zone, instance=instance_name).execute()
        return result
    except:
        return None
# [END instance_existance]


# [START create_instance]
def create_instance(compute, project, zone, name, machine_type, image_project, image_family):
    # Get the latest Debian Jessie image.
    image_response = compute.images().getFromFamily(
        project=image_project, family=image_family).execute()
    source_disk_image = image_response['selfLink']

    # Configure the machine
    machine_type_path = "zones/{0}/machineTypes/{1}".format(zone ,machine_type)

    config = {
        'name': name,
        'machineType': machine_type_path,

        # Specify the boot disk and the image to use as a source.
        'disks': [
            {
                'boot': True,
                'autoDelete': True,
                'initializeParams': {
                    'sourceImage': source_disk_image,
                }
            }
        ],

        # Specify a network interface with NAT to access the public
        # internet.
        'networkInterfaces': [{
            'network': 'global/networks/default',
            'accessConfigs': [
                {'type': 'ONE_TO_ONE_NAT', 'name': 'External NAT'}
            ]
        }],

        # Allow the instance to access cloud storage and logging.
        'serviceAccounts': [{
            'email': 'default',
            'scopes': [
                'https://www.googleapis.com/auth/devstorage.read_write',
                'https://www.googleapis.com/auth/logging.write'
            ]
        }],

        # Metadata is readable from the instance and allows you to
        # pass configuration from deployment scripts to instances.
        'metadata': {
            'items': [
                "default-allow-all"
            ]
        }
    }

    return compute.instances().insert(
        project=project,
        zone=zone,
        body=config).execute()
# [END create_instance]

# [START wait_for_operation]
def wait_for_operation(compute, project, zone, operation):
    print('Waiting for operation to finish...')
    while True:
        result = compute.zoneOperations().get(
            project=project,
            zone=zone,
            operation=operation).execute()

        if result['status'] == 'DONE':
            print("Machine sucessfuly created.")
            if 'error' in result:
                raise Exception(result['error'])
            return result

        time.sleep(1)
# [END wait_for_operation]

# [START wait_for_ip]
def wait_for_ip(compute, project, zone, name):
    print('waiting for ip.')
    while True:
        request = compute.instances().get(project=project_id, zone=zone, instance=name)
        response = request.execute()
        try: 
            ip = response['networkInterfaces'][0]['accessConfigs'][0]['natIP']
            break
        except:
            continue
    return ip
# [END wait_for_ip]

# [START run]
def main(project, zone, instance_name, machine_type, image_project, image_family, wait=True):

    credentials = GoogleCredentials.get_application_default()
    compute = googleapiclient.discovery.build('compute', 'v1', credentials=credentials)
    
    instance = instance_existance(compute, project, zone, instance_name)

    if instance != None and instance['name'] == instance_name:
        print("instance {0} already exists".format(instance_name))
        exit(1)

    print('Creating instance.')
    try:
        operation = create_instance(compute, project, zone, instance_name, machine_type, image_project, image_family)
    except googleapiclient.errors.HttpError as e:
        print('Error : {0}.'.format(e))
        exit(1)
    except:
        print('Failed to create instance.')
        exit(1)

    wait_for_operation(compute, project, zone, operation['name'])
    print "Instance created."
    print "HOST_IP=" + wait_for_ip(compute, project, zone, instance_name)

if __name__ == '__main__':
    project_id = 'hello-world-168005'
    zone = 'us-central1-c'
    name = 'test-vm-1'
    cpu = 2
    ram = 4096
    machine_type = 'custom-' + str(cpu) + '-' + str(ram)
    image_project = 'debian-cloud'
    image_family = 'debian-8'
 

    main(project_id, zone, name, machine_type, image_project, image_family)
# [END run]
