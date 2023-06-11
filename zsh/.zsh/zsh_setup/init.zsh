
autoload -Uz compinit && compinit

setopt APPEND_HISTORY
setopt SHARE_HISTORY

HISTFILE=~/.config/.zsh/.histfile
HISTSIZE=999
SAVEHIST=1000

# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST
setopt EXTENDED_HISTORY

# ignore multiple dups in the same session
setopt hist_ignore_all_dups


