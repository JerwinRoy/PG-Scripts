#!/bin/bash

#LOG FILE ROATATION

/var/log/mongodb/mongod.log{
daily
rotate 7
dateext
ifempty
compress
missingok
copytruncate
delaycompress
}

logrotate -d /etc/logrotate.d/mongo_3_6.conf
