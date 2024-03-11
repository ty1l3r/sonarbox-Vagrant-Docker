# Ce script sert au débuggage de php qui ne se lancais pas automatiquement au démarage du container admin
# Lancé depuis le Vagrantfile : # Copie du script de démarrage depuis le répertoire partagé Vagrant vers le répertoire des services systemd du système.
      #sudo cp /vagrant/conf/startup-script.sh /etc/systemd/system/startup-script.sh
      
#!/bin/bash
mkdir -p /run/php
chown www-data:www-data /run/php
systemctl restart php8.1-fpm
