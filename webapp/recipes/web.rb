#
# Cookbook Name:: webapp
# Recipe:: web
#
# Copyright (c) 2015 Ioan Catana, All Rights Reserved.

rpm_package "repo for nagios-plugins-all" do
	action :install
	source "http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm"
end

%w{	httpd
	mysql
	php
	php-common
	php-cli
	php-devel
	php-fpm
	php-gd
	php-imap
	php-intl
	php-mysql
	php-process
	php-xml
	php-xmlrpc
	php-zts
	nrpe 
	nagios-plugins-all}.each do |pkg|
	package pkg do
		options "--enablerepo=epel"
		action :install
	end
end

# download Wordpress
remote_file "/var/www/html/latest.tar.gz" do
	source "http://wordpress.org/latest.tar.gz"
end
execute "untar-wordpress" do
	command "cd /var/www/html/ && tar --strip-components=1 -xvf latest.tar.gz"
	action :run
end

directory "/var/www/html/" do
	owner "apache"
	group "apache"
	mode "0755"
	recursive true
	action :create
end

cookbook_file "/etc/nagios/nrpe.cfg" do
	source "nrpeweb.cfg"
end

service 'httpd' do
	action [:restart, :enable]
end

service 'nrpe' do
	action [:restart, :enable]
end