#!/bin/bash
# This scrip is to backup MongoDB which store metadata of graylog server
# by Dara Som
# som2dara@gmail.com
DATE=`/bin/date`
LOG=/var/log/mongobackup.log
MONGO_USER=grayloguser
MONGO_PASS=graylogpassword
MONGO_DATABASE="graylog"
APP_NAME="graylog"
MONGO_HOST="127.0.0.1"
MONGO_PORT="27017"
TIMESTAMP=`date +%F-%H%M`
MONGODUMP_PATH="/usr/bin/mongodump"
BACKUPS_DIR="/opt/mongodb-backup/"
BACKUP_NAME="$APP_NAME-$TIMESTAMP"
echo "===============================================================" >> $LOG
echo "Starting backup:" $DATE >> $LOG
# mongo admin --eval "printjson(db.fsyncLock())"
# $MONGODUMP_PATH -h $MONGO_HOST:$MONGO_PORT -d $MONGO_DATABASE
$MONGODUMP_PATH --db $MONGO_DATABASE --username $MONGO_USER --password $MONGO_PASS --out $BACKUPS_DIR
# mongo admin --eval "printjson(db.fsyncUnlock())"
  
cd $BACKUPS_DIR
mv $MONGO_DATABASE $BACKUP_NAME
tar -zcvf $BACKUPS_DIR/$BACKUP_NAME.tar.gz $BACKUP_NAME
rm -rf $BACKUP_NAME
echo "===================== Finnish Backup =========================================="
#echo "FINISH BACKUPS:" $DATE >> $LOG
## Chekcing file to delete
echo "Files before to delete:" >> $LOG
ls -lsrt $BACKUPS_DIR* >> $LOG
cd  $BACKUPS_DIR
#sleep 2
echo "We need to delete some files and keep the last 15 days" >> $LOG
ls -1tr | head -n -15 | xargs -d '\n' rm -rf --
echo "Files after delete:" >> $LOG
ls -lsrt $BACKUP_FOLDER* >> $LOG
