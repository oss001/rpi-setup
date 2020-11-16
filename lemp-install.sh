#!/bin/bash
clear
echo "Would you like to install a nginx webserver (LEMP)? (y or n)"
read server
if [[ ( $server == "y" ) ]]; then
echo "Installing Nginx webserver..."
apt-get install nginx -y > /dev/null
systemctl enable nginx > /dev/null
chown www-data:www-data /usr/share/nginx/html -R > /dev/null
echo "Installing MariaDB server..."
apt-get install mariadb-server mariadb-client -y > /dev/null
systemctl enable mariadb > /dev/null
echo "Installing PHP7..."
apt-get install php7.4 php7.4-fpm php7.4-mysql php-common php7.4-cli php7.4-common php7.4-json php7.4-opcache php7.4-readline php7.4-mbstring php7.4-xml php7.4-gd php7.4-curl -y > /dev/null
apt-get install php-imagick php7.4-zip php7.4-bz2 -y > /dev/null
systemctl enable php7.4-fpm > /dev/null
sudo sed -i 's/memory_limit = 128M/memory_limit = 1024M/g' /etc/php/7.4/fpm/php.ini
sudo sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 2048M/g' /etc/php/7.4/fpm/php.ini
sudo sed -i 's/post_max_size = 8M/post_max_size = 1024M/g' /etc/php/7.4/fpm/php.ini
sudo systemctl restart php7.4-fpm
echo "Setting up default Nginx Server block..."
rm /etc/nginx/sites-enabled/default || echo "No previous block to remove."
echo "server {" > /etc/nginx/conf.d/default.conf
echo "  listen 80;" >> /etc/nginx/conf.d/default.conf
echo "  listen [::]:80;" >> /etc/nginx/conf.d/default.conf
echo "  server_name _;" >> /etc/nginx/conf.d/default.conf
echo "  root /usr/share/nginx/html/;" >> /etc/nginx/conf.d/default.conf
echo "  index index.php index.html index.htm index.nginx-debian.html;" >> /etc/nginx/conf.d/default.conf
echo -e "\n" >> /etc/nginx/conf.d/default.conf
echo "  location / {" >> /etc/nginx/conf.d/default.conf
echo "    try_files $uri $uri/ /index.php;" >> /etc/nginx/conf.d/default.conf
echo "  }" >> /etc/nginx/conf.d/default.conf
echo -e "\n" >> /etc/nginx/conf.d/default.conf
echo "  location ~ \.php$ {" >> /etc/nginx/conf.d/default.conf
echo "    fastcgi_pass unix:/run/php/php7.4-fpm.sock;" >> /etc/nginx/conf.d/default.conf
echo "    fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;" >> /etc/nginx/conf.d/default.conf
echo "    include fastcgi_params;" >> /etc/nginx/conf.d/default.conf
echo "    include snippets/fastcgi-php.conf;" >> /etc/nginx/conf.d/default.conf
echo "  }" >> /etc/nginx/conf.d/default.conf
echo -e "\n" >> /etc/nginx/conf.d/default.conf
echo " # A long browser cache lifetime can speed up repeat visits to your page" >> /etc/nginx/conf.d/default.conf
echo "  location ~* \.(jpg|jpeg|gif|png|webp|svg|woff|woff2|ttf|css|js|ico|xml)$ {" >> /etc/nginx/conf.d/default.conf
echo "       access_log        off;" >> /etc/nginx/conf.d/default.conf
echo "       log_not_found     off;" >> /etc/nginx/conf.d/default.conf
echo "       expires           360d;" >> /etc/nginx/conf.d/default.conf
echo "  }" >> /etc/nginx/conf.d/default.conf
echo -e "\n" >> /etc/nginx/conf.d/default.conf
echo "  # disable access to hidden files" >> /etc/nginx/conf.d/default.conf
echo "  location ~ /\.ht {" >> /etc/nginx/conf.d/default.conf
echo "      access_log off;" >> /etc/nginx/conf.d/default.conf
echo "      log_not_found off;" >> /etc/nginx/conf.d/default.conf
echo "      deny all;" >> /etc/nginx/conf.d/default.conf
echo "  }" >> /etc/nginx/conf.d/default.conf
echo "}" >> /etc/nginx/conf.d/default.conf
systemctl reload nginx
mysql_secure_installation
else
echo "Skipping LEMP Installation."
fi
echo "All finished."
exit
