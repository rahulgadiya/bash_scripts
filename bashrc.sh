# Only run in interactive shell
case $- in
  *i*) 
    command -v fastfetch &> /dev/null && fastfetch
    ;;
  *) return;;
esac

# Oh-My-Bash settings
export OSH="$HOME/.oh-my-bash"
OSH_THEME="random"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS='yyyy-mm-dd'
OMB_USE_SUDO=true
OMB_PROMPT_SHOW_PYTHON_VENV=true

# Plugins and aliases
completions=(git composer ssh npm pip docker)
aliases=(general)
plugins=(git bashmarks sudo)

source "$OSH/oh-my-bash.sh"
source "$HOME/.local/share/blesh/ble.sh"

# Useful aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Auto cd to Desktop (optional)
# cd ~/Desktop 2>/dev/null

