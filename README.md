# sonarbox-Vagrant-Docker
AIDE POUR LE DEBUG : 
- Verifier que touts les services nécesssaires soient activé :
    sudo systemctl status mariadb / 
    sudo systemctl status nginx  / sudo systemctl start nginx / sudo systemctl restart nginx
    sudo systemctl restart php8.1-fpm
    DEBUG PHP : Problème avec l'arrêt de service php8.1-fpm : le fichier /run/php n'existe plus ou pas...
            sudo mkdir -p /run/php
            sudo chown www-data:www-data /run/php
            sudo systemctl restart php8.1-fpm
            ls -l /run/php/php-fpm.sock (incompréhension sur le lien symbolique)
            Si le bug persiste : verifier que php8.1 soit configuré pour utiliser les sockets Unix. 
            - La configuration de php8.1-fpm se trouve généralement dans le répertoire /etc/php/8.1/fpm/pool.d/. Vous devriez y trouver un fichier www.conf (ou similaire) où vous pouvez spécifier le chemin du fichier .sock.
            