#!/usr/bin/env bash

# Download the PrestaShop source
wget https://www.prestashop.com/download/old/prestashop_1.7.5.2.zip

# Unzip the PrestaShop archive
unzip prestashop_1.7.5.2.zip

# Move zip file with actual shop to prestashop prestashop directory
mv prestashop.zip www/

# Move index.php to prestashop directory
mv index.php www/

#Set the correct user and group ownership for the PrestaShop directory
sudo chown -R $user:www-data www/

# Remove zip and install file
rm prestashop_1.7.5.2.zip Install_PrestaShop.html
