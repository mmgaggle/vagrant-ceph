# -*- mode: ruby -*-
# vi: set ft=ruby :

# Copyright 2013 Inktank LLC, <kyle.bader@inktank.com>

Vagrant.configure('2') do |config|

  # Local caching only makes sense when using VirtualBox
  if Vagrant.has_plugin?('vagrant-cachier')
    puts 'INFO:  Vagrant-cachier plugin detected. Optimizing caches.'
    config.cache.auto_detect = true
    config.cache.enable :chef
    config.cache.enable :apt
  else
    puts 'WARN:  Vagrant-cachier plugin not detected. Continuing unoptimized.'
  end

  # Chef Server Definition
  #
  config.vm.define :chefserver do |chefserver|
    chefserver.vm.hostname = 'chefserver'
    chefserver.ssh.username = 'vagrant'
    chefserver.vm.box = 'chefserver'
    chefserver.vm.box_url = 'https://objects.dreamhost.com/vagrant-ceph/chefserver-new.box'
    chefserver.vm.network 'private_network', ip: '192.168.3.100'
    config.vm.provider :virtualbox do |vb|
      vb.name = 'chefserver'
      vb.customize ['modifyvm', :id, '--memory', '1024', '--cpus', '2']
    end
    chefserver.vm.provision 'shell', path: 'scripts/chef-server.sh'
  end

  # Ceph Monitor Definition
  #
  # TODO:  Allow multiple monitors to be launched
  config.vm.define :cephmon do |cephmon|
    cephmon.vm.hostname = 'cephmon'
    cephmon.ssh.username = 'vagrant'
    cephmon.vm.box = 'precise64chef'
    cephmon.vm.box_url = 'https://objects.dreamhost.com/vagrant-ceph/precise64chef.box'
    cephmon.vm.network "private_network", ip: '192.168.3.101'
    config.vm.provider :virtualbox do |vb|
      vb.name = 'cephmon'
      vb.customize ['modifyvm', :id, '--memory', '1024', '--cpus', '2']
    end
    cephmon.vm.provision :chef_client do |chef|
      chef.chef_server_url = 'https://192.168.3.100'
      chef_validation_client_name = 'chef-validator'
      chef.validation_key_path = 'chef/chef-validator.pem'
      chef.environment = 'cluster'
      chef.add_recipe 'ceph::repo'
      chef.add_recipe 'ceph::conf'
      chef.add_recipe 'ceph::mon'
    end
  end

  # Ceph Metadata Server Definition
  #
  # Only create a MDS VM if shell environmental variable is set
  # TODO:  Allow multiple metadata servers to be launched
  if ENV['VAGRANT_CEPH_MDS'] == 'y'
    config.vm.define :cephmds do |cephmds|
      cephmds.vm.hostname = 'cephmds'
      cephmds.ssh.username = 'vagrant'
      cephmds.vm.box = 'precise64'
      cephmds.vm.box_url = 'https://objects.dreamhost.com/vagrant-ceph/precise64chef.box'
      cephmds.vm.network 'private_network', ip: '192.168.3.103'
      config.vm.provider :virtualbox do |vb|
        vb.name = 'cephmds'
        vb.customize ['modifyvm', :id, '--memory', '1024', '--cpus', '2']
      end
      cephmds.vm.provision :chef_client do |chef|
        chef.chef_server_url = 'https://192.168.3.100'
        chef_validation_client_name = 'chef-validator'
        chef.validation_key_path = 'chef/chef-validator.pem'
        chef.environment = 'cluster'
        chef.add_role 'ceph::mds'
      end
    end
  end

  # Ceph Storage Server Definitions
  # 
  num_osds = ENV['VAGRANT_CEPH_NUM_OSDS'].to_i
  (1..num_osds).each do |i|
    cephstore_name = "cephstore100#{i}"
    config.vm.define "cephstore100#{i}" do |cephstore|
      octect = 199 + i
      ip = '192.168.3.' << octect.to_s
      cephstore_name = "cephstore100#{i}"
      cephstore.vm.hostname = "#{cephstore_name}"
      cephstore.ssh.username = 'vagrant'
      cephstore.vm.box = 'precise64'
      cephstore.vm.box_url = 'https://objects.dreamhost.com/vagrant-ceph/precise64chef.box'
      cephstore.vm.network 'private_network', ip: ip
      file_to_disk = "./tmp/#{cephstore_name}.osd_data.vdi"
      config.vm.provider :virtualbox do |vb|
        vb.name = "#{cephstore_name}"
        vb.customize ['modifyvm', :id, '--memory', '1024', '--cpus', '1']
        vb.customize ['createhd', '--filename', file_to_disk, '--size', 10480]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
      end
      cephstore.vm.provision :chef_client do |chef|
        chef.chef_server_url = 'https://192.168.3.100'
        chef_validation_client_name = 'chef-validator'
        chef.validation_key_path = 'chef/chef-validator.pem'
        chef.environment = 'cluster'
        chef.add_recipe 'ceph::repo'
        chef.add_recipe 'ceph::conf'
        chef.add_recipe 'ceph::osd'
        chef.json = {
          "ceph" => {
            "osd_devices" => [
              {
                "device" => "/dev/sdb",
                "dmcrypt" => false
              }
            ]
          }
        }
      end
    end
  end

  # Ceph Object Storage Gateway Definition
  #
  # TODO:  Allow multiple RGW VMs to be launched
  if ENV['VAGRANT_CEPH_RGW'] == 'y'
    config.vm.define :cephrgw do |cephrgw|
      cephrgw.vm.hostname = 'cephrgw'
      cephrgw.ssh.username = 'vagrant'
      cephrgw.vm.box = 'precise64'
      cephrgw.vm.box_url = 'https://objects.dreamhost.com/vagrant-ceph/precise64chef.box'
      cephrgw.vm.network 'private_network', ip: '192.168.3.120'
      config.vm.provider :virtualbox do |vb|
        vb.name = 'cephrgw'
        vb.customize ['modifyvm', :id, '--memory', '1024']
      end
      cephrgw.vm.provision :chef_client do |chef|
        chef.chef_server_url = 'https://192.168.3.100'
        chef_validation_client_name = 'chef-validator'
        chef.validation_key_path = 'chef/chef-validator.pem'
        chef.environment = 'cluster'
        chef.add_recipe 'ceph::repo'
        chef.add_recipe 'ceph::conf'
        chef.add_role 'ceph::radosgw'
      end
    end
  end

  # Ceph Kernel RADOS Block Device Client Definition
  # 
  # TODO:  Allow multiple KRBD clients VMs to be launched
  if ENV['VAGRANT_CEPH_KRBD'] == 'y'
    config.vm.define :krbd do |krbd|
      krbd.vm.hostname = 'krbd'
      krbd.ssh.username = 'vagrant'
      krbd.vm.box = "precise64"
      krbd.vm.box_url = 'https://objects.dreamhost.com/vagrant-ceph/precise64chef.box'
      krbd.vm.network 'private_network', ip: '192.168.3.130'
      config.vm.provider :virtualbox do |vb|
        vb.name = 'krbd'
        vb.customize ['modifyvm', :id, '--memory', '2048', '--cpus', '2']
      end
      krbd.vm.provision :chef_client do |chef|
        chef.chef_server_url = 'https://192.168.3.100'
        chef_validation_client_name = 'chef-validator'
        chef.validation_key_path = 'chef/chef-validator.pem'
        chef.environment = 'cluster'
        chef.add_recipe 'ceph::repo'
        chef.add_recipe 'ceph::conf'
        chef.add_role 'ceph::rbd'
      end
    end
  end
  # TODO: Add some cephfs client love
end
