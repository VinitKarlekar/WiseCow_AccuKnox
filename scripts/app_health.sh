#!/bin/bash

# Configuration
URL=${1:-"http://localhost:4499"}
# Array of acceptable status codes
EXPECTED_STATUS_CODES=(200 201 202 204 301 302)

echo "Checking health of application at: $URL"

# Use curl to get the HTTP status code. -s for silent, -o to discard body, -I to fetch headers only, -w to get status code
status_code=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

if [ -z "$status_code" ] || [ "$status_code" == "000" ]; then
    echo "Application is DOWN. Failed to connect to $URL."
    exit 1
fi

is_expected=false
for expected_code in "${EXPECTED_STATUS_CODES[@]}"; do
    if [ "$status_code" == "$expected_code" ]; then
        is_expected=true
        break
    fi
done

if [ "$is_expected" = true ]; then
    echo "Application is UP. Status code: $status_code"
    exit 0
else
    echo "Application might be DOWN or facing issues. Status code received: $status_code"
    exit 1
fi
