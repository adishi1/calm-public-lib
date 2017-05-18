#!/usr/bin/env python

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

# [START delete_instance]
def delete_instance(compute, project, zone, name):
    return compute.instances().delete(
        project=project,
        zone=zone,
        instance=name).execute()
# [END delete_instance]

# [START wait_for_operation]
def wait_for_operation(compute, project, zone, operation):
    print('Waiting for operation to finish...')
    while True:
        result = compute.zoneOperations().get(
            project=project,
            zone=zone,
            operation=operation).execute()

        if result['status'] == 'DONE':
            print("done.")
            if 'error' in result:
                raise Exception(result['error'])
            return result

        time.sleep(1)
# [END wait_for_operation]

# [START run]
def main(project, zone, instance_name, wait=True):

    credentials = GoogleCredentials.get_application_default()
    compute = googleapiclient.discovery.build('compute', 'v1', credentials=credentials)

    instance = instance_existance(compute, project, zone, instance_name)
    if instance == None:
        print("instance {0} doesn't exists".format(instance_name))
        exit()
    print("deleting instance")

    operation = delete_instance(compute, project, zone, instance_name)

    wait_for_operation(compute, project, zone, operation['name'])

if __name__ == '__main__':
    project_id = 'hello-world-168005'
    zone = 'us-central1-c'
    name = 'test-vm-1'
 
    main(project_id, zone, name)
# [END run]
