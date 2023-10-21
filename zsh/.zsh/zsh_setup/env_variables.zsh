# Golang PATH:
export GOPATH=~/go
# export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
# Commented for now, check if it's still needed for the go installation

# local bin
export PATH=$PATH:$HOME/.local/bin

# intellij path:
export PATH=$PATH:$HOME/.intellij/bin

# Install ruby gems to ~/gems
export GEM_HOME=$HOME/gems

export PATH=$PATH:$HOME/gems/bin

# pnpm
export PNPM_HOME="/home/miguelv5/.local/share/pnpm"
case ":$PATH:" in
	*":$PNPM_HOME:"*) ;;
	*) export PATH="$PNPM_HOME:$PATH" ;;
esac
