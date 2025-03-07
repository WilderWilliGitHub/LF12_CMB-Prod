#!/bin/bash

LOGFILE="/var/log/restore_backup.log"
BACKUP_DIR="/backup/raspberrypis"
PI1="192.168.88.101"
PI2="192.168.88.102"
USER="backupuser"

echo "[$(date)] - Starte Backup-Wiederherstellung" | tee -a $LOGFILE

# Sicherstellen, dass das Skript mit Root-Rechten läuft
if [[ $EUID -ne 0 ]]; then
    echo "Dieses Skript muss als Root ausgeführt werden!" | tee -a $LOGFILE
    exit 1
fi

restore_pi() {
    local pi_ip="$1"
    local dest="/home/$USER"

    echo "[$(date)] - Stelle Backup für $pi_ip wieder her..." | tee -a $LOGFILE

    if [ ! -d "$BACKUP_DIR/$pi_ip" ]; then
        echo "[$(date)] - Kein Backup für $pi_ip gefunden!" | tee -a $LOGFILE
        return
    fi

    rsync -avz --progress "$BACKUP_DIR/$pi_ip/" "$dest/" | tee -a $LOGFILE
    chown -R $USER:$USER "$dest"
    echo "[$(date)] - Wiederherstellung für $pi_ip abgeschlossen!" | tee -a $LOGFILE
}

# Wiederherstellung für beide Raspberry Pis
restore_pi $PI1
restore_pi $PI2

echo "[$(date)] - Backup-Wiederherstellung vollständig abgeschlossen!" | tee -a $LOGFILE
