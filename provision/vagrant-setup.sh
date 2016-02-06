#!/bin/bash

echo "- Atualizando lista de pacotes"
sudo apt-get update >> /dev/null

echo "- Definindo Senha padrão para o MySQL e suas ferramentas"
DEFAULTPASS="12345678"
sudo debconf-set-selections <<EOF
mysql-server	mysql-server/root_password password $DEFAULTPASS
mysql-server	mysql-server/root_password_again password $DEFAULTPASS
dbconfig-common	dbconfig-common/mysql/app-pass password $DEFAULTPASS
dbconfig-common	dbconfig-common/mysql/admin-pass password $DEFAULTPASS
dbconfig-common	dbconfig-common/password-confirm password $DEFAULTPASS
dbconfig-common	dbconfig-common/app-password-confirm password $DEFAULTPASS
phpmyadmin		phpmyadmin/reconfigure-webserver multiselect apache2
phpmyadmin		phpmyadmin/dbconfig-install boolean true
phpmyadmin      phpmyadmin/app-password-confirm password $DEFAULTPASS 
phpmyadmin      phpmyadmin/mysql/admin-pass     password $DEFAULTPASS
phpmyadmin      phpmyadmin/password-confirm     password $DEFAULTPASS
phpmyadmin      phpmyadmin/setup-password       password $DEFAULTPASS
phpmyadmin      phpmyadmin/mysql/app-pass       password $DEFAULTPASS
EOF

echo "- Instalando pacotes básicos"
sudo apt-get install vim joe curl python-software-properties git-core --assume-yes --force-yes >> /dev/null


echo "- Adicionando repositório do pacote PHP 5.6"
sudo add-apt-repository ppa:ondrej/php5-5.6 >> /dev/null

echo "- Atualizando lista de pacotes"
sudo apt-get update >> /dev/null

echo "- Instalando MySQL, PHPMyAdmin e alguns outros módulos"
sudo apt-get install mysql-server-5.5 mysql-client phpmyadmin --assume-yes --force-yes >> /dev/null

echo "- Instalando PHP, Apache e alguns módulos"
sudo apt-get install php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt php5-intl php5-sqlite php5-mysql --assume-yes --force-yes >> /dev/null

echo "- Ajustando ServerName localhost"
sudo echo 'ServerName localhost' >> /etc/apache2/apache2.conf

echo "- Habilitando mod-rewrite do Apache"
sudo a2enmod rewrite

echo "- Reiniciando Apache"
sudo service apache2 restart

echo "- Baixando e instalando vhosts.sh"
cd /var/www/
git clone https://github.com/alexkleinubing/vhosts.git
sudo chmod +x vhosts/vhost.sh
sudo mv vhosts/vhost.sh /usr/bin/vhost
sudo -Rf vhosts

echo "- Baixando e instalando Composer"
curl -sS https://getcomposer.org/installer | php >> /dev/null
sudo mv composer.phar /usr/local/bin/composer

echo "- Instalando banco NoSQL Redis" 
sudo apt-get install redis-server --assume-yes >> /dev/null
sudo apt-get install php5-redis >> /dev/null

echo "- Instalando RVM e Ruby 2.3.0"
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 >> /dev/null
\curl -sSL https://get.rvm.io | bash -s stable >> /dev/null
source ~/.rvm/scripts/rvm >> /dev/null
rvm requirements >> /dev/null
rvm install 2.3.0 >> /dev/null
rvm use 2.3.0 --default >> /dev/null

echo "- Instalando NodeJS"
sudo apt-get install nodejs --assume-yes >> /dev/null
sudo apt-get install npm --assume-yes >> /dev/null

# Instale a partir daqui o que você desejar 

echo "[OK] Ambiente de desenvolvimento concluído"
