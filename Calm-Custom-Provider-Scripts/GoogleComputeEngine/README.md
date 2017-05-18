# Google Compute Engine custom provider

## Installing GCE sdk 
-------------------------------------

 * Install below python requirements.
 	 ```pip install google-api-python-client==1.6.2```
 * Install gcloud sdk (Optional)

	```
	sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
    [google-cloud-sdk]
    name=Google Cloud SDK
    baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64
    enabled=1
    gpgcheck=1
    repo_gpgcheck=1
    gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
    EOM
    yum install google-cloud-sdk```
 
 ## Authorization & access keys
 ----------------------------
 
 ### Using gcloud sdk
    `gcloud auth login`
    `gcloud auth application-default login`
    
 * Above commands exports environment variable `GOOGLE_APPLICATION_CREDENTIALS=/root/.config/gcloud/application_default_credentials.json` 