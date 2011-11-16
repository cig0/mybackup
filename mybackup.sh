#!/bin/bash

## Script de backup de MySQL
#
# El archivo de configuracion debe tener lo siguiente:
#
# HOST="ip o nombre"
# USER="usuario"
# PASSWD="contrasena"
# BACKUPDIR="/var/backups/db"

CONFIGFILE="/home/mool/dev/mybackup/mybackup.conf"

MYSQL=$(which mysql)
MYSQLDUMP=$(which mysqldump)
GZIP=$(which gzip)
FECHA=$(date +%F)

if [ -f $CONFIGFILE ]; then
  source $CONFIGFILE

  [ ! -d $BACKUPDIR ] && echo "Creando el directorio de backups..." && mkdir $BACKUPDIR
  [ ! -d $BACKUPDIR/$FECHA ] && echo "Creando el directorio de la fecha..." && mkdir $BACKUPDIR/$FECHA

  DATABASES=$($MYSQL -u $USER --password=$PASSWD -h $HOST -Bse "SHOW DATABASES;")
  for i in $DATABASES; do
    echo "Haciendo el dump de la base de datos: $i" 
    $MYSQLDUMP -u $USER --password=$PASSWD -h $HOST $i | $GZIP > $BACKUPDIR/$FECHA/$i.sql.gz
  done
else
  echo "No existe el archivo de configuracion $CONFIGFILE"
fi
