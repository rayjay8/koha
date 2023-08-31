#!/bin/bash

# Update and upgrade the system
sudo apt update
sudo apt upgrade -y

# Install the required packages
sudo apt -y install mousepad mariadb-server

# Import the GPG key for the Koha repository
sudo sh -c 'wget -qO - https://debian.koha-community.org/koha/gpg.asc | gpg --dearmor -o /usr/share/keyrings/koha-keyring.gpg'

# Add the Koha repository to the package sources list
echo "deb [signed-by=/usr/share/keyrings/koha-keyring.gpg] https://debian.koha-community.org/koha oldstable main" | sudo tee /etc/apt/sources.list.d/koha.list

# Update the package sources
sudo apt update

# Install the Koha packages
sudo apt -y install koha-common

# Set the MySQL root password
sudo mysqladmin -u root password 6969

# Modify the Koha site configuration
sudo sed -i 's/INTRAPORT="80"/INTRAPORT="8080"/' /etc/koha/koha-sites.conf

# Enable Apache modules and restart the service
sudo a2enmod rewrite
sudo a2enmod cgi
sudo service apache2 restart

# Create a new Koha database
sudo koha-create --create-db library

# Modify the Apache ports configuration
sudo sed -i 's/Listen 80/Listen 8080\nListen 80/' /etc/apache2/ports.conf

# Restart the Apache service
sudo service apache2 restart

# Enable the Koha site and restart Apache
sudo a2dissite 000-default
sudo a2enmod deflate
sudo a2ensite library
sudo service apache2 restart

# Restart the memcached service
sudo service memcached restart

# Open the Koha web interface
xdg-open http://127.0.1.1:8080
