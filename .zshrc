
 ################################
 # WTFPL.                       #
 # .zshrc of David Aizenberg    #
 # david.aizenberg@paranoici.org# 
 ################################


#Exports
EDITOR=nvim

# Set Terminal Background so I know I'm SSH'd
echo -e "\033]11;#141414\a"

alias vim='nvim'

alias ls='ls -hF --color'   # add colors for filetype recognition
alias la='ls -Al'           # show hidden files
alias tree='tree -Cs'       # nice alternative to 'ls'
alias rm='rm -i'            # better safe than sorry.
alias cp='cp -i'            # ^
alias mv='mv -i'            # ^
alias ..='cd ..'            # convenience
alias vi='vim'              # It ain't 1977 anymore

alias lsblk='lsblk -o name,mountpoint,label,size,fstype,uuid | egrep -v "^loop"'

alias ports='sudo netstat -nape --inet'  #Network mon.
alias opennet='lsof -i'
alias ping4='ping -c 4'
alias ns='sudo netstat -alnp --protocol=inet'

alias did="vim +'normal Go' +'r!date' ~/did.txt"

alias genpass="apg -a 1 -M lnc -n 9 -m 26"

export GOPATH=$HOME/go
PATH=$GOPATH/bin:/home/neo/mongoClient::$PATH

source /etc/profile.d/go.sh
source ~/.private.env

export PATH="${PATH}:${HOME}/.krew/bin"

alias ktx='kubectx'
alias knx='kubens'

alias doom="~/.emacs.d/bin/doom"

setopt no_flow_control
function rename() {
    echo "Renaming window to $1"
    tmux rename-window $1
}

function fzf-ssh () {
  local selected_host=$(grep "Host " ~/.ssh/config | grep -v '*' | cut -b 6- | fzf --query "$LBUFFER" --prompt="SSH Remote > ")

  if [ -n "$selected_host" ]; then
    tmux rename-window "Remote -- $selected_host"
    BUFFER="ssh ${selected_host} ; tmux rename-window dc"
    zle accept-line
  fi
  zle reset-prompt
}

# src: https://stackoverflow.com/a/59412853
function seecert () {
  nslookup $1
  (openssl s_client -showcerts -servername $1 -connect $1:443 <<< "Q" | openssl x509 -text | grep -iA2 "Validity")
}

zle -N fzf-ssh
bindkey '^o' fzf-ssh


# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"


# Logbook 
# Idea taken from: https://news.ycombinator.com/item?id=17064520
lb() {
    vim ~/Dropbox/logbooks/$(date '+%Y-%m-%d').md 
} 

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

export PY_USER_BIN=$(python3 -c 'import site; print(site.USER_BASE + "/bin")')
export PATH=$PY_USER_BIN:$PATH

alias repl="NODE_PATH=$(npm root -g) node"

# ZIM Default Config

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
zstyle ':zim:git' aliases-prefix 'g'

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

# https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key
# }}} End configuration added by Zim install



# Scaleway CLI autocomplete initialization.
eval "$(scw autocomplete script shell=zsh)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/neo/micromamba/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/neo/micromamba/etc/profile.d/conda.sh" ]; then
        . "/home/neo/micromamba/etc/profile.d/conda.sh"
    else
        export PATH="/home/neo/micromamba/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Init Jump
eval "$(jump shell)"

