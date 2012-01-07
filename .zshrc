# DESCRIPTION:
#   A simple zsh configuration that gives you 90% of the useful features that I use everyday.
#
# AUTHOR:
#   Geoffrey Grosenbach http://peepcode.com


# RVM or rbenv
function ruby_prompt(){
  rv=$(rbenv version-name)
  if (echo $rv &> /dev/null)
  then
    echo "%{$fg_bold[gray]%}ruby $rv%{$reset_color%}"
  elif $(which rvm &> /dev/null)
  then
    echo "%{$fg_bold[gray]%}$(rvm tools identifier)%{$reset_color%}"
  else
    echo ""
  fi
}

# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
function git_time_since_commit() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    # Only proceed if there is actually a commit.
    if [[ $(git log 2>&1 > /dev/null | grep -c "^fatal: bad default revision") == 0 ]]; then
      # Get the last commit.
      last_commit=`git log --pretty=format:'%at' -1 2> /dev/null`
      now=`date +%s`
      seconds_since_last_commit=$((now-last_commit))

      # Totals
      MINUTES=$((seconds_since_last_commit / 60))
      HOURS=$((seconds_since_last_commit/3600))

      # Sub-hours and sub-minutes
      DAYS=$((seconds_since_last_commit / 86400))
      SUB_HOURS=$((HOURS % 24))
      SUB_MINUTES=$((MINUTES % 60))

      if [[ -n $(git status -s 2> /dev/null) ]]; then
        if [ "$MINUTES" -gt 30 ]; then
          COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG"
        elif [ "$MINUTES" -gt 10 ]; then
          COLOR="$ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM"
        else
          COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT"
        fi
      else
        COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
      fi

      if [ "$HOURS" -gt 24 ]; then
        echo "($COLOR${DAYS}d${SUB_HOURS}h${SUB_MINUTES}m%{$reset_color%}|"
      elif [ "$MINUTES" -gt 60 ]; then
        echo "($COLOR${HOURS}h${SUB_MINUTES}m%{$reset_color%}|"
      else
        echo "($COLOR${MINUTES}m%{$reset_color%}|"
      fi
    else
      COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
      echo "($COLOR~|"
    fi
  fi
}

# Colors
autoload -U colors
colors
setopt prompt_subst
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"

# Text to display if the branch is dirty
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} *%{$reset_color%}"

# Text to display if the branch is clean
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Colors vary depending on time lapsed.
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[cyan]%}"

# Prompt
local smiley="%(?,%{$fg[green]%}☺%{$reset_color%},%{$fg[red]%}☹%{$reset_color%})"

PROMPT='
%~
$( git_time_since_commit ) ${smiley}  %{$reset_color%}'

RPROMPT='%{$fg[white]%} $(ruby_prompt)$(~/bin/git-cwd-info.rb)%{$reset_color%}'

# Show completion on first TAB
setopt menucomplete

# Load completions for Ruby, Git, etc.
autoload compinit
compinit

# case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# aliases
alias ls="ls -G"

# Git aliases
alias gplod="git pull origin development"
alias gplom="git pull origin master"
alias gpsod="git push origin development"
alias gpsom="git push origin master"
