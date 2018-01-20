
# Vagrantfile by Ionut Catana
Vagrant.configure("2") do |config|
	config.vm.box_url = "https://atlas.hashicorp.com/chef/boxes/centos-6.6"
	config.hostmanager.enabled = true
	config.hostmanager.manage_host = true
	config.hostmanager.ignore_private_ip = false
	config.hostmanager.include_offline = true
	config.vbguest.auto_update = false
	config.vm.define "web" do |web|
		web.vm.box = "chef/centos-6.6"
		web.vm.hostname = "web.lab.local"
		web.vm.network "private_network", ip: "192.168.56.110"
		web.hostmanager.aliases = %w(web.lab.local web)
		web.vm.provision :chef_solo do |chef|
			chef.cookbooks_path = "."
			chef.add_recipe "webapp::web"
		end
	end

	config.vm.define "db" do |db|
		db.vm.box = "chef/centos-6.6"
		db.vm.hostname = "db.lab.local"
		db.vm.network "private_network", ip: "192.168.56.111"
		db.hostmanager.aliases = %w(db.lab.local db)
		db.vm.provision :chef_solo do |chef|
			chef.cookbooks_path = "."
			chef.add_recipe "webapp::db"
		end
	end
	
	config.vm.define "nagios" do |nagios|
		nagios.vm.box = "chef/centos-6.6"
		nagios.vm.hostname = "mon1.lab.local"
		nagios.vm.network "private_network", ip: "192.168.56.112"
		nagios.hostmanager.aliases = %w(nagios.lab.local nagios)
		nagios.vm.provision :chef_solo do |chef|
			chef.cookbooks_path = "."
			chef.add_recipe "webapp::nagios"
		end
	end

  config.vm.provision "shell", inline: "echo Hello world! Ionut C.!" 
end
