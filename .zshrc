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

# Colors
autoload -U colors
colors
setopt prompt_subst

# Prompt
local smiley="%(?,%{$fg[green]%}☺%{$reset_color%},%{$fg[red]%}☹%{$reset_color%})"

PROMPT='
%~
${smiley}  %{$reset_color%}'

RPROMPT='%{$fg[white]%} $(ruby_prompt)$(~/bin/git-cwd-info.rb)%{$reset_color%}'

# Show completion on first TAB
setopt menucomplete

# Load completions for Ruby, Git, etc.
autoload compinit
compinit

# case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
