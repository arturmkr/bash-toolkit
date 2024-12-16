#!/usr/bin/env bash

# Ensure configuration file exists
CONFIG_FILE="ssh_tunnel_config.txt"
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Configuration file '$CONFIG_FILE' not found!"
    echo "Create the file by copying 'ssh_tunnel_config.example' and filling in the required details."
    exit 1
fi

# Initialize variables
line_counter=0

# Read configuration file
while IFS= read -r line || [[ -n "$line" ]]; do
    ((line_counter++))
    case $line_counter in
        1) SSH_USER="$line" ;;
        2) SSH_KEY_PATH="$line" ;;
        3) SSH_HOST="$line" ;;
        4) TARGET_HOST="$line" ;;
        5) TARGET_PORT="$line" ;;
        6) LOCAL_PORT="$line" ;;
    esac
done < "$CONFIG_FILE"

# Ensure all variables are set
if [[ -z "$SSH_USER" || -z "$SSH_KEY_PATH" || -z "$SSH_HOST" || -z "$TARGET_HOST" || -z "$TARGET_PORT" || -z "$LOCAL_PORT" ]]; then
    echo "Error: Missing configuration values in '$CONFIG_FILE'."
    exit 1
fi

# Create SSH tunnel
ssh -L "${LOCAL_PORT}:${TARGET_HOST}:${TARGET_PORT}" -N -i "$SSH_KEY_PATH" "${SSH_USER}@${SSH_HOST}" -o ExitOnForwardFailure=yes || {
    echo "Error: Failed to create SSH tunnel."
    exit 1
}
