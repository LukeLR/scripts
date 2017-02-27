#command echo
#command echo "*********************"
#command echo "**** Viel Spass! ****"
#command echo "*********************"

#
# ~/.bashrc
#

#command fortune | cowsay | lolcat
#20161031: advanced fortune command, as in https://wiki.archlinux.org/index.php/Fortune
export cowsaycow="$(shuf -n 1 -e $(cowsay -l | tail -n +2))"
#command echo This is $cowsaycow
#command fortune | $(shuf -n 1 -e cowsay cowthink) -$(shuf -n 1 -e b d g p s t w y) -f $cowsaycow -n
#command fortune | $(shuf -n 1 -e cowsay cowthink) -n | lolcat

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

HISTSIZE=
HISTFILESIZE=
HISTTIMEFORMAT="%d.%m.%y %T "
alias ll='ls -ahl'
PATH=$PATH:/home/lukas/bin

# added by travis gem
[ -f /home/lukas/.travis/travis.sh ] && source /home/lukas/.travis/travis.sh

# added for "fuck"-command
eval $(thefuck --alias)

export EDITOR=nano;
