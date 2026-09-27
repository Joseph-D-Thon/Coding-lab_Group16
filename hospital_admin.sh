#!/bin/bash
initialize_system() {
    echo "[Member 1 - Joseph - Architect] Checking directories..."
    for dir in active_logs archived_logs reports; do
        if [ ! -d "$dir" ]; then
            echo "Creating $dir directory..."
            mkdir -p "$dir"
        else
            echo "$dir already exists - skipping"
        fi
    done
}
secure_data() {
    echo "[Member 2 - David - Security Lead] Securing data..."
    chmod 700 active_logs
    chmod 600 active_logs/* 2>/dev/null || true
    echo "Displaying new permissions:"
    ls -ld active_logs
    ls -l active_logs
}
echo "=== KNH Hospital Admin Setup ==="
initialize_system
secure_data
echo "System Environment Secured on $(date)"
# Joseph work 1
# Joseph work 2
# David - securing active_logs with chmod 700
