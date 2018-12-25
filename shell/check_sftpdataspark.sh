#!/bin/sh
DIR=/mnt/hdfs/data/mobile_web
DATE=`date +%Y%m%d`
cd $DIR
 if [ ! -d "$DATE" ]; then
  echo "ALERT: $DIR/$DATE not updated!"
fi
