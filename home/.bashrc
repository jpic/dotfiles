# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#echo 250 | sudo tee /sys/devices/platform/i8042/serio1/serio2/sensitivity &> /dev/null &
#echo 250 | sudo tee /sys/devices/platform/i8042/serio1/serio2/speed &> /dev/null &

export PATH=$PATH:$HOME/.emacs.d/bin:$HOME/.local/bin:$PATH
export NODE_PATH=$HOME/.local/lib/node_modules:$NODE_PATH
export npm_config_prefix=$HOME/.local

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=80000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

function cd() {
    builtin cd "$@";
    if [ -f env/bin/activate ]
    then
        source env/bin/activate
    elif [ -f bin/activate ]
    then
        source bin/activate
    elif [ -f ../env/bin/activate ]
    then
        source ../env/bin/activate
    fi
}

        RED="\[\033[0;31m\]"
     YELLOW="\[\033[1;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[1;34m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"
 #PURPLE="\[\033[0;57;40m\]"
PURPLE="\e[38;5;171m"

# Return the prompt symbol to use, colorized based on the return value of the
# previous command.
function set_prompt_symbol () {
  if test $1 -eq 0 ; then
      PROMPT_SYMBOL="\$"
  else
      PROMPT_SYMBOL="${LIGHT_RED}\$${COLOR_NONE}"
  fi
}

# Determine active Python virtualenv details.
function set_virtualenv () {
  if test -z "$VIRTUAL_ENV" ; then
      PYTHON_VIRTUALENV=""
  else
      PYTHON_VIRTUALENV="${BLUE}[`basename \"$VIRTUAL_ENV\"`]${COLOR_NONE} "
  fi
}

source ~/.git-prompt.sh

# Set the full bash prompt.
function set_bash_prompt () {
  # Set the PROMPT_SYMBOL variable. We do this first so we don't lose the
  # return value of the last command.
  set_prompt_symbol $?

  # Set the PYTHON_VIRTUALENV variable.
  set_virtualenv

  BRANCH=$(__git_ps1 " (%s)")
  # Set the bash prompt variable.
  PS1="
${PYTHON_VIRTUALENV}$(date +'%d/%m %Y %H:%M:%S') ${PURPLE}\u@\h ${YELLOW}\w${COLOR_NONE} ${BRANCH}
${PROMPT_SYMBOL} "
}

# Tell bash to execute this function just before displaying its prompt.
PROMPT_COMMAND=set_bash_prompt
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

export PAGER="most"
#export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
export EDITOR=vim

export MARKPATH=$HOME/.marks
function jump {
    cd -P $MARKPATH/$1 2>/dev/null || echo "No such mark: $1"
}
function mark {
    mkdir -p $MARKPATH; ln -s $(pwd) $MARKPATH/$1
}
function unmark {
    rm -i $MARKPATH/$1
}
function marks {
    ls -l $MARKPATH | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}

export GOPATH=~/go
export PATH=$PATH:$HOME/bin:$HOME/.local/bin/:$HOME/.bin:/usr/lib/node_modules/:$GOPATH/bin

alias msfconsole="ruby-1.9 $HOME/sploits/metasploit-framework/msfconsole --quiet -x \"db_connect ${USER}@msf\""

PATH="/home/jpic/perl5/bin${PATH+:}/home/jpic/.gem/ruby/2.3.0/bin${PATH+:}/home/jpic/.gem/ruby/2.2.0/bin${PATH+:}${PATH}"; export PATH;
PERL5LIB="/home/jpic/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/jpic/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/jpic/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/jpic/perl5"; export PERL_MM_OPT;
export PYTHONSTARTUP=~/.pythonrc

alias s="sudo -sE"

GPG_TTY=$(tty)
export GPG_TTY

alias aoeu="setxkbmap fr"
alias qsdf="source ~/.keyboardrc"
alias asdf="source ~/.keyboardrc"

alias gap="git add -p"
alias gcl="git clone"
alias gco="git checkout"
alias gcm="git commit -m"
alias gpl="git pull"
alias gps="git push"
alias gst="git status"
alias gcp="git cherry-pick"
alias gri="git rebase -i"
alias gdc="git diff --cached"
alias grc="git rebase --continue"
alias gca="git commit --amend"
function ggc() {
    git clone git@github.com:${1}.git
    pushd $1
}

# added by travis gem
[ -f /home/jpic/.travis/travis.sh ] && source /home/jpic/.travis/travis.sh

if [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    echo exec startx
elif [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]] && [[ -z $XDG_SESSION_TYPE ]]; then
    XDG_SESSION_TYPE=wayland exec dbus-run-session gnome-session
elif [[ -z "$SUDO_USER" ]]; then
    export GPG_TTY=$(tty)
    #eval `keychain --eval id_rsa --agents ssh`
    #eval $(gpg-agent --daemon)
fi

#export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export HUSKY_SKIP_HOOKS=1

export PATH="$HOME/.cargo/bin/:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

alias hpscan="hp-scan -d 'hpaio:/net/HP_Color_LaserJet_MFP_M277dw?ip=172.24.100.16' -a0,0,500,500"

#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias pacman="sudo pacman"
export PIPENV_VENV_IN_PROJECT=1

alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ip='ip -color=auto'
alias colors='(x=`tput op` y=`printf %76s`;for i in {0..256};do o=00$i;echo -e ${o:${#o}-3:3} `tput setaf $i;tput setab $i`${y// /=}$x;done)'

alias badssh="ssh -oStrictHostKeyChecking=no"


emac() {
    emacsclient -nw $@
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh
