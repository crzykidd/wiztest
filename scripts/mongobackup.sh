#!/bin/bash
#enable script debuging. 
#set -x
#check if script is running
LOCK_FILE="/home/mander/bin/mongobackup.lock"
if [ -f "$LOCK_FILE" ]; then
  echo "Script is already running."
  exit 1
else
  touch "$LOCK_FILE"


  # Set variables
  #get mongo connection info
  BINDIR="/home/mander/bin"
  MONGODB_HOSTPORT=$(cat $BINDIR/mongodb_hostport.secret)
  MONGODB_USER=$(cat $BINDIR/mongodb_user.secret)
  MONGODB_PASS=$(cat $BINDIR/mongodb_pass.secret)

  #set rest
  DAYSTOKEEP="7"
  S3BUCKET="s3://mongobak"
  DIR=$(date +%Y-%m-%d_%H-%M)
  BASEDIR="/home/mander/mongobackup"
  DEST=$BASEDIR/$DIR


  #Remove files older than x days
  find $BASEDIR -mtime +$DAYSTOKEEP -delete

  # Backup Mongodb
  mkdir $DEST
  mongodump -h $MONGODB_HOSTPORT -u $MONGODB_USER -p $MONGODB_PASS --authenticationDatabase=admin -d go-mongodb -o $DEST

  #Sync Backup to S3 bucket
  aws s3 sync --delete $BASEDIR $S3BUCKET

  #Cleanup lock
  rm "$LOCK_FILE"
fi
