#!/bin/bash

initialize_system() {
    echo "[Member 1 - Joseph] Initializing system..."
    mkdir -p active_logs archived_logs reports
}

secure_data() {
    echo "[Member 2 - David] Securing..."
    chmod 700 active_logs
    ls -ld active_logs
    ls -l active_logs
}

archive_logs() {
    echo "[Member 4 - Ochri] Archiving..."
    mv active_logs/* archived_logs/ 2>/dev/null || true
    touch active_logs/engine.log
}

process_vitals() {
    echo "[Member 5] Processing vitals..."
    grep CRITICAL active_logs/heart_rate.log active_logs/temp.log > reports/critical_alerts.txt 2>/dev/null || true
    awk -F, '{print $1, $2, $3}' reports/critical_alerts.txt 2>/dev/null || true
}

water_audit() {
    echo "[Member 6] Water audit..."
    awk '{sum+=$3} END {if(NR>0) print "AVG ICU_WATER_RESERVE:", sum/NR}' active_logs/water.log 2>/dev/null || true
    printf "Water Audit Summary: %s\n" "$(date)"
}

echo "=== KNH Hospital Admin Setup ==="
initialize_system
secure_data
archive_logs
process_vitals
water_audit
echo "System Environment Secured on $(date)"
# Honorine - orchestrator
