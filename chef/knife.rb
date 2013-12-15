# This file provided as an example. Run 'knife configure' to generate a
# config file for your local user.
log_level                :info
log_location             STDOUT
node_name                'kyle'
client_key               '/vagrant/chef/client.pem'
validation_client_name   'chef-validator'
validation_key           '/etc/chef-server/chef-validator.pem'
chef_server_url          'https://192.168.0.168'
cache_type               'BasicFile'
cache_options( :path => '/home/chef_admin/.chef/checksums' )
cookbook_path [ './cookbooks', './site-cookbooks' ]
