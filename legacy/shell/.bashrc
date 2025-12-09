
 ################################
 # 2018. WTFPL.                 #
 #.bashrc by David Aizenberg    #
 # david.aizenberg@paranoici.org# 
 ################################


#Exports
EDITOR=nvim

alias vim='nvim'

getCurrentSKMKey() {
    if ! command -v skm &> /dev/null
    then
     echo "none"
    else
        skm ls | grep -e '->' | awk '{print $2}'
    fi
}

export PS1='`date +'%H:%M'`:[\h]|\e[00;33m\]🔑`getCurrentSKMKey`\e[00;0m\]|`pwd` \n\[\e[00;32m\]\u\[\e[0m\]\[\e[00;37m\]$ '

#Aliases
alias ls='ls -hF --color'    # add colors for filetype recognition
alias la='ls -Al'        # show hidden files
alias tree='tree -Cs'        # nice alternative to 'ls'
alias rm='rm -i'            # better safe than sorry.
alias cp='cp -i'            # ^
alias mv='mv -i'            # ^
alias ..='cd ..'            # convinient navigation
alias vi='vim'              # Also convinient

alias lsblk='lsblk -o name,mountpoint,label,size,fstype,uuid | egrep -v "^loop"'

alias ss='sshch'
alias rtv='rtv --enable-media'

alias moc='mocp --theme=transparent-background'

alias dump="HASTE_SERVER=https://dump.aizenberg.co.uk haste"

alias ports='sudo netstat -nape --inet'  #Network mon. aliases.
alias opennet='lsof -i'
alias ping='ping -c 4'
alias ns='sudo netstat -alnp --protocol=inet'

alias reload='source ~/.bashrc'     # reload bash config.
alias kb="setxkbmap -layout gb,ru -option -option grp:caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
alias g='grep'

#Git specific aliases

alias store='git config credential.helper store'
alias gcl='git clone'
alias ga='git add'
alias gr='git reset HEAD'
alias gitwipe='git reset --hard && git clean -dfx'
alias get='git'
alias gst='git status'
alias pull='git pull'
alias push='git push'
alias commit='git commit -v -m'
alias checkout='git checkout'
alias master='git checkout master'
alias blame='git log --graph --pretty=oneline --abbrev-commit'

alias did="vim +'normal Go' +'r!date' ~/did.txt"

alias du="ncdu -rr -x --exclude .git --exclude node_modules"

alias fixtouch="xinput map-to-output 9 eDP-1"

#Automatically do an ls after each cd
cd() {
  if [ -n "$1" ]; then
     builtin cd "$@" && ls -hF
  else
     builtin cd ~ && ls -hF
  fi
}

rain() {
curl -4 http://wttr.in/$1
}

# Logbook 
# Idea taken from: https://news.ycombinator.com/item?id=17064520

lb() {
    vim ~/Dropbox/logbooks/$(date '+%Y-%m-%d').md 
} 

# Get IP (call with myip)
alias myip="curl http://ipecho.net/plain; echo"

if [ -f /etc/bash_completion ]; then
 . /etc/bash_completion
fi

export PY_USER_BIN=$(python3 -c 'import site; print(site.USER_BASE + "/bin")')
export PATH=$PY_USER_BIN:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# Yavide alias
alias yavide="gvim --servername yavide -f -N -u /opt/yavide/.vimrc"

# alias t="clear; python ~/t/t.py --task-dir ~/b2_sync/t --list tasks"
# alias tw="t | grep 'verify'"

alias t="clear; todoist list --filter '(overdue | today | tomorrow) | p1'"

# function ta() {
#     t "$1"
#     t
# }
# function tf() {
#     t -f "$1"
#     t
# }


# include .bashrc helpers if they exist (Non-Open Source helpers)
if [ -f $HOME/.bash_helpers ]; then
    . $HOME/.bash_helpers
fi


alias genpass="apg -a 1 -M lnc -n 9 -m 26"

alias screen_record='bash screen_record.sh'
export GOPATH=$HOME/go
PATH=$GOPATH/bin:$PATH

source /etc/profile.d/go.sh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "/etc/profile.d/grc.bashrc" ]] && source /etc/profile.d/grc.bashrc

alias repl="NODE_PATH=$(npm root -g) node"

# Scaleway CLI autocomplete initialization.
eval "$(scw autocomplete script shell=bash)"

# Reset bg to black
echo -e "\033]11;#000000\a"



# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE="$HOME/.micromamba/bin/micromamba";
export MAMBA_ROOT_PREFIX="$HOME/micromamba";
__mamba_setup="$('$HOME/.micromamba/bin/micromamba' shell hook --shell bash --prefix '$HOME/micromamba' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    if [ -f "$HOME/micromamba/etc/profile.d/micromamba.sh" ]; then
        . "$HOME/micromamba/etc/profile.d/micromamba.sh"
    else
        export  PATH="$HOME/micromamba/bin:$PATH"  # extra space after export prevents interference from conda init
    fi
fi
unset __mamba_setup
# <<< mamba initialize <<<

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$HOME/micromamba/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/micromamba/etc/profile.d/conda.sh" ]; then
        . "$HOME/micromamba/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/micromamba/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

