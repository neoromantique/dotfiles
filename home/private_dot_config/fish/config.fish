# Man pages with bat
set -x MANROFFOPT "-c"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

# ~/.local/bin
fish_add_path -m $HOME/.local/bin

# LM Studio
fish_add_path $HOME/.lmstudio/bin

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
