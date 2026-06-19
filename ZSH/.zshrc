# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Starship prompt
eval "$(starship init zsh)"

# ZSH
alias reload-zsh="source ~/.zshrc"
alias edit-zsh="zed ~/.zshrc"

# Thefuck alias
eval $(thefuck --alias)
eval $(thefuck --alias fk)

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"
alias cd="z"


# Clear
alias cl='clear'

# FZF
# source <(fzf --zsh)
# alias fzf='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'

# Cat
alias cat=bat

# List
alias la=tree

# Lazygit
alias lg='lazygit'

# Git
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'
alias nah="git reset --hard;git clean -df;"

# Docker
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

# Dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# VIM
alias v="/opt/homebrew/bin/nvim"

# Nmap
alias nm="nmap -sC -sV -oN nmap"eval "$(/Users/carlos/.local/bin/mise activate zsh)"

#Mise
eval "$(/Users/carlos/.local/bin/mise activate zsh)"

# opencode
export PATH=/Users/carlos/.opencode/bin:$PATH
