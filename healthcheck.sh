#!/bin/bash
set -e
set -u

echo "...Checking installed build tools..."
TOOLS="java mvn gradle node npm"
MISSING=0

for tool in $TOOLS; do
    if command -v "$tool" &>/dev/null; then
        echo "$tool is installed"
    else
        echo "$tool is not installed, kindly install it"
        MISSING=1
    fi
done

if [ "$MISSING" -eq 1 ]; then
    echo "Some required tools are missing."
    exit 1
fi

echo "All required tools are installed."
