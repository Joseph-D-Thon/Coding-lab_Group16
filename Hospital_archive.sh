Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\Users\PC> ssh 8c4ab9e83e5e@8c4ab9e83e5e.819d622b.alu-cod.online
8c4ab9e83e5e@8c4ab9e83e5e.819d622b.alu-cod.online's password:
root@8c4ab9e83e5e:/# cat << 'EOF' > hospital_archive.sh
> #!/bin/bash
> # ==============================================================================
> # Script Name: hospital_archive.sh
> # Role: Member 4 - The Archivist (Ochri)
> # Description: Handles data backup, log rotation, compression, and maintenance.
> # ==============================================================================
>
> # Directory definitions
> DATA_DIR="./hospital_data"
> LOG_DIR="./logs"
> ARCHIVE_DIR="./archives"
> SYSTEM_LOG="${LOG_DIR}/system.log"
>
> # Function to initialize required folders
> init_archive_env() {
>     mkdir -p "$DATA_DIR" "$LOG_DIR" "$ARCHIVE_DIR"
> }
>
> # Helper function to write log entries
> log_message() {
>     local message="$1"
>     local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
>     echo "[${timestamp}] [ARCHIVIST] ${message}" >> "$SYSTEM_LOG"
> }
>
> # 1. Create a timestamped backup of active hospital data
> backup_data() {
>     init_archive_env
>     local timestamp=$(date "+%Y%m%d_%H%M%S")
>     local archive_name="hospital_data_backup_${timestamp}.tar.gz"
>     local destination="${ARCHIVE_DIR}/${archive_name}"
>
>     if [ -d "$DATA_DIR" ] && [ "$(ls -A $DATA_DIR)" ]; then
>         tar -czf "$destination" -C "$DATA_DIR" .
>         if [ $? -eq 0 ]; then
>             echo "[SUCCESS] Data successfully archived to: ${destination}"
>             log_message "Backup created successfully: ${archive_name}"
>         else
>             echo "[ERROR] Failed to create backup archive."
>             log_message "ERROR: Backup creation failed."
>         fi
>     else
>         echo "[WARNING] Data directory '${DATA_DIR}' is empty or missing. Nothing to backup."
>         log_message "WARNING: Backup skipped (Data directory empty/missing)."
>     fi
> }
>
> # 2. Rotate system logs (archive old logs if they exceed 100KB)
> rotate_logs() {
>     init_archive_env
>     local max_size_bytes=102400 # 100 KB limit
>
>     if [ -f "$SYSTEM_LOG" ]; then
>         local file_size=$(wc -c < "$SYSTEM_LOG")
>
>         if [ "$file_size" -ge "$max_size_bytes" ]; then
>             local timestamp=$(date "+%Y%m%d_%H%M%S")
>             local rotated_file="${LOG_DIR}/system_${timestamp}.log"
>
>             mv "$SYSTEM_LOG" "$rotated_file"
>             gzip "$rotated_file"
>
>             echo "[SUCCESS] Log rotated and compressed: ${rotated_file}.gz"
>             log_message "Log rotated into ${rotated_file}.gz due to size limit."
>         else
>             echo "[INFO] Log file size is within limits. No rotation needed."
>         fi
>     else
>         echo "[INFO] No existing system log found to rotate."
>     fi
> }
>
> # 3. Clean up archives older than X days (default: 30 days)
> cleanup_old_archives() {
>     init_archive_env
>     local days=${1:-30}
>     echo "[INFO] Searching for archives older than ${days} days..."
>
>     local count=$(find "$ARCHIVE_DIR" -type f -name "*.tar.gz" -mtime +${days} | wc -l)
>
>     if [ "$count" -gt 0 ]; then
>         find "$ARCHIVE_DIR" -type f -name "*.tar.gz" -mtime +${days} -exec rm -f {} \;
>         echo "[SUCCESS] Removed ${count} old archive file(s)."
>         log_message "Cleaned up ${count} archive file(s) older than ${days} days."
>     else
>         echo "[INFO] No old archives found for cleanup."
>     fi
> }
>
> # Main Submenu interface
> archive_main_menu() {
>     init_archive_env
>     echo "=========================================="
>     echo "       HOSPITAL ARCHIVE SYSTEM            "
>     echo "=========================================="
>     echo "1. Run Complete Data Backup"
>     echo "2. Rotate Log Files"
>     echo "3. Clean Up Old Archives"
>     echo "4. Return to Main Menu"
>     echo "=========================================="
>     read -p "Select an option [1-4]: " choice
>
>     case $choice in
>         1) backup_data ;;
>         2) rotate_logs ;;
>         3)
>            read -p "Enter retention period in days [Default: 30]: " retention
>            retention=${retention:-30}
>            cleanup_old_archives "$retention"
>            ;;
>         4) echo "Exiting Archive Submenu..." ;;
>         *) echo "[INVALID] Selection out of range." ;;
>     esac
> }
>
> # Execute menu if run standalone
> if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
>     archive_main_menu
> fi
> EOF
root@8c4ab9e83e5e:/# chmod +x hospital_archive.sh
root@8c4ab9e83e5e:/# ls -l hospital_archive.sh
-rwxr-xr-x 1 root root 4102 Sep 26 04:57 hospital_archive.sh
root@8c4ab9e83e5e:/# ./hospital_archive.sh
==========================================
       HOSPITAL ARCHIVE SYSTEM
==========================================
1. Run Complete Data Backup
2. Rotate Log Files
3. Clean Up Old Archives
4. Return to Main Menu
==========================================
Select an option [1-4]:
