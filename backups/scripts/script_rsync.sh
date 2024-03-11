#!/bin/bash

# Source et destination de la synchronisation
SOURCE_DIR=vagrant@192.168.10.10:/var/www/html/symfony
DESTINATION_DIR=/home/ubuntu/Admin/backups//site/

SOURCE_DIR_MYSQL=vagrant@192.168.10.10:/etc/mysql 
DESTINATION_DIR_MYSQL=/home/ubuntu/Admin/backups/configs/mysql

SOURCE_DIR_NGINX=vagrant@192.168.10.10:/etc/nginx/nginx.conf
DESTINATION_DIR_NGINX=/home/ubuntu/Admin/backups/configs/nginx

# Synchronisation avec rsync de symfony
rsync -avz -e ssh --exclude=.git --exclude=vendor --exclude=node_modules --exclude=public/cache --exclude=public/uploads -P "$SOURCE_DIR" "$DESTINATION_DIR" >> /home/ubuntu/Admin/backups/site/logs/rsync_site_log.txt 2>&1 

# Synchronisation rsync des fichier de configuration MYSQL:
rsync -avz -e ssh --exclude='debian-start' --exclude='debian.cnf' -P "$SOURCE_DIR_MYSQL" "$DESTINATION_DIR_MYSQL" >> /home/ubuntu/Admin/backups/configs/mysql/logs/rsync_mysql_confs_log.txt 2>&1 

# Synchronisation rsync des fichier de configuration NGINX
rsync -avz -e ssh -P "$SOURCE_DIR_NGINX" "$DESTINATION_DIR_NGINX" >> /home/ubuntu/Admin/backups/configs/nginx/logs/rsync_nginx_confs_log.txt 2>&1 