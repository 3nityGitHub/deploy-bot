#!/bin/bash
set -euo pipefail

echo "===== Deploy started ====="

TOOL="$1"
PROJECT_DIR="$2"
APP="$3"
LOG_DIR="$4"

./build.sh "$TOOL" "$PROJECT_DIR"

./run.sh "$APP" "$LOG_DIR"

echo "===== Deploy complete ====="
