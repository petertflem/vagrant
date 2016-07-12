#!/bin/bash

# Updating package registry
echo "Updating apt-get package registry..."
sudo apt-get update > /dev/null

# Install this to get the 'add-apt-repository' command
echo "Installing software-properties-common..."
sudo apt-get install python-software-properties -y > /dev/null

# Add PPAs
echo "Addings PPAs..."
sudo add-apt-repository ppa:ondrej/php -y > /dev/null # php7.0

# cURL
echo "Installing cURL..."
sudo apt-get install curl -y > /dev/null

# Add signing key for Nginx and repositories for Nginx installation
wget -O - http://nginx.org/keys/nginx_signing.key | sudo apt-key add - > /dev/null
echo "deb http://nginx.org/packages/mainline/ubuntu/ trusty nginx" | sudo tee -a /etc/apt/sources.list > /dev/null
echo "deb-src http://nginx.org/packages/mainline/ubuntu/ trusty nginx" | sudo tee -a /etc/apt/sources.list > /dev/null

# Prepare for Varnish installation
echo "Preparing for Varnish installation..."
sudo apt-get install apt-transport-https -y > /dev/null
sudo curl https://repo.varnish-cache.org/GPG-key.txt | apt-key add - > /dev/null
sudo chown vagrant /etc/apt/sources.list.d
echo "deb https://repo.varnish-cache.org/ubuntu/ trusty varnish-4.1" >> /etc/apt/sources.list.d/varnish-cache.list
sudo chown root /etc/apt/sources.list.d

# Updating package registry
echo "Updating apt-get package registry..."
sudo apt-get update > /dev/null

# Install Varnish
echo "Installing Varnish..."
sudo apt-get install varnish -y > /dev/null

# Git
echo "Installing GIT..."
sudo apt-get install git -y > /dev/null

# VIM
echo "Installing VIM..."
sudo apt-get install vim -y > /dev/null

# Nginx
echo "Installing Nginx..."
sudo apt-get install nginx -y > /dev/null

# debconf-utils
echo "Installing debconf-utils..."
sudo apt-get install debconf-utils -y > /dev/null

# MySQL
echo "Installing MySQL..."
debconf-set-selections <<< "mysql-server mysql-server/root_password password $1"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $1"
sudo apt-get install mysql-server -y > /dev/null

# php7.0
echo "Installing php7.0 and php7.0-mysql..."
sudo apt-get install php7.0 -y > /dev/null
sudo apt-get install php7.0-mysql -y > /dev/null

# Install openssl
echo "Installing openssl..."
sudo apt-get install openssl -y > /dev/null

# Generate self sign ssl certificate
echo "Generating self signed ssl certificate..."
sudo mkdir /etc/nginx/ssl
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -subj "/C=NO/ST=./L=./O=./OU=./CN=." > /dev/null

# Copy server config files into the sites-available/ directory
echo "Configuring Nginx..."
sudo cp /etc/vagrant-provision/config/* /etc/nginx/conf.d/ -R
sudo rm /etc/nginx/conf.d/default.conf
sudo usermod -a -G www-data nginx # I do this to give nginx permission to use the php unix socket
sudo service nginx restart # I need a restart here, not just a start. If not, the newly added group above doesn't apply, or so it seems

# Copying initial files into web root
echo "Copying initial files into web root..."
sudo cp /etc/vagrant-provision/www_root/* /var/www/ -R

# Get the appointed ip address of eth1
ip_address=$(ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')

# Put the ip address into the welcome html.index file
sed -i "s/{{ip_address}}/$ip_address/g" /var/www/index.html

# Set up xdebug - following the steps from here: https://xdebug.org/wizard.php
echo "Setting up xdebug..."
sudo mkdir /opt/xdebug
cd /opt/xdebug
sudo wget http://xdebug.org/files/xdebug-2.4.0.tgz > /dev/null
sudo tar -xvzf xdebug-2.4.0.tgz > /dev/null
sudo apt-get install php7.0-dev -y > /dev/null
cd xdebug-2.4.0
sudo phpize
sudo ./configure > /dev/null
sudo make > /dev/null
sudo cp modules/xdebug.so /usr/lib/php/20151012
sudo bash -c 'cat <<EOT >> /etc/php/7.0/fpm/php.ini

[xdebug]
zend_extension = /usr/lib/php/20151012/xdebug.so
xdebug.remote_enable = 1
xdebug.remote_host = "10.0.2.2"
xdebug.remote_port = 9000
xdebug.remote_handler = "dbgp"
xdebug.remote_mode = req
EOT'
sudo service php7.0-fpm restart

# Print the ip address of the machine
echo "#############################################"
echo "The installation is finished."
echo "IP address: $ip_address"

# Remove the ip_address variable
unset ip_address
