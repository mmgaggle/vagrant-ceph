#
# Example Chef Client Config File
#
# Use Opscode's chef cookbook for managing chef itself,
# instead of using this file. It is provided as an example.

log_level          :info
log_location       STDOUT
ssl_verify_mode    :verify_none
chef_server_url    "https://192.168.3.100"

validation_client_name "chef-validator"
validation_key         "/vagrant/chef/validation.pem"
client_key             "/etc/chef/client.pem"

file_store_path    "/srv/chef/file_store"
file_cache_path    "/srv/chef/cache"

pid_file           "/var/run/chef/chef-client.pid"

Mixlib::Log::Formatter.show_time = true
