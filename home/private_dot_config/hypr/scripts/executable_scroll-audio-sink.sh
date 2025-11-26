#!/bin/bash

# Get a list of sink names
sinks=($(pactl list sinks short | awk '{print $2}'))

# Get the current default sink name
current_sink=$(pactl info | grep "Default Sink:" | awk '{print $3}')

# Check if we found the current sink
if [ -z "$current_sink" ]; then
    echo "Error: Could not determine the current default sink." >&2
    # Attempt to set the first sink as default if we can't find the current one
    if [ ${#sinks[@]} -gt 0 ]; then
        pactl set-default-sink "${sinks[0]}"
        echo "Attempting to set default sink to first available: ${sinks[0]}" >&2
        exit 0
    else
        echo "Error: No sinks found." >&2
        exit 1
    fi
fi

# Find the index of the current sink in the list
current_sink_index=-1
for i in "${!sinks[@]}"; do
    if [[ "${sinks[$i]}" == "$current_sink" ]]; then
        current_sink_index=$i
        break
    fi
done

# Check if the current sink was found in the list
if [ "$current_sink_index" -eq -1 ]; then
    echo "Error: Current default sink '$current_sink' not found in the list of sinks." >&2
    # Reset to the first sink as a fallback
     if [ ${#sinks[@]} -gt 0 ]; then
        pactl set-default-sink "${sinks[0]}"
        echo "Resetting to first available sink: ${sinks[0]}" >&2
        exit 0
    else
        echo "Error: No sinks found to reset to." >&2
        exit 1
    fi
fi


# Determine the direction
direction=$1

# Calculate the index of the next sink
if [ "$direction" == "up" ]; then
    next_sink_index=$(( (current_sink_index - 1 + ${#sinks[@]}) % ${#sinks[@]} ))
else # default to down
    next_sink_index=$(( (current_sink_index + 1) % ${#sinks[@]} ))
fi

# Get the name of the next sink
next_sink="${sinks[$next_sink_index]}"

# Set the new default sink
pactl set-default-sink "$next_sink"
