#!/bin/bash

# Source et destination de la synchronisation
SOURCE_DIR=vagrant@192.168.10.10:/var/www/html/symfony
DESTINATION_DIR=/home/ubuntu/Admin/backups//site/

# Exclusions de sauvegarde
EXCLUDES=".git,vendor,node_modules,public/cache,public/uploads"

# Synchronisation avec rsync
rsync -avz -e ssh --exclude=.git --exclude=vendor --exclude=node_modules --exclude=public/cache --exclude=public/uploads -P "$SOURCE_DIR" "$DESTINATION_DIR" 
