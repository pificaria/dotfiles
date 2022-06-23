#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# source <(kitty + complete setup bash)

export ALTERNATE_EDITOR="emacs"
export EDITOR="nvim" 
export VISUAL="nvim"  
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_COMPLETION_TRIGGER="**"

# function settitle () {
#     export PREV_COMMAND=${PREV_COMMAND}${@}
# 	printf "\033]0;%s\007" "${BASH_COMMAND//[^[:print:]]/}"
#     export PREV_COMMAND=${PREV_COMMAND}' | '
# }
# 
# if [[ $TERM =~ "xterm|*rxvt*" ]]; then
# 	export PROMPT_COMMAND=${PROMPT_COMMAND}';export PREV_COMMAND=""'
# 	trap 'settitle "$BASH_COMMAND"' DEBUG
# fi

export PATH="$HOME/.cargo/bin:$PATH"

MAIL=/var/spool/mail/nil && export MAIL
alias ls='ls --color=auto'
alias emacsnw='emacs -nw'
alias emacsclX='emacsclient -c'
alias emacscl='emacsclient -nw -c'
alias seemail='emacs -nw -f notmuch'
alias julia='/usr/lib64/julia-1.4.0/bin/julia'
PS1='\w \$ '
alias nvr='$HOME/.local/bin/nvr'

# no double entries in the shell history
export HISTCONTROL="$HISTCONTROL erasedups:ignoreboth"

# do not overwrite files when redirecting output by default.
set -o noclobber

# wrap these commands for interactive use to avoid accidental overwrites.
rm() { command rm -i "$@"; }
cp() { command cp -i "$@"; }
mv() { command mv -i "$@"; }

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

_fzf_setup_completion path mplayer

eval $($HOME/.local/bin/opam env)
