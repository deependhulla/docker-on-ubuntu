#!/bin/bash

apt-get install mariadb-server

sed -i "s/LimitNOFILE=32768/LimitNOFILE=62768/"   /usr/lib/systemd/system/mariadb.service
systemctl daemon-reload

MYSQLPASSVPOP=`pwgen -c -1 8`
echo $MYSQLPASSVPOP > /usr/local/src/mariadb-mydbadmin-pass
echo "mydbadmin password in /usr/local/src/mariadb-mydbadmin-pass"

echo "GRANT ALL PRIVILEGES ON *.* TO mydbadmin@localhost IDENTIFIED BY '$MYSQLPASSVPOP'" with grant option | mysql -uroot
echo "GRANT ALL PRIVILEGES ON *.* TO mydbadmin@127.0.0.1 IDENTIFIED BY '$MYSQLPASSVPOP'" with grant option | mysql -uroot
echo "GRANT ALL PRIVILEGES ON *.* TO mydbadmin@'172.17.0.%' IDENTIFIED BY '$MYSQLPASSVPOP'" with grant option | mysql -uroot
mysqladmin -uroot reload
mysqladmin -uroot refresh

systemctl restart  mariadb

#mysqladmin -u root -ptmppassword status
#mysqladmin -u root -p extended-status
#mysqladmin -u root -p processlist

echo "Database Password Setup done."
