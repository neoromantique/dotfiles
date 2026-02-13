# Man pages with bat
set -g fish_greeting
set -x MANROFFOPT "-c"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

# ~/.local/bin
fish_add_path -m $HOME/.local/bin

# LM Studio
fish_add_path $HOME/.lmstudio/bin

# Bun
fish_add_path ~/.bun/bin

# Backblaze B2
alias backblaze-b2=bbb2

# SSHS (optional)
if command -q sshs
    alias ss=sshs
end

# Scaleway (lazy-load)
function scw --wraps=scw
    functions -e scw
    eval (command scw autocomplete script shell=fish)
    command scw $argv
end

# Kubernetes
set -e SHOW_K8S
kubeswitch kubectl-alias kubectl
kubeswitch inherit-env
set -gx KUBECONFIG /dev/null

# History with timestamps
function history
    builtin history --show-time='%F %T '
end

# Atuin history (fuzzy search + sync)
if status is-interactive; and command -q atuin
    atuin init fish | source
    if functions -q _atuin_search
        bind \cr _atuin_search
    end
end

# Ctrl+S launches sshs when available
if status is-interactive; and command -q sshs
    function __sshs_launch --description "Launch sshs via keybind"
        commandline -f cancel
        sshs
    end
    bind \cs __sshs_launch
end

# Bash-style !! and !$
function __history_previous_command
    switch (commandline -t)
    case "!"
        commandline -t $history[1]; commandline -f repaint
    case "*"
        commandline -i !
    end
end

function __history_previous_command_arguments
    switch (commandline -t)
    case "!"
        commandline -t ""
        commandline -f history-token-search-backward
    case "*"
        commandline -i '$'
    end
end

bind ! __history_previous_command
bind '$' __history_previous_command_arguments

# Terminal SSH background color derived from server IP (Ghostty/Foot)
if not set -q TERM_SSH_BG_RESET
    # Match configured terminal background as the reset target.
    set -gx TERM_SSH_BG_RESET "#141414"
end

function __term_supports_osc11 --description "Check if terminal supports OSC 11 bg color"
    if not status is-interactive
        return 1
    end

    # Ghostty
    if test "$TERM_PROGRAM" = "ghostty"
        return 0
    else if string match -q "*ghostty*" "$TERM"
        return 0
    else if set -q GHOSTTY
        return 0
    end

    # Foot
    if string match -q "foot*" "$TERM"
        return 0
    end

    return 1
end

function __term_bg_set_from_ip --description "Set terminal background derived from IP"
    if not __term_supports_osc11
        return
    end

    if test (count $argv) -lt 1
        return
    end

    set -l server_ip $argv[1]
    if test -z "$server_ip"
        return
    end

    set -l hash (printf '%s' "$server_ip" | cksum | awk '{print $1}')
    set -l base_r 20
    set -l base_g 20
    set -l base_b 20
    set -l r_delta (math --scale 0 "($hash % 49) - 24")
    set -l g_delta (math --scale 0 "(($hash / 49) % 49) - 24")
    set -l b_delta (math --scale 0 "(($hash / 2401) % 49) - 24")
    set -l r (math --scale 0 "$base_r + $r_delta")
    set -l g (math --scale 0 "$base_g + $g_delta")
    set -l b (math --scale 0 "$base_b + $b_delta")

    if test $r -lt 0; set r 0; end
    if test $g -lt 0; set g 0; end
    if test $b -lt 0; set b 0; end
    if test $r -gt 255; set r 255; end
    if test $g -gt 255; set g 255; end
    if test $b -gt 255; set b 255; end

    printf '\e]11;#%02x%02x%02x\a' $r $g $b
    set -g __term_ssh_bg_active 1
end

function __term_ssh_bg --description "Set terminal background for SSH"
    if not __term_supports_osc11
        return
    end

    if not set -q SSH_CONNECTION
        return
    end

    set -l server_ip (string split " " -- $SSH_CONNECTION)[3]
    __term_bg_set_from_ip $server_ip
end

