# sonarbox-Vagrant-Docker

# Commandes pratiques pour DEBUG

- Verifier que touts les services nécesssaires soient activé :
    sudo systemctl status mariadb / 
    sudo systemctl status nginx  / sudo systemctl start nginx / sudo systemctl restart nginx
    sudo systemctl restart php8.1-fpm

    
    DEBUG PHP : Problème avec l'arrêt de service php8.1-fpm : le fichier /run/php n'existe plus ou pas...
            sudo mkdir -p /run/php
            sudo chown www-data:www-data /run/php
            sudo systemctl restart php8.1-fpm  

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

En résumé, ce script résout le problème en s'assurant que le débogage PHP est correctement configuré chaque fois que le conteneur est démarré. Il fait cela en installant un service systemd qui exécute un script de démarrage au démarrage du conteneur. Ce script de démarrage contient les commandes nécessaires pour configurer le débogage PHP.
            

SAUVEGARDE MARIADB
dans maraidb.conf.d/50-server.cnf
bind-address            = 0.0.0.0
MariaDB [(none)]> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'tester';
test de connection sur machine local : mysql -h 127.0.0.1 -P 3307 -u root -p