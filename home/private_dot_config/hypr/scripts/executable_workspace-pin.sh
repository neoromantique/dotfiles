#!/bin/bash

# Configuration
WORKSPACE=$1
CORRECT_PIN="1234"
LOG_FILE="$HOME/.workspace_access_log"

# Fuzzel colors - Nord theme
BG_COLOR="242a36ee"
TEXT_COLOR="eceff4ff"
SELECTION_COLOR="88c0d0ff"
SELECTION_TEXT_COLOR="2e3440ff"
BORDER_COLOR="5e81acff"

# Display an informational notification before showing PIN dialog
notify-send --icon=dialog-password-symbolic \
            --app-name="Workspace Security" \
            "Workspace $WORKSPACE" "Protected workspace - PIN required" \
            --urgency=low

# Get PIN using fuzzel
ENTERED_PIN=$(echo -e "\n" | fuzzel \
    --dmenu \
    --password \
    --prompt="Enter PIN for workspace $WORKSPACE: " \
    --width=35 \
    --lines=0 \
    --horizontal-pad=20 \
    --vertical-pad=15 \
    --inner-pad=10 \
    --border-width=2 \
    --border-radius=10 \
    --font="JetBrains Mono:size=14" \
    --background=${BG_COLOR} \
    --text-color=${TEXT_COLOR} \
    --match-color=${SELECTION_COLOR} \
    --selection-color=${SELECTION_COLOR} \
    --selection-text-color=${SELECTION_TEXT_COLOR} \
    --border-color=${BORDER_COLOR} )

# Trim whitespace
ENTERED_PIN=$(echo "$ENTERED_PIN" | xargs)

# Check if PIN entry was cancelled (empty)
if [ -z "$ENTERED_PIN" ]; then
    notify-send --icon=dialog-information \
                --app-name="Workspace Security" \
                "Access Cancelled" "PIN entry was cancelled" \
                --urgency=low
    exit 0
fi

# Verify PIN
if [ "$ENTERED_PIN" == "$CORRECT_PIN" ]; then
    # Correct PIN - switch to workspace with nice visual feedback
    notify-send --icon=dialog-password \
                --app-name="Workspace Security" \
                "Access Granted" "Switching to workspace $WORKSPACE" \
                --urgency=low

    # Optional: Log successful attempt
    echo "$(date): Successful PIN entry for workspace $WORKSPACE" >> "$LOG_FILE"

    # Small delay for notification visibility before switching
    sleep 0.2
    hyprctl dispatch workspace "$WORKSPACE"
else
    # Wrong PIN - show notification with error icon
    notify-send --icon=dialog-error \
                --app-name="Workspace Security" \
                "Access Denied" "Incorrect PIN for workspace $WORKSPACE" \
                --urgency=normal

    # Log failed attempt
    echo "$(date): Failed PIN attempt for workspace $WORKSPACE" >> "$LOG_FILE"
fi
