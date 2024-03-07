#!/bin/bash
# Variables
DB_USER="tester"
DB_PASSWORD="tester"
DB_NAME="sonarbox"

# Crée une sauvegarde de la base de données
mysqldump -u $DB_USER -p$DB_PASSWORD $DB_NAME > "/var/backups/bdd/bdd_$(date +%d-%m-%Y-%H:%M:%S).sql"

##sauvegarder 2 fois par jour
# 0 */12 * * * /home/vagrant/cron_script.sh >> /var/backups/bdd/cron_script.log 2>&1