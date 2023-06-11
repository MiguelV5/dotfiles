#init completions (FEDORA)
autoload -Uz compinit && compinit

#CONFIGS ADICIONALES PARA FEDORA:
setopt APPEND_HISTORY
setopt SHARE_HISTORY

HISTFILE=~/.config/.zsh/.histfile
HISTSIZE=999
SAVEHIST=1000

#CONFIGS AD. PARA FED.:
setopt HIST_EXPIRE_DUPS_FIRST
setopt EXTENDED_HISTORY

# para ignorar multiples dups en una misma sesion de shell
setopt hist_ignore_all_dups





#____________________________________//______________________________________
# CONFIGURACIONES ADICIONALES DE ZSH:



#___________________________
# COMPLETIONS


# custom env var ls colors
LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:'


# Enable menulike completion with tab
zstyle ':completion:*' menu yes select

# Enable completion without case sensitive search at tabulation
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*' 

# colorize the cd and ls autocompletion colors with tab
zstyle ':completion:*:default' list-colors "${(s.:.)LS_COLORS}"

# init completions (UBUNTU)

#OBS: EN UBUNTU ANTES DEL COMP OPTIONS ESTA EL INIT. MOVIDO PARA ARRIBA DE TODO

_comp_options+=(globdots)		# Include hidden files.




#___________________________
# HISTORY SEARCHING


# (OLD, el termninfo no funca en fedora asi que preferi mantener a ambos con la version nueva de abajo):
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

# UPDATED (Junto con las configs detalladas arriba de todo)
# Obs:  UBUNTU= \e[0A , \e[0B , ... , ^H   ;    FEDORA(vm)= \e[A , \e[B , ... , \e(???? -> falta probar)   ;
# Obs2: A veces no funciona en ubuntu entonces descomenté el OLD ^

#bindkey '\e[OA' history-beginning-search-backward
#bindkey '\e[OB' history-beginning-search-forward

# extras
bindkey '\e[OH' beginning-of-line
bindkey '\e[OF' end-of-line

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



#___________________________
# EXPORTS 
#Hide username at terminal:
#export DEFAULT_USER="$(whoami)"

#Golang PATH:
export GOPATH=~/go
# export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
# Comentado por ahora, verificar si no causa problemas despues
export PATH=$PATH:/home/miguelv5/.local/bin





#___________________________
# PREV CONFIGS

#Disabñe ctrl-s to freeze terminal:
stty stop undef

autoload -Uz colors && colors    # Colors





#___________________________
# THEME

source ~/.config/.zsh/agnoster_custom.zsh-theme





#___________________________
# SOURCE PLUGINS

# source ~/.config/.zsh/zsh_plugins/.plugin.zsh

source ~/.config/.zsh/zsh_plugins/colored-man-pages.plugin.zsh
source ~/.config/.zsh/zsh_plugins/zsh-aliases-ls.plugin.zsh

# este tiene que ser el ultimo
source ~/.config/.zsh/zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh




#____________________________________//______________________________________








