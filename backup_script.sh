#!/bin/bash
LOGFILE="/var/log/backup/backup_$(date '+%Y-%m-%d_%H-%M-%S').log"

# Logging Start
echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup gestartet" >> $LOGFILE

# Backup-Pfade
SRC1="backupuser@192.168.88.101:/home/backupuser/"
SRC2="backupuser@192.168.88.102:/home/backupuser/"
DEST="/backup/raspberrypis/"

# Logging für den Start des Backups
echo "$(date '+%Y-%m-%d %H:%M:%S') - Starte Backups" >> $LOGFILE

# Backup für Raspberry Pi 1
rsync -avz --delete $SRC1 $DEST/192.168.88.101/ >> $LOGFILE 2>&1

# Backup für Raspberry Pi 2
rsync -avz --delete $SRC2 $DEST/192.168.88.102/ >> $LOGFILE 2>&1

# Logging Abschluss
echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup abgeschlossen" >> $LOGFILE

# E-Mail-Benachrichtigung
MAILTO="emilylehmann26@gmail.com"
echo "Backup abgeschlossen" | mail -s "Backup erfolgreich" $MAILTO
