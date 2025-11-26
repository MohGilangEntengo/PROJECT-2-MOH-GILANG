#!/bin/bash
SOURCE="./sumber"
BACKUP="./backup"

mkdir -p "$BACKUP"
LOG_FILE="$BACKUP/backup.log"

echo "mencari file sesuai kriteria..."

FILES=$(find "$SOURCE" -type f -name "*.txt" -mtime -7)

if [ -z "$FILES" ]; then
    echo "tidak ada file yang memenuhi kriteria"
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] - gagal - tidak ada file yang sesuai" >> "$LOG_FILE"
    exit 1
fi

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
FILELIST="/tmp/filelist_$TIMESTAMP.txt"

printf "%s\n" $FILES > "$FILELIST"

BACKUP_NAME="backup_$TIMESTAMP.tar.gz"

echo "mengompresi file..."

tar -czf "$BACKUP/$BACKUP_NAME" -T "$FILELIST"

if [ $? -ne 0 ]; then
    echo "proses kompresi gagal."
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] - gagal - kompresi gagal" >> "$LOG_FILE"
    rm -f "$FILELIST"
    exit 1
fi

echo "[$(date +"%Y-%m-%d %H:%M:%S")] - berhasil - backup dibuat: $BACKUP_NAME" >> "$LOG_FILE"
echo "backup selesai: $BACKUP_NAME"

rm -f "$FILELIST"
