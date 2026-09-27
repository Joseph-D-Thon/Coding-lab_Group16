#!/usr/bin/env python3
import os, sys, time, random, signal
from datetime import datetime
PID_FILE="/tmp/hospital_system.pid"
LOG_DIR="active_logs"
os.makedirs(LOG_DIR, exist_ok=True)
SENSORS={"heart_rate":["HR_001","HR_002","HR_003","HR_004","HR_005"],"temperature":["TEMP_001","TEMP_002","TEMP_003","TEMP_004","TEMP_005"],"water_usage":["ICU_WATER_RESERVE","GEN_WATER_TANK"]}
def gen():
    while True:
        ts=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        for dev in SENSORS["heart_rate"]:
            v=random.randint(60,180); s="CRITICAL" if v>140 or v<65 else "NORMAL"
            open(f"{LOG_DIR}/heart_rate.log","a").write(f"{ts},{dev},{v},{s}\n")
        for dev in SENSORS["temperature"]:
            v=round(random.uniform(36.0,40.5),1); s="CRITICAL" if v>=39.5 else "NORMAL"
            open(f"{LOG_DIR}/temperature.log","a").write(f"{ts},{dev},{v},{s}\n")
        for dev in SENSORS["water_usage"]:
            v=random.randint(100,500)
            open(f"{LOG_DIR}/water_usage.log","a").write(f"{ts},{dev},{v},NORMAL\n")
        time.sleep(2)
if sys.argv[1]=="start":
    if os.path.exists(PID_FILE): print("Already running"); sys.exit(0)
    pid=os.fork()
    if pid==0:
        open(PID_FILE,"w").write(str(os.getpid())); gen()
    else: print(f"Engine started {pid}")
elif sys.argv[1]=="stop":
    if os.path.exists(PID_FILE):
        try: os.kill(int(open(PID_FILE).read()), signal.SIGTERM)
        except: pass
        os.remove(PID_FILE); print("Stopped")
    else: print("Not running")
