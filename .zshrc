
# case $- in
#     *i*) ;;
#       *) return;;
# esac
# 
# if [[ -n $(command -v tmux) ]] && [[ -n "$PS1" ]] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [[ -z "$TMUX" ]]; then
#     session_name=$(basename "${HOME}" | tr . _ | tr [:space:] _)
#     exec tmux new -A -s "$session_name" -c "${HOME}"
# fi
setopt interactivecomments
source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# exiting vim cursor fix
_fix_cursor() {
   echo -ne '\e[5 q'
}
precmd_functions+=(_fix_cursor)
# fpath=(~/.just-zsh $fpath)

eval "$(starship init zsh)"

# promptinit
# prompt adam1
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Set up the prompt
autoload -Uz promptinit
setopt histignorealldups sharehistory

# # Use emacs keybindings even if our EDITOR is set to vi
# bindkey -e

# # Use modern completion system
# autoload -Uz compinit
# compinit
# compdef _just just

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
fpath+=~/.zsh/completions

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source $HOME/aliases.sh

# bun completions
[ -s "~/.bun/_bun" ] && source "~/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin
export PATH=${PATH}:`go env GOPATH`/bin
export PATH=${PATH}:"$HOME/.config/composer/vendor/bin"

[ -f "~/.ghcup/env" ] && source "~/.ghcup/env" # ghcup-env

# pnpm
export PNPM_HOME="~/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
export EDITOR=nvim
export PATH=$PATH:~/.local/bin
eval $(thefuck --alias)

# opam configuration
[[ ! -r ~/.opam/opam-init/init.zsh ]] || source ~/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

export PATH=$PATH:~/Downloads/roc_nightly-linux_x86_64-2024-03-25-4dca054
export PATH=~/.cache/rebar3/bin:$PATH

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"
source /usr/share/nvm/init-nvm.sh

export TERM='xterm-kitty'
export PATH=$PATH:~/.cargo/bin/
export PATH=$PATH:~/.local/bin/

bindkey '^x' recent-paths
