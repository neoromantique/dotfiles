function flush-display --description "Toggle DPMS off/on to flush display"
    hyprctl dispatch dpms off && sleep 1 && hyprctl dispatch dpms on
end
