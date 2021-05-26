# Database name
db_name=postgres

# Backup Storage directory 
backupfolder=~/backups

# Send Email to 
send_email=<meetjerwin@mail.com>

# Retension policy days
rention_day=30

sqlfile=$backupfolder/all-database-$(date +%d-%m-%Y_%H-%M-%S).sql
zipfile=$backupfolder/all-database-$(date +%d-%m-%Y_%H-%M-%S).zip

#create backup folder
mkdir -p $backupfolder

# Create a backup

if pg_dump $db_name > $sqlfile ; then
   echo 'Sql dump created'
else
   echo 'pg_dump return non-zero code' | mailx -s 'No backup was created!' $send_email
   exit
fi

# Backup Compression  
if gzip -c $sqlfile > $zipfile; then
   echo 'The backup was successfully compressed'
else
   echo 'Error compressing backup' | mailx -s 'Backup was not created!' $send_email
   exit
fi

rm $sqlfile 
echo $zipfile | mailx -s 'Backup was successfully created' $send_email

# Delete older backups 
find $backupfolder -mtime +$rention_day -delete
