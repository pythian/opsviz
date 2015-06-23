# OpsVis Stack
## The first step in DevOps transformation is knowing where change is needed

### Overview

This repository includes the CloudFormation json and OpsWorks cookbooks to stand up a complete ELK stack in AWS.

Out of the box, it is Highly Available within one availability zone and automatically scales on load and usage.

It also builds everything with private-only ip addresses and restricts all external access to two endpoints:

1. Logs and metrics flow in through HA RabbitMQ with SSL terminated at the ELB
1. All dashboards and elasticsearch requests are protected by doorman and hosted together on a “dashboard” host

### Components [Architecture Diagram](screenshots/architecture_diagram.png)
- CloudFormation Script
- VPC
  - ELBs
  - 1 Public and 4 Private subnets
- OpsWorks
  - Bastion
  - Sensu server
  - Dashboards (Grafana, Kibana, Graphite, Sensu)
  - Graphite
  - Elasticsearch
  - Logstash
  - Rabbitmq
  - Statsd

### Setup
1. Upload an SSL Certificate to AWS for the RabbitMQ ELB - and note the generated ARN [Instructions](http://docs.aws.amazon.com/ElasticLoadBalancing/latest/DeveloperGuide/ssl-server-cert.html#upload-cert)
2. Create a new CloudFormation stack on the [CloudFormation Dashboard](https://console.aws.amazon.com/cloudformation/home) [image](screenshots/create_stack.png)
3. Choose "Upload a template to Amazon S3" on upload cloudformation.json (the template is larger than 51000 bytes, so it needs to be uploaded to S3)
4. See Cloudformation parameters section on specifics for parameters [image](screenshots/cloudformation_parameters.png)
5. *During options I recommend disabling rollback on failture so you can see logs on OpsWorks boxes when recipes fail* [image](screenshots/rollback_on_failure.png)


### Cloudformation parameters
All of these will need to be filled in, for secure passwords and a secure erlang cookie you can use [gen_secrets.py](/gen_secrets.py)
- `CookbooksRef` - *The git reference to checkout for custom cookbooks*
- `CookbooksRepo` - *The git url for your custom cookbooks*
- `CookbooksSshKey` - *The ssh key needed to clone the cookbooks repo*
- `DoormanPassword` - *Password to use for alternate authentication through doorman. Leave empty for none*
- `ElasticSearchVolumeSize` - *Size of disk in GB to use for elasticsearch ebs volumes*
- `GithubOauthAppId` - *Github Oauth App Id to use for doorman authentication. Leave empty for none.*
- `GithubOauthOrganization` - *Github Organization to allow through doorman. Leave empty for none.*
- `GithubOauthSecret` - *Github Oauth App Secret to use for doorman authentication. Leave empty for none.*
- `GraphiteVolumeSize` - *Size of disk in GB to use for graphite ebs volumes*
- `OpsWorksStackColor` - *RGB Color to use for OpsWorks Stack*
- `PagerDutyAPIKey` - *The pagerduty api key if you want sensu alerts forwarded to pagerduty*
- `RabbitMQCertificateARN` - *ARN of the certificate to use for rabbitmq*
- `RabbitMQLogstashExternalPassword` - *RabbitMQ Password*
- `RabbitMQLogstashExternalUser` - *RabbitMQ User*
- `RabbitMQLogstashInternalPassword` - *RabbitMQ Password*
- `RabbitMQLogstashInternalUser` - *RabbitMQ User*
- `RabbitMQPassword` - *RabbitMQ Password*
- `RabbitMQSensuPassword` - *RabbitMQ Sensu Password*
- `RabbitMQStatsdPassword` - *RabbitMQ Statsd Password*
- `RabbitMQUser` - *RabbitMQ User*
- `RabbitMQVolumeSize` - *Size of disk in GB to use for elasticsearch ebs volumes*
- `Route53DomainName` - *The domain name to append to dns records*
- `Route53ZoneId` - *The zone id to add dns records to on instance setup. If empty updates won't happen*
- `Version` - *Just a place holder for version *

  #### Additional Info
  - `CookbooksRepo`

    Should Point to this repository. This will point OpsWorks to use the custom chef cookbooks from this repo
    when provisioning the instances.

  - `DoormanPassword`, `GithubOauthAppId`, `GithubOauthOrganization`, `GithubOauthSecret`

    [Doorman](https://github.com/movableink/doorman) Sits in front of the nginx reverse proxy for elasticsearch, kibana, sensu dashboard, grafana, and graphite
    This allows you to protect all endpoints, including a public facing elasticsearch endpoint for kibana and granfana, with a single github account.

  - `RabbitMQCertificateARN`

    This the ARN identifier for the SSL Certificate that needs to be uploaded before the creation of the this stack. It is used to attach to the RabbitMQ
    ELB for ssl termination

  - `Route53DomainName`, `Route53ZoneId`

    If specified, during the setup event of recipes dns names will be created for your instances and elbs. For example if the domain name was example.com and the stack
    name was opsvis, then the following dns records would be created

    - rabbitmq.opsvis.example.com => RabbitMQ ELB
    - dashboard.opsvis.example.com => Dashboard ELB
    - elasticsearch.opsvis.example.com => Elasticsearch ELB <Internal Only>
    - graphite.opsvis.example.com => Graphite ELB <Internal Only>

### External Access
*All instances other than the NAT and Bastion hosts are within the private subnets and cannot be accessed directly*

RabbitMQ has a public facing ELB in front of it with SSL termination.
The dashboard instance has an ELB in front of it so the dasbhoards for grafana, kibana, graphite, and sensu are publicly accessible (Authentication is still required)
The bastion host has an Elastic IP attached to it and is on the public subnet so that you can SSH into the box and from there SSH into other boxes on the private subnet

**SSH Users**
SSH Users are managed by OpsWorks. After creating the stack login to the OpsWorks dashboard to see the list if IAM users. From there you can assign SSH and Sudo access
to individual users as well as upload public keys. After making changes OpsWorks will run a chef recipe on all boxes to update the user accounts accordingly on each instance

## External Clients
A separate cookbook has been created that contains recipes for installing external clients. The are abstracted out from OpsWorks and AWS so they can be ran on any machine to start sending logs to this OpViz Stack.

See [bb_external](site-cookbooks/bb_external) for more documentation

### External Logstash Clients
To setup an external logstash client.

1. Install logstash according to [documentation](http://logstash.net/docs/1.4.2/tutorials/getting-started-with-logstash)
2. Update the config to push logs to the rabbitmq ELB

### External Statsd Clients
Setup statsd to push metrics rabbitmq where graphite will pull out of.

1. Install statsd client according to [documentation](https://github.com/etsy/statsd/)
2. Install rabbitmq backend `npm install git+https://github.com/mrtazz/statsd-amqp-backend.git`
3. Setup config as follows

        {
          backends: [ "statsd-amqp-backend" ]
          , dumpMessages: true
          , debug: true
          , amqp: {
            host: '<RabbitMQ ELB>'
            , port: 5671
            , login: 'statsd'
            , password: '<statsd RabbitMQ password>'
            , vhost: '/statsd'
            , defaultExchange: 'statsd'
            , messageFormat: 'graphite'
            , ssl: {
              enabled : true
              , keyFile : '/dev/null'
              , certFile : '/dev/null'
              , caFile : '/dev/null'
              , rejectUnauthorized : false
            }
          }
        }

### External Sensu Clients
We use the public facing RabbitMQ as the transport layer for external sensu clients.

1. Install sensu client according to [documentation](http://sensuapp.org/docs/0.16/guide)
2. Update client config `/etc/sensu/conf.d/client.json`
3. Update rabbitmq config `/etc/sensu/conf.d/rabbitmq.json`

        {
          "rabbitmq": {
            "host": "<RabbitMQ ELB>",
            "port": 5671,
            "user": "sensu",
            "password": "<sensu RabbitMQ password>",
            "vhost": "/sensu",
            "ssl" : true
          }
        }

### Updating Sensu Checks and Metrics
*Todo: At this time we don't have a way to drive sensu checks or metrics directly from CloudFormation parameters or any other external definitions.
This would make it easier to update sensu without needing to worry about making changes directly to the sensu config without configuration management or making standalone checks on each client*

- Option 1: SSH into the sensu box and make changes according to sensu [documentation](http://sensuapp.org/docs/0.11/checks)
- Option 2: Setup standalone checks on each external client according to [documentation](http://sensuapp.org/docs/0.11/adding_a_standalone_check)

- Handlers

  When adding a check as [type metric](http://sensuapp.org/docs/0.11/adding_a_metric) set the handlers to "graphite".
  *This will forward any metrics onto graphite for us automatically*

***

### Custom JSON
[This Custom Json](custom_json.example.json) is the Custom Json block that is set as the OpsWorks custom json. It drives a lot of the custom configuration
that chef uses to customize the boxes. Its currently embedded in the CloudFormation script so that we can inject parameters into the custom json.

If changes need to be made to the custom json you can do it from the OpsWorks stack's stack settings page. If you make changes make sure that you
don't update the CloudFormation stack as it will overwrite the custom OpsWork's settings you made.

*Todo: At some point it would be nice to allow a user to inject their own custom json into the CloudFormation processes without having to manually make changes
to the monolithic CloudFormation.json file*

### Using create_stack

There is a provided script called create_stack that can be used for launching an opsviz stack. It creates random passwords and generates a self signed certificate. Basic usage:

```
./create_stack -c 'https://github.com/pythian/opsviz.git' --region us-west-2 teststack
```

You can also provide custom parameters. For example, if you want to use your own password for RabbitMQ:

```
./create_stack -c 'https://github.com/pythian/opsviz.git' --region us-west-2 --param RabbitMQPassword=hunter3 teststack
```

Multiple `--param` options can be specified.

In order to use the script, you must setup access keys. See the [boto configuration doc](http://boto.readthedocs.org/en/latest/boto_config_tut.html) for more information.

### Building with Vagrant

The included Vagrantfile will build the Opsvis stack on four virtual machines ```rabbitmq-1, logstash-1, elastic-1 and dashboard-1```.


#### Prerequisites

Install [vagrant](https://www.vagrantup.com/downloads.html)

Install vagrant plugins

    vagrant plugin install vagrant-berkshelf
    vagrant plugin install vagrant-hostmanager
    vagrant plugin install vagrant-omnibus

Install [Chef Development Kit](https://downloads.chef.io/chef-dk/)

Add chef to your path:

    export PATH=/opt/chefdk/bin:$PATH

bundle and bring up the virtual machines

    bundle
    vagrant up --provider virtualbox --provision

```
Current machine states:

rabbitmq-1                running (virtualbox)
logstash-1                running (virtualbox)
elastic-1                 running (virtualbox)
dashboard-1               running (virtualbox)
```

Once complete the dashboard will be available locally at:

- http://dashboard.opsvis.dev/
- http://dashboard.opsvis.dev/sensu
- http://dashboard.opsvis.dev/kibana
- http://dashboard.opsvis.dev/grafana

Default doorman password is ```opsvis```.


#### Vagrant Configuration

###### nodes.json
Configures each node including roles, ip, hostnames, CPU, memory, etc.

```
... snip ...
    "dashboard-1": {
      ":node": "Dashboard-1",
      ":ip": "10.10.3.10",
      ":host": "dashboard-1.opsvis.dev",
      ":lb": "dashboard.opsvis.dev",
      ":tags": [
        "dashboard",
        "graphite"
      ],
      ":roles": [
        "dashboard"
      ],
      "ports": [
        {
          ":host": 2201,
          ":guest": 22,
          ":id": "ssh"
        },
        {
          ":host": 8090,
          ":guest": 80,
          ":id": "httpd"
        }
      ],
      ":memory": 2048,
      ":cpus": 1
    }
... snip ...
```

##### node.json
Custom JSON to overwrite default configs.

##### Roles
```roles/``` contains specific node roles and run_list as referenced in Vagrantfile.