set -g __term_ssh_in_progress 0
function __term_ssh_postexec_reset --on-event fish_postexec --description "Reset terminal background after SSH command"
    if test $__term_ssh_in_progress -eq 1
        __term_ssh_bg_reset --force
        set -g __term_ssh_in_progress 0
    end
end

function __term_ssh_prompt_reset --on-event fish_prompt --description "Reset terminal background on prompt redraw after SSH"
    if test $__term_ssh_in_progress -eq 1
        __term_ssh_bg_reset --force
        set -g __term_ssh_in_progress 0
    end
    if set -q __term_ssh_bg_active; and test $__term_ssh_bg_active -eq 1
        __term_ssh_bg_reset --force
    end
end

function __term_ssh_ctrl_c --description "Reset terminal background before Ctrl+C"
    if set -q __term_ssh_bg_active; and test $__term_ssh_bg_active -eq 1
        __term_ssh_bg_reset --force
    end
    commandline -f cancel-commandline
end

bind \cc __term_ssh_ctrl_c

function __term_ssh_bg_reset --on-event fish_exit --description "Reset terminal background after SSH"
    set -l force 0
    if test (count $argv) -gt 0; and test "$argv[1]" = "--force"
        set force 1
    end

    if not __term_supports_osc11
        return
    end

    if test $force -ne 1; and not set -q SSH_CONNECTION
        return
    end

    if set -q TERM_SSH_BG_RESET
        printf '\e]11;%s\a' "$TERM_SSH_BG_RESET"
    else
        printf '\e]111\a'
    end
    set -g __term_ssh_bg_active 0
end

__term_ssh_bg

function __term_wrap_ssh --on-event fish_prompt --description "Wrap ssh for terminal bg color"
    if functions -q __term_ssh_wrapped
        return
    end

    if not command -q ssh
        return
    end

    set -g __term_use_ssh_function 0
    if functions -q ssh
        functions -c ssh __term_ssh_orig
        functions -e ssh
        set -g __term_use_ssh_function 1
    end

    function ssh --wraps=__term_ssh_orig --description "SSH with terminal background color per target"
        set -l host ""
        set -l skip_next 0
        set -l after_ddash 0

        for arg in $argv
            if test $skip_next -eq 1
                set skip_next 0
                continue
            end

            if test "$arg" = "--"
                set after_ddash 1
                continue
            end

            if test $after_ddash -eq 0; and string match -q -- "-*" $arg
                switch $arg
                    case "-b" "-c" "-D" "-E" "-e" "-F" "-I" "-i" "-J" "-L" "-l" "-m" "-O" "-o" "-p" "-Q" "-R" "-S" "-W" "-w"
                        set skip_next 1
                        continue
                    case "-b*" "-c*" "-D*" "-E*" "-e*" "-F*" "-I*" "-i*" "-J*" "-L*" "-l*" "-m*" "-O*" "-o*" "-p*" "-Q*" "-R*" "-S*" "-W*" "-w*"
                        continue
                    case "-B" "-G" "-K" "-M" "-N" "-n" "-T" "-t" "-v" "-V" "-x" "-X" "-Y" "-y" "-q" "-f" "-g" "-k"
                        continue
                end
            end

            if test -z "$host"
                set host $arg
                break
            end
        end

        if __term_supports_osc11; and test -n "$host"
            set -l host_only (string split "@" -- $host)[-1]
            set -l resolved ""

            if command -q getent
                set resolved (getent ahosts $host_only 2>/dev/null | awk 'NR==1 {print $1}')
            end

            if test -z "$resolved"; and command -q host
                set resolved (host $host_only 2>/dev/null | awk '/has address/ {print $4; exit}')
            end

            if test -n "$resolved"
                __term_bg_set_from_ip $resolved
            end
        end

        set -g __term_ssh_in_progress 1
        if test $__term_use_ssh_function -eq 1
            __term_ssh_orig $argv
        else
            command ssh $argv
        end
        set -l ssh_status $status

        if __term_supports_osc11
            __term_ssh_bg_reset --force
        end
        set -g __term_ssh_in_progress 0

        return $ssh_status
    end

    function __term_ssh_wrapped --description "Marker for wrapped ssh"
    end
end
