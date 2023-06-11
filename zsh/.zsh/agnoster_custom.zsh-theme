# #
# # (My own modified version of) agnoster's Theme - https://gist.github.com/3712874
# # A Powerline-inspired theme for ZSH
# #
# # In order for this theme to render correctly, you will need a
# # [Powerline-patched font](https://github.com/Lokaltog/powerline-fonts).
# # Make sure you have a recent version: the code points that Powerline
# # uses changed in 2012, and older versions will display incorrectly,
# # in confusing ways.
# #
# # # Goals
# #
# # The aim of this theme is to only show you *relevant* information. Like most
# # prompts, it will only show git information when in a git working directory.
# # However, it goes a step further: everything from the current user and
# # hostname to whether the last call exited with an error to whether background
# # jobs are running in this shell will all be displayed automatically when
# # appropriate.


### Theme Configuration Initialization
#
# Override these settings in your ~/.zshrc

# 256-COLOR CHEATSHEET:  https://www.ditig.com/256-colors-cheat-sheet

# Current working directory
# originals == black; blue
: ${AGNOSTER_DIR_FG:=white} 
: ${AGNOSTER_DIR_BG:=17}

# user@host
# originals == default ; black
# 153 == lightskyblue
: ${AGNOSTER_CONTEXT_FG:=black}
: ${AGNOSTER_CONTEXT_BG:=255}

# Git related
# originals == black, green, yellow
: ${AGNOSTER_GIT_FG:=white}
: ${AGNOSTER_GIT_CLEAN_BG:=28} 
: ${AGNOSTER_GIT_DIRTY_BG:=240}

# Mercurial related
#: ${AGNOSTER_HG_NEWFILE_FG:=white}
#: ${AGNOSTER_HG_NEWFILE_BG:=red}
#: ${AGNOSTER_HG_CHANGED_FG:=black}
#: ${AGNOSTER_HG_CHANGED_BG:=yellow}
#: ${AGNOSTER_HG_CLEAN_FG:=black}
#: ${AGNOSTER_HG_CLEAN_BG:=green}

# VirtualEnv colors
#: ${AGNOSTER_VENV_FG:=black}
#: ${AGNOSTER_VENV_BG:=blue}

# Status symbols
#: ${AGNOSTER_STATUS_RETVAL_FG:=red}
#: ${AGNOSTER_STATUS_ROOT_FG:=yellow}
#: ${AGNOSTER_STATUS_JOB_FG:=cyan}
#: ${AGNOSTER_STATUS_BG:=black}

## Non-Color settings - set to 'true' to enable
# Show the actual numeric return value rather than a cross symbol.
#: ${AGNOSTER_STATUS_RETVAL_NUMERIC:=false}
# Show git working dir in the style "/git/root   master  relative/dir" instead of "/git/root/relative/dir   master"
#: ${AGNOSTER_GIT_INLINE:=false}




### Segments of the prompt, default order declaration

typeset -aHg AGNOSTER_PROMPT_SEGMENTS=(
    prompt_status
    prompt_context
    prompt_virtualenv
    prompt_dir
    prompt_git
    prompt_end
)

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='NONE'
if [[ -z "$PRIMARY_FG" ]]; then
	PRIMARY_FG=black
fi

# Characters
SEGMENT_SEPARATOR="\ue0b0"
PLUSMINUS="\u00b1"
BRANCH="\ue0a0"
DETACHED="\u27a6"
CROSS="\u2718"
LIGHTNING="\u26a1"
GEAR="\u2699"

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    print -n "%{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%}"
  else
    print -n "%{$bg%}%{$fg%}"
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && print -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    print -n "%{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    print -n "%{%k%}"
  fi
  print -n "%{%f%}"
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
# # PERSONAL EDIT: removed hostname. Original prompt's last segment: "%(!.%{%F{yellow}%}.)$user@%m"
prompt_context() {
  # old == `whoami`  <--- careful with the backticks
  local user="🐧"

  if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CONNECTION" ]]; then
    prompt_segment "$AGNOSTER_CONTEXT_BG" "$AGNOSTER_CONTEXT_FG" " %(!.%{%F{yellow}%}.)$user "
  fi
}


# Git: branch/detached head, dirty status
prompt_git() {
  local color ref
  is_dirty() {
    test -n "$(git status --porcelain --ignore-submodules)"
  }
  ref="$vcs_info_msg_0_"
  if [[ -n "$ref" ]]; then
    if is_dirty; then
      color="$AGNOSTER_GIT_DIRTY_BG"
      ref="${ref} $PLUSMINUS"
    else
      color="$AGNOSTER_GIT_CLEAN_BG"
      ref="${ref} "
    fi
    if [[ "${ref/.../}" == "$ref" ]]; then
      ref="$BRANCH $ref"
    else
      ref="$DETACHED ${ref/.../}"
    fi
    prompt_segment $color $AGNOSTER_GIT_FG
    print -n " $ref"
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment "$AGNOSTER_DIR_BG" "$AGNOSTER_DIR_FG" ' %~ '
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}$CROSS"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}$LIGHTNING"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}$GEAR"

  [[ -n "$symbols" ]] && prompt_segment $PRIMARY_FG default " $symbols "
}

# Display current virtual environment
prompt_virtualenv() {
  if [[ -n $VIRTUAL_ENV ]]; then
    color=cyan
    prompt_segment $color $PRIMARY_FG
    print -Pn " $(basename $VIRTUAL_ENV) "
  fi
}

## Main prompt
prompt_agnoster_main() {
  RETVAL=$?
  CURRENT_BG='NONE'
  for prompt_segment in "${AGNOSTER_PROMPT_SEGMENTS[@]}"; do
    [[ -n $prompt_segment ]] && $prompt_segment
  done
}

prompt_agnoster_precmd() {
  vcs_info
  PROMPT="%{%f%b%k%}$(prompt_agnoster_main) "
}

prompt_agnoster_setup() {
  autoload -Uz add-zsh-hook
  autoload -Uz vcs_info

  prompt_opts=(cr subst percent)

  add-zsh-hook precmd prompt_agnoster_precmd

  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:*' check-for-changes false
  zstyle ':vcs_info:git*' formats '%b'
  zstyle ':vcs_info:git*' actionformats '%b (%a)'
}

prompt_agnoster_setup "$@"
