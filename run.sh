#!/bin/bash
set -e

echo "====================================="

APP=$1
LOG_DIR=$2

if [ -z "$APP" ]; then
   echo "Usage: ./run.sh <app> <log_dir>"
   exit 1
fi

if [ -z "$LOG_DIR" ]; then
   echo "Usage: ./run.sh <app> <log_dir>"
   exit 1
fi

mkdir -p "$LOG_DIR"
$APP > "$LOG_DIR/app.log" 2>&1 &

PID=$!

sleep 2

if ps -p "$PID" > /dev/null; then
   echo "Running: $APP (PID $PID). Logs in $LOG_DIR/app.log"
else
   echo "Failed to start. Check $LOG_DIR/app.log"
   exit 1
fi
