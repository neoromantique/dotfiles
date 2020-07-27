export GOPATH=$HOME/gocode
export PATH=$PATH:$GOPATH/bin:/home/david/Scripts

PS1=$'%{\e[0;93m%}%n%{\e[0m%}@%{\e[1;96m%}%M%{\e[0m%} %B%d%b | '

alias j=jumpy
alias ja=jumpy -a --as
alias jd=jumpy -d

GREEN='\033[0;32m'
NC='\033[0m' # No Color

alias moc="mocp"
alias mt="neomutt"

alias wacomMap="xsetwacom --set '14' MapToOutput HEAD-0"

alias scrot='scrot -s ~/Pictures/Screenshots/%b%d%H%M%S.png'

alias mem='smem -rk'

alias ss="sshch"

export PATH=/home/david/.local/bin:$PATH

alias dump="HASTE_SERVER=https://dump.aizenberg.co.uk haste"

alias ports='sudo netstat -nape --inet'  #Network mon. aliases.
alias opennet='lsof -i'
alias ping='ping -c 4'
alias ns='sudo netstat -alnp --protocol=inet'

alias reload='source ~/.zshrc'     # reload config.
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

alias 2c='rclone -P -v --exclude "**/.thumbnail/**" sync ~/Cloud/ b2://neohomeBkt'
alias c2='rclone -P -v --exclude "**/.thumbnail/**" sync b2://neohomeBkt ~/Cloud/'

alias 2p='rclone -P -v --exclude "**/.thumbnail/**" sync ~/Public/ b2://neoPublicBkt'
alias p2='rclone -P -v --exclude "**/.thumbnail/**" sync b2://neoPublicBkt ~/Public/'

fullsync() {
	echo -e "${GREEN} ☑ Upload to Pvt ${NC}";
	2c;
	echo -e "${GREEN} ☑ Download from Pvt ${NC}";
	c2;
	echo -e "${GREEN} ☑ Upload to Public ${NC}";
	2p;
	echo -e "${GREEN} ☑ Download from Pvt ${NC}";
	p2;
}

alias makethumbs="find . -type f -iname \*.jpg -exec convert {} -resize 200x200\> -set filename:name '%t' '%[filename:name]_thumb.jpg' \;"

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
    vim ~/Dropbox/logbooks/$(date '+%d-%m-%Y').md
}

# Get IP (call with myip)
alias myip="curl http://ipecho.net/plain; echo"



export PY_USER_BIN=$(python3 -c 'import site; print(site.USER_BASE + "/bin")')
export PATH=$PY_USER_BIN:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# Yavide alias
alias yavide="gvim --servername yavide -f -N -u /opt/yavide/.vimrc"

alias screenoff="sleep 1 ; xset dpms force off"

alias t="clear; python3 ~/t/t.py --task-dir ~/Dropbox --list tasks"
function ta() {
    t "$1"
    t
}
function tf() {
    t -f "$1"
    t
}


# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
alias moc='mocp --theme=transparent-background'

