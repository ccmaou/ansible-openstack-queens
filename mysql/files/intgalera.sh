#!/bin/bash
rootPass=`sed -r -n '/root@localhost: /p' /var/log/mysqld.log | awk -F '(: )+' '{print $2}'`
echo "$rootPass"
mysql -uroot -p$rootPass --connect-expired-password <<EOF
set global validate_password_policy=LOW; 
set global validate_password_length=6; 
alter user 'root'@'localhost' identified with mysql_native_password by '$1'; 
grant all on *.* to 'root'@'%' identified with mysql_native_password by '$1' with grant option;
flush privileges;
EOF