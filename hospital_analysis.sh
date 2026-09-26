#!/bin/bash

ACTIVE_DIR="active_logs"
REPORT_DIR="reports"
REPORT_FILE="$REPORT_DIR/critical_alerts.txt"

# Member 5: Find and report critical heart rate and temperature alerts
process_vitals() {
    echo "Processing critical vital-sign alerts..."

    mkdir -p "$REPORT_DIR"

    echo "Timestamp,Device_ID,Value" > "$REPORT_FILE"

    if [ -f "$ACTIVE_DIR/heart_rate.log" ]; then
        grep "CRITICAL" "$ACTIVE_DIR/heart_rate.log" | \
        awk -F',' '{print $1 "," $2 "," $3}' >> "$REPORT_FILE"
    fi

    if [ -f "$ACTIVE_DIR/temperature.log" ]; then
        grep "CRITICAL" "$ACTIVE_DIR/temperature.log" | \
        awk -F',' '{print $1 "," $2 "," $3}' >> "$REPORT_FILE"
    fi

    echo "Critical alerts saved to $REPORT_FILE"
}

# Member 6: Calculate average water usage for the ICU reserve
water_audit() {
    echo
    echo "=========================================="
    echo "       ICU WATER USAGE AUDIT"
    echo "=========================================="

    if [ ! -f "$ACTIVE_DIR/water_usage.log" ]; then
        echo "Water usage log not found."
        return 1
    fi

    average=$(awk -F',' '
        $2 == "ICU_WATER_RESERVE" {
            sum += $3
            count++
        }
        END {
            if (count > 0)
                printf "%.2f", sum / count
            else
                print "0.00"
        }
    ' "$ACTIVE_DIR/water_usage.log")

    printf "Facility: ICU_WATER_RESERVE\n"
    printf "Average Water Usage: %s\n" "$average"
    printf "==========================================\n"
}

process_vitals
water_audit

