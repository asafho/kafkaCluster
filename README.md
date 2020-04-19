## kafkaCluster
setup GCP HA kafka cluster on ubuntu 18
https://kafka.apache.org

the following example:
* setup 3 ubuntu 18 instacnes in GCP
* install kafka and deploy configuration
* setup service manager script to make sure zookeeper and kafka services are up and running 

##### prerequisite
* https://www.terraform.io/ - setup the machine infrastructure<br/>
* https://www.ansible.com/ - install the cluster on remote machines using ssh<br/>
* https://cloud.google.com/sdk/gcloud - google cloud cli<br/>

##### guidline to HA cluster
Automate deployment process.<br/>
deploy cluster required to deploy configurations to all instances and start the services at the same time.<br/>
make sure services are up all the time <br/>

in the following example there are 2 modules
1. TF_kafka - terraform module to deploy 3 ubuntu 18 instances in GCP and generate ansible hosts file 
2. ansible-kafka-cluster
   * installing requirements
   * installing java
   * configure kafka and zookeeper
   * configure cron to make sure the cluster is HA
  
notes:<br/>
if you have your own ubuntu 18 instances you can skip terraform setup<br/>
edit manually ansible hosts file with your own ip's<br/>

terraform command (also will run ansible command):<br/>
`terraform apply `

ansible command:<br/>
`ansible-playbooke -i hosts master.yml`
