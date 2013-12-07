#!/bin/bash

apt-get install -y git
knife environment from file /vagrant/chef/environments/cluster.json -c /vagrant/chef/knife.rb
git clone https://github.com/mmgaggle/ceph-cookbooks.git /tmp/ceph
git clone https://github.com/opscode-cookbooks/apache2.git /tmp/apache2
git clone https://github.com/opscode-cookbooks/apt.git /tmp/apt
knife node from file /vagrant/chef/nodes/cephmon.json -c /vagrant/chef/knife.rb
#knife node from file /vagrant/chef/nodes/cephstore1000.json -c /vagrant/chef/knife.rb
#knife node from file /vagrant/chef/nodes/cephstore1001.json -c /vagrant/chef/knife.rb
knife cookbook upload apt -o /tmp -c /vagrant/chef/knife.rb
knife cookbook upload apache2 -o /tmp -c /vagrant/chef/knife.rb
knife cookbook upload ceph -o /tmp -c /vagrant/chef/knife.rb
