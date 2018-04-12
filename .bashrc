
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

#Add snapd to path
PATH=$PATH:/snap/bin

alias ports='sudo netstat -nape --inet'  #Network mon. aliases.
alias opennet='lsof -i'
alias ping='ping -c 4'
alias ns='sudo netstat -alnp --protocol=inet'

alias reload='source ~/.bashrc'     # reload bash config.

#Git specific aliases

alias gcl='git clone'
alias ga='git add'
alias gr='git reset HEAD'
alias gitwipe='git reset --hard && git clean -dfx'
alias g='git'
alias get='git'
alias gst='git status'
alias pull='git pull'
alias push='git push'
alias commit='git commit -v -m'
alias checkout='git checkout'
alias master='git checkout master'
alias blame='git log --graph --pretty=oneline --abbrev-commit'

#Automatically do an ls after each cd
cd() {
      if [ -n "$1" ]; then
              builtin cd "$@" && ls -hF
                else
                        builtin cd ~ && ls -hF
                          fi
}
# Get IP (call with myip)
function myip {
      myip=`elinks -dump http://checkip.dyndns.org:8245/`
        echo "${myip}"
}
if [ -f /etc/bash_completion ]; then
 . /etc/bash_completion
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

PATH="/home/neo/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/neo/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/neo/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/neo/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/neo/perl5"; export PERL_MM_OPT;
