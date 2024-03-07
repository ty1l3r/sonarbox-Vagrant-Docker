#!/bin/bash
mkdir -p /run/php
chown www-data:www-data /run/php
systemctl restart php8.1-fpm
