# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '
#PS1='[\u@\h \W]\$ '

HISTSIZE=
HISTFILESIZE=
HISTTIMEFORMAT="%d.%m.%y %T "
HISTCONTROL=ignoreboth
shopt -s histappend

alias ll='ls -ahl'
alias nano='nano -$ -i'
PATH=$PATH:/home/lukas/bin

# added by travis gem
[ -f /home/lukas/.travis/travis.sh ] && source /home/lukas/.travis/travis.sh

# added for "fuck"-command
# eval $(thefuck --alias)

export EDITOR=nano;
