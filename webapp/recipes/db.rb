#
# Cookbook Name:: webapp
# Recipe:: db
#
# Copyright (c) 2015 Ioan Catana, All Rights Reserved.

rpm_package "install epel repository" do
	action :install
	source "http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm"
end

%w{	mysql-server 
	nrpe 
	nagios-plugins-all}.each do |pkg|
	package pkg do
		options "--enablerepo=epel"
		action :install
	end
end

service 'mysqld' do
	action :start
end

execute "mysql-setup" do
	command <<-EOH
		mysql -u root -e "CREATE DATABASE WebDB;
		CREATE USER 'ionut'@'%' IDENTIFIED BY 'start';
		CREATE USER 'nagios'@'%' IDENTIFIED BY 'nagios';
		GRANT ALL ON WebDB.* TO 'nagios'@'%' IDENTIFIED BY 'nagios';
		GRANT ALL ON WebDB.* TO 'ionut'@'%' IDENTIFIED BY 'start';" -B -N
	EOH
end

directory "/etc/nagios" do
	owner "nagios"
	group "nagios"
	mode "0755"
	recursive true
	action :create
end

cookbook_file "/etc/nagios/nrpe.cfg" do
	source "nrpedb.cfg"
end

service 'nrpe' do
	action [:restart, :enable]
end
