#!/bin/bash

echo "Provisioning virtual machine..."

echo "Setting locales"
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales

echo "Updating public keys for mongodb and mono repositories"
# add mongodb repository
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
#apt-key adv --keyserver pgp.mit.edu --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10

echo "Adding mongodb and mono repositories"
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
# add mono repository
echo "deb http://download.mono-project.com/repo/debian wheezy main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list
#modmonoversio! echo "deb http://download.mono-project.com/repo/debian wheezy-apache24-compat main" >> /etc/apt/sources.list.d/mono-xamarin.list

# update apt-get to latest lists
echo "Updating apt-get"
apt-get update -y > /dev/null

echo "Installing Git"
apt-get install git -y > /dev/null

echo "Installing Golang"
curl -O -s https://storage.googleapis.com/golang/go1.5.3.linux-amd64.tar.gz > /dev/null
tar -xvf go1.5.3.linux-amd64.tar.gz > /dev/null
mv go /usr/local
#echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile
echo "export GOPATH=/opt/workspace" >> /etc/profile
export GOPATH=/opt/workspace
echo "export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin" >> /etc/profile
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

echo "Installing Wide"
mkdir -p $GOPATH/src/github.com/b3log
cd $GOPATH/src/github.com/b3log

git clone https://github.com/b3log/wide
cd wide
echo "go gets"
go get
go get github.com/visualfc/gotools github.com/nsf/gocode github.com/bradfitz/goimports
echo "go build"
go build
echo "executing wide"
wide&
cd 

# autostart wide?

# nodelock git clone github.com/miikkij

# keskus git clone github.com/miikkij



echo "Installing Docker"
curl -s 'https://sks-keyservers.net/pks/lookup?op=get&search=0xee6d536cf7dc86e2d7d56f59a178ac6c6238f52e' | apt-key add --import
apt-get update && apt-get install apt-transport-https -y
apt-get install -y linux-image-extra-virtual
echo "deb https://packages.docker.com/1.9/apt/repo ubuntu-trusty main" | tee /etc/apt/sources.list.d/docker.list
apt-get update && apt-get install docker-engine -y
service docker start
#sudo usermod -a -G docker $USER

echo "Installing Nginx"
apt-get install nginx -y > /dev/null

echo "Installing MongoDb"
apt-get install -y mongodb-org=3.2.3 mongodb-org-server=3.2.3 mongodb-org-shell=3.2.3 mongodb-org-mongos=3.2.3 mongodb-org-tools=3.2.3 --force-yes > /dev/null

echo "Installing Mono"
apt-get install mono-complete -y > /dev/null

echo "Updating PHP repository"
apt-get install python-software-properties build-essential -y > /dev/null
add-apt-repository ppa:ondrej/php5 -y > /dev/null

# update apt-get to latest lists
echo "Updating apt-get (PHP repository update)"
apt-get update -y > /dev/null

echo "Installing PHP"
apt-get install php5-common php5-dev php5-cli php5-fpm -y > /dev/null

echo "Installing PHP extension"
apt-get install curl php5-curl php5-gd php5-mcrypt php5-mysql -y > /dev/null

# echo "Installing MySQL"
# apt-get install debconf-utils -y > /dev/null
# debconf-set-selections <<< "mysql-server mysql-server/root_password password 1234"
# debconf-set-selections <<< "mysql-server mysql-server/root_password_again password 1234"
# apt-get install mysql-server -y > /dev/null

echo "Configuring Nginx"
cp /var/www/provision/config/nginx_vhost /etc/nginx/sites-available/nginx_vhost > /dev/null

ln -s /etc/nginx/sites-available/nginx_vhost /etc/nginx/sites-enabled/

rm -rf /etc/nginx/sites-available/default

service nginx restart > /dev/null
