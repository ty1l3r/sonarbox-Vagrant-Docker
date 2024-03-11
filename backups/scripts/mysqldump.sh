#!/bin/bash
# Variables
DB_USER="root"
DB_PASSWORD="tester"
DB_NAME="sonarbox"

# Crée une sauvegarde de la base de données
mysqldump -h 192.168.10.10 -u $DB_USER -p$DB_PASSWORD $DB_NAME > "/home/ubuntu/Admin/backups/mariadb/bdd_$(date +%d-%m-%Y-%H:%M:%S).sql"

#exemple de cronjob sauvegarder 2 fois par jour
# 0 */12 * * * /home/vagrant/cron_script.sh >> /var/backups/bdd/cron_script.log 2>&1
#exemple de cronjob de test
# */2 * * * * /home/vagrant/cron_script.sh >> /var/backups/bdd/cron_script.log 2>&1