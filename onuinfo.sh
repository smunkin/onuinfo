#!/bin/bash

# vars
COMMUNITY="public"
INDEXFILE="/home/zabbix/index.txt"
IP="$1"
OUTFILE="/home/zabbix/onuinfo.txt"

# get onu indexes
snmpwalk -v2c -c $COMMUNITY $IP .1.3.6.1.4.1.3320.101.9.1.1.1  | awk {'print $4'} > $INDEXFILE

echo -e "IFACE\t\t MAC\t\t RX/TX\t DIST\t TEMP\t LINK" > $OUTFILE
echo -e "-------------------------------------------------------------------------------" >> $OUTFILE

# get onu info
cat $INDEXFILE | while read IND; do
if [ "$IND" = "Such" ];then 
        echo -e "No Registered ONU" > $OUTFILE
        exit
fi
NAME=$(snmpwalk -v2c -c $COMMUNITY $IP iso.3.6.1.2.1.31.1.1.1.18.$IND | awk {'print $4'})
[ "$NAME" = "" ] && NAME='"--------"'
LNK=$(snmpwalk -v2c -c $COMMUNITY $IP .1.3.6.1.2.1.2.2.1.8.$IND | awk {'print $4'})
[ "$LNK" = "1" ] && LNK="Up" || LNK="Down"
IFACE=$(snmpwalk -v2c -c $COMMUNITY $IP .1.3.6.1.2.1.2.2.1.2.$IND | awk {'print $4'})
MAC=$(snmpwalk -v2c -c $COMMUNITY $IP .1.3.6.1.4.1.3320.101.10.1.1.3.$IND | awk {'print $4 $5"."$6 $7"."$8 $9'})
[ "$MAC" = "" ] && MAC="----.----.----"
DIST=$(snmpwalk -v2c -c $COMMUNITY $IP .1.3.6.1.4.1.3320.101.10.1.1.27.$IND | awk {'print $4'})
[ "$DIST" = "" ] && DIST="---"
TEMP=$(snmpwalk -v2c -c $COMMUNITY $IP .1.3.6.1.4.1.3320.101.10.5.1.2.$IND | awk {'print $4'})
[ "$TEMP" = "" ] && TEMP="--"
let TEMP=$(($TEMP / 256))
RX=$(snmpwalk -v2c -c $COMMUNITY $IP .1.3.6.1.4.1.3320.101.10.5.1.5.$IND | awk {'print $4'})
[ "$RX" = "Such" ] && RX=0
let RX=$(($RX / 10))
TX=$(snmpwalk -v2c -c $COMMUNITY $IP .1.3.6.1.4.1.3320.101.10.5.1.6.$IND | awk {'print $4'})
[ "$TX" = "Such" ] && TX=0
let TX=$(($TX / 10))
echo -e "$IFACE\t$NAME\t$MAC\t $RX/$TX\t $DIST\t $TEMP\t $LNK" >> $OUTFILE
done

#cat $OUTFILE # if you using script in manual mode from console, uncomment this string 

