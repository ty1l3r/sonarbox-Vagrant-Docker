# Crée le script de sauvegarde de la base de données
cat << EOF > cron_script.sh
#!/bin/bash
# Variables
DB_USER="tester"
DB_PASSWORD="tester"
DB_NAME="sonarbox"

# Crée une sauvegarde de la base de données
mysqldump -u $DB_USER -p$DB_PASSWORD $DB_NAME > /var/backups/bdd/bdd_$(date +%d-%m-%Y-%H:%M:%S).sql
EOF

# Rend le script exécutable uniquement par l'utilisateur propriétaire
chmod 700 cron_script.sh