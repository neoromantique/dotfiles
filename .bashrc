
 ################################
 # 2018. WTFPL.                 #
 #.bashrc by David Aizenberg    #
 # david.aizenberg@paranoici.org# 
 ################################


#Exports
EDITOR=vim


#Thanks to http://bashrcgenerator.com/
export PS1="\[\e[00;32m\]\u\[\e[0m\]\[\e[00;37m\]@\h:\[\e[0m\]\[\e[00;36m\][\[\e[0m\]\[\e[00;32m\]\w\[\e[0m\]\[\e[00;36m\]]\[\e[0m\]\[\e[00;37m\]\\$ \[\e[0m\]"


#Aliases
alias ls='ls -hF --color'    # add colors for filetype recognition
alias la='ls -Al'        # show hidden files
alias tree='tree -Cs'        # nice alternative to 'ls'
alias rm='rm -i'            # better safe than sorry.
alias cp='cp -i'            # ^
alias mv='mv -i'            # ^
alias ..='cd ..'            # convinient navigation
alias vi='vim'              # Also convinient

alias scrot="scrot -s /tmp/screenshot-$(date +%F_%T).png -e 'xclip -selection c -t image/png < $f' &>/dev/null"
alias ss='sshch'

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

alias du="ncdu --color dark -rr -x --exclude .git --exclude node_modules"

#Automatically do an ls after each cd
cd() {
  if [ -n "$1" ]; then
     builtin cd "$@" && ls -hF
  else
     builtin cd ~ && ls -hF
  fi
}


# Logbook 
# Idea taken from: https://news.ycombinator.com/item?id=17064520

lb() {
    vim ~/Dropbox/logbooks/$(date '+%d-%m-%Y').md 
} 

# Get IP (call with myip)
function myip {
      myip=`elinks -dump http://checkip.dyndns.org:8245/`
        echo "${myip}"
}
if [ -f /etc/bash_completion ]; then
 . /etc/bash_completion
fi

export PY_USER_BIN=$(python -c 'import site; print(site.USER_BASE + "/bin")')
export PATH=$PY_USER_BIN:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# Yavide alias
alias yavide="gvim --servername yavide -f -N -u /opt/yavide/.vimrc"

alias t="clear; python ~/t/t.py --task-dir ~/Dropbox --list tasks"
function ta() {
    t "$1"
    t
}
function tf() {
    t -f "$1"
    t
}
# include .bashrc helpers if they exist (Non-Open Source helpers)
if [ -f $HOME/.bash_helpers ]; then
    . $HOME/.bash_helpers
fi

alias screen_record='bash screen_record.sh'
