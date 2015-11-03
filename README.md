# To get started:

* clone this repo
* `vagrant up`

The whole process takes a while, especially if you don't have the box image locally already. on my 4G MBP it takes 20ish minutes
What it does step by step is:

0. (downloads the ubuntu-14.04 image)
1. spins up a virtual machine emulating a physical hypervisor host
2. bootstraps the host with saltstack and starts master and minion there
3. runs highstate on the vagrant VM minion, which has a state to install LXC and spin up 3 containers (nginx1, nginx2, elk)
4. bootstraps the containers with saltstack and installs and configures the salt minions
5. spins up the nginx containers with random addresses, but keeps a static address for the elk container because of ssl verification
6. installs and configures haproxy, which via salt-mine collects all containers' IPs and sets up the backend pools accordingly

In theory, the logstash forwarder service on both nginx containers beams the nginx access logs to logstash, which in turn writes to an elasticsearch indice, but in practice this doesn't really work. See notes section.


# deliverables

* The demo page will be available at https://192.168.2.20
* The haproxy stats are at https://192.168.2.20/haproxy_stats (username and password are in the saltstack/pillar/haproxy.sls file)
* logs dashboard is at https://192.168.2.20:5600


# notes

* for the sake of simplicity and to avoid unnecessary iptables portforwarding, the load balancer lives on the parent host instead of a container.
* this is a demo intended for local demos only, so it skips on most security best practices.
* to save resources, "app" is just a phpinfo file, so deployment is oversimplified. In a real world scenario, the deploy state should invoke a real deployment tool like cap or fabric or even better, just listen for an api call from a CI.
* performance is really bad, especially on older workstations, but that's to be expected.
* elasticsearch and logstash either fail to start at all or crash almost immediately after start due to low memory. Will probably work on a system with more ram, but it's not tested, so expect some errors.
