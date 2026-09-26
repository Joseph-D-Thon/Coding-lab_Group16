#!/bin/bash
process_vitals() {
    echo "[Member 5 - Jeremie - Clinical Analyst] Searching CRITICAL..."
    mkdir -p reports
    > reports/critical_alerts.txt
    echo "=== CRITICAL ALERTS $(date) ===" >> reports/critical_alerts.txt
    grep "CRITICAL" active_logs/heart_rate.log 2>/dev/null | awk -F',' '{print $1","$2","$3}' >> reports/critical_alerts.txt
    grep "CRITICAL" active_logs/temperature.log 2>/dev/null | awk -F',' '{print $1","$2","$3}' >> reports/critical_alerts.txt
    cat reports/critical_alerts.txt
}
water_audit() {
    echo "[Member 6 - Jeremie - Facility Auditor] Water audit..."
    avg=$(awk -F',' '$2=="ICU_WATER_RESERVE" {sum+=$3; count++} END {if(count>0) print sum/count; else print 0}' active_logs/water_usage.log)
    total=$(grep -c "ICU_WATER_RESERVE" active_logs/water_usage.log 2>/dev/null || echo 0)
    printf "\n===== WATER AUDIT SUMMARY =====\nDevice: ICU_WATER_RESERVE\nTotal: %d\nAverage: %.2f Liters\nDate: %s\n=============================\n" "$total" "$avg" "$(date)"
}
process_vitals
water_audit
