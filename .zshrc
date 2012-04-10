# DESCRIPTION:
#   A simple zsh configuration that gives you 90% of the useful features that I use everyday.
#
# AUTHOR:
#   Geoffrey Grosenbach http://peepcode.com

############
# FUNCTIONS
############

# RVM or rbenv
function ruby_prompt(){
  if $(which rvm &> /dev/null)
  then
    echo "%{$fg_bold[gray]%}$(rvm tools identifier)%{$reset_color%}"
  else
    echo ""
  fi
}

# Current path color depending on last command exit status
local current_path="%(?,%{$fg[gray]%}%~%{$reset_color%},%{$fg[red]%}%~%{$reset_color%})"

# mkdir & cd to it
function mcd() {
  mkdir -p "$1" && cd "$1";
}

#########
# COLORS
#########

autoload -U colors
colors
setopt prompt_subst

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"

# Text to display if the branch is dirty
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} *%{$reset_color%}"

# Text to display if the branch is clean
ZSH_THEME_GIT_PROMPT_CLEAN=""

#########
# PROMPT
#########

PROMPT='%{$fg[cyan]%}${current_path}%{$fg[white]%}%{$fg[white]%}[$(~/bin/git-cwd-info)%{$reset_color%}] $ '

#############
# COMPLETION
#############

# Show completion on first TAB
setopt menucomplete

# load autocompletion
autoload -U compinit && compinit

# enable cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# ignore completion to commands we don't have
zstyle ':completion:*:functions' ignored-patterns '_*'

# format autocompletion style
zstyle ':completion:*:descriptions' format "%{$fg_bold[green]%}%d%{$reset_color%}"
zstyle ':completion:*:corrections' format "%{$fg_bold[yellow]%}%d%{$reset_color%}"
zstyle ':completion:*:messages' format "%{$fg_bold[red]%}%d%{$reset_color%}"
zstyle ':completion:*:warnings' format "%{$fg_bold[red]%}%d%{$reset_color%}"

# zstyle show completion menu if 2 or more items to select
zstyle ':completion:*'                        menu select=2

# zstyle kill menu
zstyle ':completion:*:*:kill:*'               menu yes select
zstyle ':completion:*:kill:*'                 force-list always
zstyle ':completion:*:*:kill:*:processes'     list-colors "=(#b) #([0-9]#)*=36=31"

# enable color completion
zstyle ':completion:*:default' list-colors "=(#b) #([0-9]#)*=$color[yellow]=$color[red]"

# fuzzy matching of completions for when we mistype them
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only

# number of errors allowed by _approximate increase with the length of what we have typed so far
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

##########
# ALIASES
##########

alias ls='ls -G'
alias ll='ls -lG'
alias duh='du -csh'
alias vim='/usr/local/bin/vim'

# Git aliases
alias gplod="git pull origin development"
alias gplom="git pull origin master"
alias gpsod="git push origin development"
alias gpsom="git push origin master"
alias glog="git log -p -40 | vim - -R -c 'set foldmethod=syntax'"

# Bundler
alias be="bundle exec"
alias bi="bundle install"

#######
# PATH
#######

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin

#######
# MISC
#######

# History
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.history

export EDITOR=/usr/local/bin/vim
export SHELL=/usr/local/bin/zsh

# Bundler
export USE_BUNDLER=force

# Emacs mode
bindkey -e

# Tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

# Autojump
if [ -f `brew --prefix`/etc/autojump ]; then
  . `brew --prefix`/etc/autojump
fi

