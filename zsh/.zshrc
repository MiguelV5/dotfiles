#____________________________________ SETUP: ______________________________________

source $HOME/.config/.zsh/zsh_setup/init.zsh

# COMPLETIONS
source $HOME/.config/.zsh/zsh_setup/completions.zsh

# KEYBINDINGS
source $HOME/.config/.zsh/zsh_setup/keybindings.zsh

# ENVIRONMENT VARIABLES
source $HOME/.config/.zsh/zsh_setup/env_variables.zsh

# ADDITIONAL CONFIGS
source $HOME/.config/.zsh/zsh_setup/additional_cfgs.zsh

# THEME
#source $HOME/.config/.zsh/agnoster_custom.zsh-theme
source $HOME/powerlevel10k/powerlevel10k.zsh-theme

# ---------------------------------------------------------------------------

# PLUGINS
source $HOME/.config/.zsh/zsh_plugins/colored-man-pages.plugin.zsh
source $HOME/.config/.zsh/zsh_plugins/zsh-aliases-ls.plugin.zsh
source $HOME/.config/.zsh/zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#__________________________________________________________________________________

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
