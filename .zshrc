############################################
########## EDITOR 

export EDITOR=nvim



############################################
########## PATH

export PATH="/usr/local/opt/ruby/bin:/usr/local/lib:$PATH"


############################################
########## COMPLETIONS

#GENERAL
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-prompt ''
zstyle ':completion:*' menu select
zstyle ':completion:*:directories' sort true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' history-completion yes

# STRIPE
fpath=(~/.stripe $fpath)
    autoload -Uz compinit && compinit -i

# NODE VERSION MANAGER
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion



############################################
########## ALIASES

# NAVIGATIONAL
alias projects="cd documents/personal/projects"
alias ltc="cd documents/learn\ to\ code"
alias work="cd documents/work"

# COMMANDS
alias temperature="sudo powermetrics | grep -i -e 'temperature' -e 'fan' "
alias information="system_profiler SPSoftwareDataType SPHardwareDataType SPStorageDataType"
alias simulator="open -a Simulator.app"

# WEBPAGES 
alias google="open https://www.google.lt"
alias typing="open https://www.typing.com/student/typing-test/3-minute"
alias torrents="open https://torrentgalaxy.to"



############################################
########## PROMPT

function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p'
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



############################################
