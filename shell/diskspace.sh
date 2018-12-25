#!/bin/bash
system=`hostname --fqdn`
ALERT_EMAIL="anduslim@singtel.com, layhua@singtel.com"
#ALERT_EMAIL="ml-dsdevadm@singtel.com, layhua@singtel.com"
for line in `df -aPh | grep "^/" | sort | awk '{print$6"-"$5"-"$4}'`; do
percent=`echo "$line" | awk -F - '{print$2}' | cut -d % -f 1`
partition=`echo "$line" | awk -F - '{print$1}' | cut -d % -f 1`

#limit=10
limit=95

if [ $partition == '/cdrom' ]; then
limit=101
fi

if [ $percent -ge $limit ]; then
echo "$line" > /tmp/files.out
/bin/mail -s "Free Space warning from $system"  $ALERT_EMAIL < /tmp/files.out
fi
done

