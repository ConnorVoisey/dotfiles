#!/bin/bash

# File to store agent info
SSH_ENV="$HOME/.ssh/agent-env"

# Function to start a new agent
start_agent() {
    echo "Starting new ssh-agent..."
    ssh-agent > "$SSH_ENV"
    chmod 600 "$SSH_ENV"
    . "$SSH_ENV" > /dev/null
}

# Function to check if agent is running
is_agent_running() {
    if [ -n "$SSH_AUTH_SOCK" ] && [ -S "$SSH_AUTH_SOCK" ]; then
        ssh-add -l &>/dev/null
        case $? in
            0|1) return 0 ;;  # 0 = has keys, 1 = no keys but agent running
            *) return 1 ;;
        esac
    fi
    return 1
}

# Check if agent is already running
if is_agent_running; then
    echo "Using existing ssh-agent (PID: $SSH_AGENT_PID)"
else
    # Try to load agent info from file
    if [ -f "$SSH_ENV" ]; then
        . "$SSH_ENV" > /dev/null
        if is_agent_running; then
            echo "Reconnected to existing ssh-agent (PID: $SSH_AGENT_PID)"
        else
            start_agent
        fi
    else
        start_agent
    fi
fi
