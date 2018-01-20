#
# Cookbook Name:: webapp
# Recipe:: nagios
#
# Copyright (c) 2015 Ioan Catana, All Rights Reserved.

rpm_package "repo for nagios-plugins-all" do
	action :install
	source "http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm"
end

%w{	nagios 
	nrpe 
	nagios-plugins-all}.each do |pkg|
	package pkg do
		options "--enablerepo=epel"
		action :install
	end
end

service 'nagios' do
	action :start
end

directory "/etc/nagios/" do
	owner "nagios"
	group "nagios"
	mode "0755"
	recursive true
	action :create
end

directory "/usr/lib64/nagios/plugins/check_mysql" do
	owner "nagios"
	group "nagios"
	mode "0755"
	action :create
end

execute "nagios-passwd" do
	command "htpasswd -b -c /etc/nagios/passwd nagiosadmin nagios"
	action :run
end

%w{	nrpe.cfg
	nagios.cfg
	conf.d/mon1.cfg
	conf.d/db.cfg
	conf.d/hostgroup.cfg
	conf.d/services.cfg
	conf.d/mysql.cfg
	conf.d/web.cfg}.each do |file|
	cookbook_file "etc/nagios/#{file}" do
		source "#{file}"
		mode "0644"
	end
end

service 'httpd' do
	action [:restart, :enable]
end

service 'nrpe' do
	action [:restart, :enable]
end

service 'nagios' do
	action [:restart, :enable]
end
