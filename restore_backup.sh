#!/bin/bash

LOGFILE="/var/log/backup/restore_backup.log"
SOURCE="/mnt/backupusb/raspberrypi_backup"

# Sicherstellen, dass der USB-Stick gemountet ist
if ! mount | grep -q "/mnt/backupusb"; then
    echo "[$(date)] - Fehler: USB-Stick ist nicht gemountet!" > $LOGFILE
    exit 1
fi

# Liste der Wiederherstellungsziele
DEST1="backupuser@192.168.88.101:/home/backupuser/"
DEST2="backupuser@192.168.88.102:/home/backupuser/"
DEST3="/home/backupuser/"

# Logging für den Start der Wiederherstellung
echo "$(date '+%Y-%m-%d %H:%M:%S') - Starte Wiederherstellung" >> $LOGFILE

# Wiederherstellung
rsync -avz --delete $SOURCE/192.168.88.101/ $DEST1 >> $LOGFILE 2>&1

rsync -avz --delete $SOURCE/192.168.88.102/ $DEST2 >> $LOGFILE 2>&1

rsync -avz --delete $SOURCE/192.168.88.100/ $DEST3 >> $LOGFILE 2>&1

# Logging Abschluss
echo "$(date '+%Y-%m-%d %H:%M:%S') - Wiederherstellung abgeschlossen" >> $LOGFILE