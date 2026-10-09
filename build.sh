#!/bin/bash
set -e
echo "==================================="

TOOL=$1
PROJECT_DIR=$2

if [ -z "$TOOL" ]; then
   echo "Usage: ./build.sh <maven|gradle|node> <project_directory>"
   exit 1
fi

if [ -z "$PROJECT_DIR" ]; then
   echo "Usage: ./build.sh <maven|gradle|node> <project_directory>"
   exit 1
fi
if [ "$TOOL" != "maven" ] && [ "$TOOL" != "gradle" ] && [ "$TOOL" != "node" ]; then
    echo "Unknown tool: $TOOL"
    exit 1
fi

if ! ./healthcheck.sh; then
   echo "$TOOL is not installed"
   exit 1
fi

cd "$PROJECT_DIR"

if [ "$TOOL" = "maven" ]; then
   mvn package
   echo "Artifact is in target/"
elif [ "$TOOL" = "gradle" ]; then
   ./gradlew build
   echo "Artifact is in build/libs/"
elif [ "$TOOL" = "node" ]; then
   npm install
   echo "Artifact is in node_modules"
else
   echo "Unknown tool: $TOOL"
   exit 1
fi
