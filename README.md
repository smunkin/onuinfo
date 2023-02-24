# onuinfo

BDCOM ONU information script for Zabbix

This script send SNMP request to BDCOM OLT terminal and get information about ONU terminals. 

INSTALL:
- copy this script into your zabbix folder
- chmod +x onuinfo.sh
- touch INDEXFILE
- touch OUTFILE
- chown zabbix:zabbix for this files
- add script to zabbix (Administration - Scripts)
- /home/zabbix/onuinfo.sh {HOST.CONN}
- cat /home/zabbix/onuinfo.txt
