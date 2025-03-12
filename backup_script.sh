#!/bin/bash

LOGFILE="/var/log/backup/backup.log"
DEST="/mnt/backupusb/raspberrypi_backup"

# Sicherstellen, dass der USB-Stick gemountet ist
if ! mount | grep -q "$USB_MOUNT"; then
    echo "[$(date)] - Fehler: USB-Stick ist nicht gemountet!" > $LOGFILE
    exit 1
fi


# Liste der Backup-Pfade

SRC1="backupuser@192.168.88.101:/home/backupuser/"
SRC2="backupuser@192.168.88.102:/home/backupuser/"
SRC3="/home/backupuser/"


# Logging für den Start des Backups
echo "$(date '+%Y-%m-%d %H:%M:%S') - Starte Backups" >> $LOGFILE

# Backups
rsync -avz --delete $SRC1 $DEST/192.168.88.101/ >> $LOGFILE 2>&1

rsync -avz --delete $SRC2 $DEST/192.168.88.102/ >> $LOGFILE 2>&1

rsync -avz --delete $SRC3 $DEST/192.168.88.100/ >> $LOGFILE 2>&1

# Logging Abschluss
echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup abgeschlossen" >> $LOGFILE


# E-Mail-Benachrichtigung
MAILTO="emilylehmann26@gmail.com"
echo "Backup abgeschlossen" | mail -s "Backup erfolgreich" $MAILTO
