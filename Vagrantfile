# -*- mode: ruby -*-
# vi: set ft=ruby :
# To use these virtual machines install Vagrant and VirtualBox.
# vagrant up

Vagrant.require_version ">= 2.0.0"

# Select the config file from the STAGE environment variable (dev or test)
# VM Configs are loaded from json files.
$Stage = ENV['STAGE'] || "mini"
# Require JSON module
require 'json'
# Read JSON file with config details
guests = JSON.parse(File.read(File.join(File.dirname(__FILE__), "inventory", $Stage, $Stage + ".json")))
# Local PATH_SRC for mounting
$PathSrc = ENV['PATH_SRC'] || "."
Vagrant.configure(2) do |config|

  # check for updates of the base image
  config.vm.box_check_update = true
  # wait a while longer
  config.vm.boot_timeout = 1200

  # update guest additions
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = true
  end

  # enable ssh agent forwarding
  config.ssh.forward_agent = true

  # use the standard vagrant ssh key
  config.ssh.insert_key = false

  # Iterate through entries in JSON file
  guests.each_with_index do |guest, idx|
    config.vm.define guest['name'], autostart: guest['autostart'], primary: guest['primary'] do |srv|
      srv.vm.box = guest['box']
      srv.vm.hostname = guest['name']
      # Hyper-V needs an _external_ network adapter, bound to a connected interface.
      # srv.vm.network "public_network", type: "dhcp", bridge: "Wi-Fi"
      # Better Hypervisors allow setting the IP
      srv.vm.network 'private_network', ip: guest['ip_addr']

      # set no_share to false to enable file sharing
      srv.vm.synced_folder ".", "/vagrant", id: "vagrant-root", disabled: guest['no_share']

      srv.vm.provider "hyperv" do |hyperv|
        hyperv.cpus = guest['cpu']
        hyperv.memory = guest['memory']
        hyperv.vmname = guest['name']
        hyperv.enable_virtualization_extensions = true
        hyperv.vm_integration_services = {
          guest_service_interface: true,
          heartbeat: true,
          shutdown: true,
          time_synchronization: true,
        }
        hyperv.linked_clone = true
      end
      srv.vm.provider :vmware_desktop do |vmware|
        vmware.gui = guest['gui']
        vmware.vmx["ethernet0.pcislotnumber"] = "160"
        vmware.vmx["ethernet1.pcislotnumber"] = "192"
        vmware.vmx['memsize'] = guest['memory']
        vmware.vmx['numvcpus'] =  guest['cpus']
      end
      srv.vm.provider :virtualbox do |virtualbox|
        virtualbox.customize ["modifyvm", :id,
           "--audio", "none",
           "--cpus", guest['cpus'],
           "--memory", guest['memory'],
           "--graphicscontroller", "VMSVGA",
           '--natnet1', '192.168.33.0/24',
           "--vram", "64",
           "--cableconnected1", "on"
        ]
        virtualbox.gui = guest['gui']
        virtualbox.name = guest['name']
      end
    end
  end

  config.vm.provision :ansible do |ansible|
    ansible.playbook = "host-initialization.yml"
    ansible.compatibility_mode = "2.0"
    ansible.inventory_path = "inventory/" + $Stage + "/hosts"
    ansible.galaxy_role_file = "roles/requirements.yml"
    ansible.galaxy_roles_path = "roles"
    ansible.verbose = ""
    ansible.limit = "all" # or only "nodes" group, etc.
  end
end
