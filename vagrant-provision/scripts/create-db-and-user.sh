#!/bin/bash

echo "Enter MySQL username:"
read mysqlUsername

echo "Enter MySQL password:"
read -s mysqlPassword

echo "Enter database name:"
read databaseName

DATABASE_EXISTS=`mysqlshow --user=$mysqlUsername --password=$mysqlPassword $databaseName| grep -v Wildcard | grep -o $databaseName`

# Check if the database exits
if [ "$DATABASE_EXISTS" == "$databaseName" ]; then
	echo "Database already exists!"
	exit 1
fi

echo "Enter username for database user:"
read username

echo "Enter password for user:"
read -s userPassword

CREATE_DATABASE="CREATE DATABASE IF NOT EXISTS $databaseName;"
GRANT_PRIVIELGES_AND_CREATE_USER="GRANT ALL ON $databaseName.* TO '$username'@'localhost' IDENTIFIED BY '$userPassword';"
FLUSH_PRIVILEGS="FLUSH PRIVILEGES;"

mysql -u root -p$mysqlPassword -e "$CREATE_DATABASE$GRANT_PRIVIELGES_AND_CREATE_USER$FLUSH_PRIVILEGES"
