#!/bin/bash
# Бэкап n8n (SQLite + конфиги)
# Ротация: храним 7 последних копий

BACKUP_DIR="/home/nextadmin/backups/n8n"
SOURCE_DIR="/home/nextadmin/n8n"
RETENTION=7

mkdir -p "$BACKUP_DIR"

tar -czf "$BACKUP_DIR/n8n-$(date +%Y%m%d-%H%M).tar.gz" \
    -C "$SOURCE_DIR" n8n_data local_files docker-compose.yml

# Удаляем старые бэкапы
find "$BACKUP_DIR" -name "n8n-*.tar.gz" -mtime +$RETENTION -delete

echo "Бэкап n8n создан: $(date)"