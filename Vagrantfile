# Définit le fournisseur par défaut pour Vagrant comme étant Docker
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'docker'

# Configure Vagrant pour utiliser la version 2 de la configuration
Vagrant.configure("2") do |config|
  # Définit une nouvelle machine virtuelle nommée "admin"
  config.vm.define "admin" do |admin|
    #Partage de fichier de sauvagarde mariadb
    #admin.vm.synced_folder "/vagrant/backups/mariadb", "/var/backups/mariadb"
    # Configure un réseau privé avec une adresse IP spécifique
    admin.vm.network :private_network, ip: "192.168.10.10", netmask: 24
    # Redirige les ports 80 et 443 du conteneur vers les ports 80 et 443 de l'hôte
    admin.vm.network "forwarded_port", guest: 80, host: 80
    admin.vm.network "forwarded_port", guest: 443, host: 443
    # Configure le fournisseur de la machine virtuelle pour utiliser Docker
    admin.vm.provider "docker" do |d|
      # Définit le répertoire de construction pour Docker
      d.build_dir = "."
      # Active l'accès SSH au conteneur Docker
      d.has_ssh = true
      # Exécute le conteneur Docker en mode privilégié
      d.privileged = true
      # Crée le conteneur Docker avec un argument spécifique pour monter le système de fichiers cgroup
      # This line of code sets the create_args variable to an array containing the arguments for creating a Vagrant box.
      # The arguments specify the mounting of the /sys/fs/cgroup directory as read-only inside the Vagrant box.
      d.create_args = ["-v", "/sys/fs/cgroup:/sys/fs/cgroup:ro"]
      # Nomme le conteneur Docker "admin"
      d.name = "admin"
      # Garde le conteneur Docker en cours d'exécution
      d.remains_running = true
    end

    # Provisionne la machine virtuelle avec un script shell
    admin.vm.provision "shell", inline: <<-SHELL
      #===== INSTALLATIONS =================================================================================================================
      # Met à jour la liste des paquets disponibles pour l'installation.
      sudo apt-get update
      # Installe le paquet "software-properties-common" qui fournit des scripts pour gérer les logiciels.
      sudo apt-get install -y software-properties-common
      sudo add-apt-repository -y ppa:ondrej/php
      sudo apt-get update
      # Installe PHP 8.1 et plusieurs extensions PHP nécessaires.
      sudo apt-get install -y php8.1-fpm php8.1-curl php8.1-mysql php8.1-gd php8.1-mbstring php8.1-xml php8.1-imagick php8.1-zip
      # Modifie la confioguration de PHP-FPM 
      sudo sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/8.1/fpm/php.ini
      sudo sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 128M/g' /etc/php/8.1/fpm/php.ini
      sudo sed -i 's/post_max_size = 8M/post_max_size = 128M/g' /etc/php/8.1/fpm/php.ini
      sudo sed -i 's/memory_limit = 128M/memory_limit = 512M/g' /etc/php/8.1/fpm/php.ini
      sudo sed -i 's/max_execution_time = 30/max_execution_time = 120/g' /etc/php/8.1/fpm/php.ini
      # Active le service PHP-FPM pour qu'il démarre automatiquement au démarrage.
      sudo systemctl enable php8.1-fpm 
      sudo systemctl enable mariadb
      # Installe curl, rsync et cron
      sudo apt-get install -y curl rsync cron
    

      #===== SYMFONY =================================================================================================================
      # Télécharge et installe Composer
      curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
      # Utilise Composer pour créer un nouveau projet Symfony dans le répertoire /var/www/html/symfony
      sudo composer create-project symfony/skeleton:"6.4.*" /var/www/html/symfony
      # Change la propriété du répertoire Symfony à www-data
      sudo chown -R www-data:www-data /var/www/html/symfony
      # Change les permissions du répertoire Symfony
      sudo chmod -R 755 /var/www/html/symfony

      #===== NGINX CONF ==============================================================================================================
      # Copie le fichier nginx.conf dans le répertoire approprié
      sudo cp /vagrant/conf/nginx.conf /etc/nginx/nginx.conf
      # Redémarre Nginx pour appliquer les modifications
      sudo service nginx restart

      #===== MARIADB CONF ==============================================================================================================
      #Lance mariadb
      sudo systemctl start mariadb
      # Démarage autompatique de mariadb
      sudo systemctl enable mariadb
      #===== CRON CONF ==============================================================================================================
      # Active le service cron pour qu'il démarre automatiquement au démarrage.
      sudo systemctl enable cron
      sudo systemctl start cron
      # Création des fichiers bakcups et definitions des droits. 
      sudo mkdir -p /var/backups/bdd && sudo chmod 754 /var/backups/bdd && sudo chown -R vagrant:vagrant /var/backups/bdd
      sudo mkdir -p /var/backups/conf && sudo chmod 754 /var/backups/conf && sudo chown -R vagrant:vagrant /var/backups/conf
      sudo mkdir -p /var/backups/site && sudo chmod 754 /var/backups/site && sudo chown -R vagrant:vagrant /var/backups/site

      # Copie le fichier cron_script.sh dans le répertoire approprié
      sudo cp /vagrant/conf/cron_script.sh /home/vagrant/cron_script.sh
      # Rend le script exécutable
      sudo chmod 755 /home/vagrant/cron_script.sh
      sudo chown vagrant:vagrant /home/vagrant/cron_script.sh
      # Ajoute une tâche cron pour exécuter le script toutes les heures
      #echo "0 * * * * /home/vagrant/cron_script.sh" | sudo crontab -  
    SHELL
  end
end

# sudo mkdir -p /home/vagrant
# Supprime la version actuelle de PHP-FPM
#apt-get remove --purge -y php8.2-fpm
# Réinstalle PHP-FPM
#apt-get install -y php8.2-fpm
# Active les modules nécessaires pour PHP-FPM dans Apache
#a2enmod proxy_fcgi setenvif
# Active la configuration de PHP-FPM pour Apache
#a2enconf php8.2-fpm
# Définit le nom de domaine pleinement qualifié du serveur
#echo "ServerName localhost" | tee /etc/apache2/conf-available/fqdn.conf && a2enconf fqdn
# Redémarre Apache pour appliquer les modifications
#service apache2 restart

# Change la propriété du répertoire Symfony à www-data
#chown -R www-data:www-data /var/www/html/symfony
# Change les permissions du répertoire Symfony
#chmod -R 755 /var/www/html/symfony

#Prevoir la configuration de mariadb ?
# ouvrir le port 3306 pour mdb

#création du dossier script cron
# touch