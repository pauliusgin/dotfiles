############################################
########## EDITOR

export EDITOR=nvim

############################################
########## PATH

export PATH="/opt/homebrew/opt/ruby@3.1/bin:$PATH"
export PATH="/usr/local/opt/ruby/bin:/usr/local/lib:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="$HOME/.rvm/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

############################################
########## TOOLS

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# envman
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

############################################
########## COMPLETIONS

fpath=(~/.stripe $fpath)
autoload -Uz compinit && compinit -i

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-prompt ''
zstyle ':completion:*' menu select
zstyle ':completion:*:directories' sort true
zstyle ':completion:*' history-completion yes

############################################
########## ALIASES

alias information="system_profiler SPSoftwareDataType SPHardwareDataType SPStorageDataType"
alias nvcon="nvim ~/.config/nvim/init.lua"

function ask() {
    local model="qwen2.5-coder:7b"
    if [[ "$1" == "-m" ]]; then
        model="qwen2.5-coder:14b"
        shift
    fi
    ollama run "$model" $*
}

function agentsinit() {
    touch AGENTS.md && ln -s AGENTS.md CLAUDE.md && ls -l AGENTS.md CLAUDE.md
}

############################################
########## PROMPT

function parse_git_branch() {
    git branch 2>/dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p'
}

if [ "$COLORTERM" = "truecolor" ] || [ "$TERM_PROGRAM" = "iTerm.app" ]; then
    COLOR_DEF=$'%f'
    COLOR_USR=$'%F{#97CCF1}'
    COLOR_DIR=$'%F{#FCB650}'
    COLOR_GIT=$'%F{#E15A60}'
else
    COLOR_DEF=$'%f'
    COLOR_USR=$'%F{75}'
    COLOR_DIR=$'%F{222}'
    COLOR_GIT=$'%F{124}'
fi

setopt PROMPT_SUBST
export PROMPT='${COLOR_USR}%n%f ${COLOR_DIR}%2~%f ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF}: '

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/paulius/.lmstudio/bin"
# End of LM Studio CLI section

