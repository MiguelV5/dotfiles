

# --- IMPORTANT NOTE: the following functionality is distro-dependent due to differences in key codes. ---
# --- In particular, I will mark the following code to denote whether it works on Ubuntu 22.04 LTS or in my Fedora 38 VM ---

# General note:  
# UBUNTU= \e[OA (left arrow), \e[OB (right arrow), \e[OF (start of line), \e[OH (end of line) ;    
# FEDORA(vm)= \e[A (left arrow), \e[B (right arrow), \e[F (start of line), \e[H (end of line) ;
# Having this into account, the following code works in both distros (remember to remove/add the 'O'): 
bindkey '\e[OH' beginning-of-line
bindkey '\e[OF' end-of-line

# However, the direct usage of bindkeys for history searching:
#
# bindkey '\e[A' history-beginning-search-backward   
# bindkey '\e[B' history-beginning-search-forward 
#
# does NOT work all the time in Ubuntu.
# Thus, UBUNTU uses the following workaround:

# start typing + [Up-Arrow] - fuzzy find history forward
if [[ "${terminfo[kcuu1]}" != "" ]]; then
    autoload -U up-line-or-beginning-search
    zle -N up-line-or-beginning-search
    bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
# start typing + [Down-Arrow] - fuzzy find history backward
if [[ "${terminfo[kcud1]}" != "" ]]; then
    autoload -U down-line-or-beginning-search
    zle -N down-line-or-beginning-search
    bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
fi


# Also, the direct usage of bindkeys backward-word and forward-word:
#
# bindkey '\e[1;5C' forward-word
# bindkey '\e[1;5D' backward-word
#
# only applies to FEDORA(vm), so UBUNTU uses the following:

# Ctrl+Backspace
backward-kill-dir () {
    local WORDCHARS=${WORDCHARS/\/}
    zle backward-kill-word
    zle -f kill  # Ensures that after repeated backward-kill-dir, Ctrl+Y will restore all of them.
}
zle -N backward-kill-dir
bindkey '^H' backward-kill-dir


# Ctrl+Left
backward-word-dir () {
    local WORDCHARS=${WORDCHARS/\/}
    zle backward-word
}
zle -N backward-word-dir
bindkey '\e[1;5D' backward-word-dir


# Ctrl+Right
forward-word-dir () {
    local WORDCHARS=${WORDCHARS/\/}
    zle forward-word
}
zle -N forward-word-dir
bindkey '\e[1;5C' forward-word-dir

