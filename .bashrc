
 ################################
 # 2014. WTFPL.                 #
 #.bashrc by David Aizenberg    #
 # david.aizenberg@paranoici.org# 
 ################################





#Here goes custom stuff by David.


#Thanks to http://bashrcgenerator.com/
export PS1="\[\e[00;32m\]\u\[\e[0m\]\[\e[00;37m\]@\h:\[\e[0m\]\[\e[00;36m\][\[\e[0m\]\[\e[00;32m\]\w\[\e[0m\]\[\e[00;36m\]]\[\e[0m\]\[\e[00;37m\]\\$ \[\e[0m\]"



alias ls='ls -hF --color'    # add colors for filetype recognition
alias la='ls -Al'        # show hidden files
alias tree='tree -Cs'        # nice alternative to 'ls'
alias rm='rm -i'            # better safe than sorry.
alias cp='cp -i'            # ^
alias mv='mv -i'            # ^
alias ..='cd ..'            # convinient navigation
alias vi='vim'              # Also convinient

alias ports='netstat -nape --inet'  #Network mon. aliases.
alias opennet='lsof -i'
alias ping='ping -c 4'
alias ns='netstat -alnp --protocol=inet'

alias reload='source ~/.bashrc'     # reload bash config.


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

