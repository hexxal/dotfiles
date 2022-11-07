# Set up the prompt

autoload -Uz promptinit
promptinit

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

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

# CUSTOM

# Enable key bindings, such as Ctrl + R
source /usr/share/doc/fzf/examples/key-bindings.zsh

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Cool prompt
autoload -U colors && colors

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable ALL
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:hg*:*' formats "%{$fg[blue]%}[%s:%b]%{$reset_color%} %{$fg[green]%}%u%{$reset_color%}"
zstyle ':vcs_info:git*:*' formats "%{$fg[blue]%}[%s:%b:%.6i]%{$reset_color%}%{$fg[green]%} %u %c%{$reset_color%}"
zstyle ':vcs_info:git*:*' actionformats "%{$fg[blue]%}[%s:%b:%.6i]%{$reset_color%}%{$fg[green]%} %u %c %a%{$reset_color%}"

# https://github.com/joto/zsh-git-prompt
function in_git_repos() {
    test "`git rev-parse --is-inside-work-tree 2>/dev/null`" = "true"
}

function git_status_is_clean() {
    if in_git_repos; then
        local lines=$(git status --porcelain | egrep -v '^\?\? ' | wc -l)
        test $lines = 0
    fi
}

function git_current_branch() {
    if in_git_repos; then
        ref=$(git symbolic-ref HEAD 2> /dev/null) || \
        ref=$(git rev-parse --short HEAD 2> /dev/null) || return
        echo ${ref#refs/heads/}
    fi
}

function git_unknown_files() {
    if in_git_repos; then
        local lines=$(git status --porcelain | egrep '^\?\? ' | wc -l)
        test $lines = 0
    fi
}

function git_prompt_postfix() {
    local POSTFIX=""
    if in_git_repos; then
        if ! git_status_is_clean; then
            POSTFIX+="%{$fg[red]%}*%{$reset_color%}"
        fi
        if ! git_unknown_files; then
            POSTFIX+="%{$fg[blue]%}*%{$reset_color%}"
        fi
    fi
    echo $POSTFIX
}

precmd() { vcs_info }


NEWLINE=$'\n'
USERDATA="%{$fg[green]%}[%n@%m]%{$reset_color%}"
DIRECTORY="%{$fg[cyan]%}[%~]%{$reset_color%}"
GITDATA="${vcs_info_msg_0_}"

setopt prompt_subst
PROMPT='[%T]${USERDATA}${vcs_info_msg_0_}$(git_prompt_postfix)${NEWLINE}${DIRECTORY}${NEWLINE}$ '

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Poetry
export PATH="/home/hxl/.local/bin:$PATH"
