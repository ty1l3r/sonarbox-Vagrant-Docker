# Utiliser l'image ubuntu:focal comme image de base
FROM ubuntu:focal

# Mettre à jour le système et installer les paquets nécessaires
RUN apt-get update \
    && apt-get -y install openssh-server passwd sudo \
    && apt-get -qq clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Installer les paquets supplémentaires
RUN apt-get update \
    && apt-get install -y iproute2 git curl iputils-ping net-tools wget curl nano unzip

# Supprimer les services inutiles de systemd
RUN cd /lib/systemd/system/sysinit.target.wants/ \
    && for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done \
    && rm -f /lib/systemd/system/multi-user.target.wants/* \
    && rm -f /etc/systemd/system/*.wants/* \
    && rm -f /lib/systemd/system/local-fs.target.wants/* \
    && rm -f /lib/systemd/system/sockets.target.wants/*udev* \
    && rm -f /lib/systemd/system/sockets.target.wants/*initctl* \
    && rm -f /lib/systemd/system/basic.target.wants/* \
    && rm -f /lib/systemd/system/anaconda.target.wants/*;

# Activer le service SSH
RUN systemctl enable ssh.service;

# Créer l'utilisateur vagrant et configurer les privilèges sudo
RUN useradd --create-home -s /bin/bash vagrant \
    && echo "vagrant:vagrant" | chpasswd \
    && echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/vagrant \
    && chmod 440 /etc/sudoers.d/vagrant

# Configuration SSH pour l'utilisateur vagrant
RUN mkdir -p /home/vagrant/.ssh \
    && chmod 700 /home/vagrant/.ssh \
    && curl -o /home/vagrant/.ssh/authorized_keys https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub \
    && chmod 600 /home/vagrant/.ssh/authorized_keys \
    && chown -R vagrant:vagrant /home/vagrant/.ssh

# Installer Nginx, MariaDB 
RUN apt-get update \
    && apt-get install -y nginx mariadb-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Installer python3-certbot-nginx
RUN apt-get update \
    && apt-get install -y python3-certbot-nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Créer un volume pour le système de fichiers cgroup
VOLUME [ "/sys/fs/cgroup" ]

CMD ["/usr/sbin/init"]