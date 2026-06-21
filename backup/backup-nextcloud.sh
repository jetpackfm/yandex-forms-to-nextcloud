#!/bin/bash
# Бэкап Nextcloud (PostgreSQL + данные)
# Ротация: храним 7 последних копий

BACKUP_DIR="/home/nextadmin/backups/nextcloud"
RETENTION=7
DATE=$(date +%Y%m%d-%H%M)

mkdir -p "$BACKUP_DIR"

# Бэкап базы PostgreSQL
docker exec -t nextcloud-docker-db-1 pg_dumpall -U nextcloud > "$BACKUP_DIR/nextcloud-db-$DATE.sql"

# Имя контейнера nextcloud-docker-db-1 может отличаться. Проверьте через docker ps и поправьте.

# Бэкап данных Nextcloud (через контейнер)
docker run --rm \
    --volumes-from nextcloud-docker-nextcloud-1 \
    -v "$BACKUP_DIR:/backup" \
    alpine \
    tar -czf /backup/nextcloud-data-$DATE.tar.gz -C /var/www/html data config

# Удаляем старые бэкапы
find "$BACKUP_DIR" -name "nextcloud-db-*.sql" -mtime +$RETENTION -delete
find "$BACKUP_DIR" -name "nextcloud-data-*.tar.gz" -mtime +$RETENTION -delete

echo "Бэкап Nextcloud создан: $(date)"