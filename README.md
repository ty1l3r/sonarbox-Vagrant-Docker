#
# Commandes pratiques pour DEBUG

- Verifier que touts les services nécesssaires soient activé :
    sudo systemctl status mariadb / 
    sudo systemctl status nginx  / sudo systemctl start nginx / sudo systemctl restart nginx
    sudo systemctl restart php8.1-fpm

    
    DEBUG PHP : Problème avec l'arrêt de service php8.1-fpm : le fichier /run/php n'existe plus ou pas...
            sudo mkdir -p /run/php
            sudo chown www-data:www-data /run/php
            sudo systemctl restart php8.1-fpm  

#
# Configuration du débogage PHP

Ce guide explique comment nous avons résolu un problème avec le service PHP qui s'arrêtait lors du redémarrage du conteneur admin. Cette solution n'est pas optimale puisque créer un fichier unix n'est pas une bonne pratique. Le problème à mon sens peut provenir de l'utilisation de systemctl et l'utilisation de ```CMD ["/usr/sbin/init"]``` dans le dockerfile. Il faudrait essayer de trouver solution en passant par ```supervisor```. 

Nous avons créé un script pour configurer le débogage PHP au démarrage du conteneur. Voici les étapes détaillées de ce que fait le script :

1. **Copie du fichier de service systemd** : Le script copie le fichier de service systemd depuis le répertoire partagé Vagrant vers le répertoire des services systemd du système. Cela garantit que le service est disponible pour être géré par systemd, le système d'initialisation utilisé par de nombreuses distributions Linux.
    ```bash
    sudo cp /vagrant/conf/startup-script.service /etc/systemd/system/startup-script.service
    ```

2. **Rend le fichier de service systemd exécutable** : Le script rend le fichier de service systemd exécutable, ce qui permet à systemd de démarrer le service.
    ```bash
    sudo chmod +x /etc/systemd/system/startup-script.service
    ```

3. **Copie du script de démarrage** : Le script copie le script de démarrage depuis le répertoire partagé Vagrant vers le répertoire des services systemd du système. Ce script contient les commandes spécifiques nécessaires pour configurer le débogage PHP.
    ```bash
    sudo cp /vagrant/conf/startup-script.sh /etc/systemd/system/startup-script.sh
    ```

4. **Rend le script de démarrage exécutable** : Le script rend le script de démarrage exécutable, ce qui permet à systemd de lancer le script lors du démarrage du service.
    ```bash
    sudo chmod +x /etc/systemd/system/startup-script.sh
    ```

5. **Active le service systemd** : Le script active le service systemd pour qu'il démarre automatiquement au démarrage du système. Cela garantit que le script de démarrage est exécuté chaque fois que le conteneur est démarré, configurant ainsi correctement le débogage PHP.
    ```bash
    sudo systemctl enable startup-script
    ```

6. **Démarre le service immédiatement** : Enfin, le script démarre le service immédiatement, ce qui exécute le script de démarrage immédiatement, sans avoir à redémarrer le conteneur.
    ```bash
    sudo systemctl start startup-script
    ```

    Ce script résout le problème en s'assurant que le débogage PHP est correctement configuré chaque fois que le conteneur est démarré. Il fait cela en installant un service systemd qui exécute un script de démarrage au démarrage du conteneur. Ce script de démarrage contient les commandes nécessaires pour configurer le débogage PHP.
#
# SAUVEGARDE MARIADB

la Sauvegarde sera lancé par un mysqldump via un script situé dans la machine hote. Un cronjob automatise le délai de sauvegarde fixé à 2 fois par jour. 
    - fichier local de sauvegarde : /backups/maradidb
    - fichier script : /backups/scripts

    Créer la BDD sonarbox
    dans maraidb.conf.d/50-server.cnf
    bind-address            = 0.0.0.0
    MariaDB [(none)]> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'tester';
#
# Configuration du RSYNC

pour RSYNC afin d'automatiser le script, copier la clé dans la VM : ```ssh-copy-id vagrant@192.168.10.10```

-  Pour la sauvegarde du site symfony. J'opère avec un exclude des fichier inutile à la sauvegarde: 

    ```rsync -avz -e ssh --exclude=.git --exclude=vendor --exclude=node_modules --exclude=public/cache --exclude=public/uploads -P "$SOURCE_DIR" "$DESTINATION_DIR" ```
- Par convention, j'ajoute dans le fichier ```.env```

    ```
    BACKUP_ENABLED=true
    BACKUP_SOURCE_DIR=/var/www/symfony
    BACKUP_DESTINATION_DIR=/home/ubuntu/Admin/backups/site
    BACKUP_EXCLUDES=.git,vendor,node_modules,public/cache,public/uploads
    BACKUP_SCHEDULE=0 0 * * *
    ```
# RSYNC 
- Le cronjob à été definie sur la machine hôte et lance un script en local pour aller récupérer les données demandées de SF. 

    ```0 20 * * * /home/ubuntu/Admin/backups/scripts/site_rsync.sh >> /home/ubuntu/Admin/backups/site/logs/rsync_log.txt 2>&1```
- Contenu du script site_rsync.sh
    ```#!/bin/bash
    # Source et destination de la synchronisation
    SOURCE_DIR=vagrant@192.168.10.10:/var/www/html/symfony
    DESTINATION_DIR=/home/ubuntu/Admin/backups//site/
    # Exclusions de sauvegarde
    EXCLUDES=".git,vendor,node_modules,public/cache,public/uploads"
    # Synchronisation avec rsync
    rsync -avz -e ssh --exclude=.git --exclude=vendor --exclude=node_modules --exclude=public/cache --exclude=public/uploads -P "$SOURCE_DIR" "$DESTINATION_DIR" ```
