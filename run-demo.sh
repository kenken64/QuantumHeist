#!/bin/bash

# Challenge 2 Demo Runner
# Run with: ./run-demo.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo ""
echo "Starting Challenge 2 Demo..."
echo ""

node quantum-heist.js --demo

if [ $? -ne 0 ]; then
    echo ""
    echo "Error: Make sure Node.js is installed and quantum-heist.js exists."
    exit 1
fi
