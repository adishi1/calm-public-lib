# calm-public-lib


![alt text](http://p5.zdassets.com/hc/settings_assets/663149/200053878/mN1xL8tNpRRq3ws1id2YiA-calm_logo_white.png "Calm.io")


This is the public repo for Calm.io shared blueprints, custom providers, useful chef cookbooks, support scripts and AWS cloudformation templates for creating an AWS user for Calm etc.

Description of content:
* **Calm-Blueprints**: These are sameple blueprints for different types of multi-node clusters that are published by the Calm team and also contributed by some of our users. Users can download the relevant json blueprint and upload into their Calm instance to be quickly up and running with any of these clusters.

* **Calm-CLI**: The command line interface for Calm users who prefer to use the CLI as power users or as part of other automated scripts.

* **Calm-Cloud-Formation-Templates**: Cloudformation template to create an AWS user with the correct permissions required for Calm tofunction correctly.

* **Calm-Cookbooks**: Some sample Chef cookbooks useful for building a sample Calm blueprint that uses Chef. The sample blueprint guide is [here](http://docs.calm.io/using_calm/#example-blueprint).

* **Calm-Custom-Provider-Scripts**: Custom Providers in Calm enable users to connect Calm to clouds for which native API integrations may not exist yet. See the [Calm documentation](http://docs.calm.io/using_calm/#configuring-calm-with-your-custom-provider) for more information on how to use custom providers with Calm. Calm currently has custom providers for Digital Ocean, Softlayer, Proxmox and OpenNebula based clouds. Even some of the AWS services like RDS can be managed as a Custom Provider.

* **Calm-Support-Scripts**: These are specific scripts provided to Calm users on request. e.g. Creating bulk users into Calm.

Here are some resources to help you out during your journey with Calm:
* [Calm Documentation](http://docs.calm.io)
* [Support Site](http://support.calm.io) 
* [The Calm.io Blog](https://calm.io/blog)

Reach us via email at [team@calm.io](mailto:team@calm.io).
