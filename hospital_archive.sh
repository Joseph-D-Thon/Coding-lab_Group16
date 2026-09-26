#!/bin/bash
echo "[Member 4 - Ochri - Archivist] Starting archive..."
mkdir -p archived_logs active_logs
timestamp=$(date +"%Y%m%d_%H%M")
for log in heart_rate temperature water_usage; do
    src="active_logs/${log}.log"
    dest="archived_logs/${log}_${timestamp}.log"
    if [ -f "$src" ]; then
        echo "Archiving $src -> $dest"
        mv "$src" "$dest"
        touch "$src"
        chmod 600 "$src"
        echo "Recreated empty $src"
    else
        touch "$src"
    fi
done
echo "Archiving complete"
ls -lh archived_logs/
