# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# https://github.com/eza-community/eza
alias l='eza --color=always --long --classify --git --icons --group-directories-first --time-style relative'
alias la='eza --color=always --almost-all --long --classify --icons --time-style long-iso --git-repos --group-directories-first'
alias ll='la'
alias lt='eza --color=always --long --classify --tree --level=2 --icons --git --time-style relative'
alias ltt='eza --color=always --long --classify --tree --level=5 --icons --git --time-style relative'

# less: keep ANSI colors when piping colored output (eza, git, ...)
export LESS='-RFX'

# flags
alias cp='cp -v'
alias ln='ln -v'
alias mv='mv -v'
alias rm='rm -v'
alias grep='grep --color=auto'
alias mkdir='mkdir -pv'

# bat (modern cat)
alias cat='bat --paging=never'
alias catp='bat'                     # with paging
export BAT_THEME='ansi'

alias df='duf'
alias du='ncdu'

alias path='echo -e ${PATH//:/\\n}'  # print PATH one entry per line

# tools
alias reload='source ~/.bashrc'
alias tsnode="ts-node -O '{\"module\": \"commonjs\":}'"
alias jail='ai-jail'

# mkcd: make a dir and cd into it
mkcd() { mkdir -p "$1" && cd "$1"; }

# checkout main, pull and delete current branch
clean_git_branch() {
  local branch
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

  if [ -z "$branch" ]; then
    echo "Not a git repository or no branch found" >&2
    return 1
  fi

  if [ "$branch" = "main" ] || [ "$branch" = "master" ]; then
    echo "Cannot delete protected branch: $branch" >&2
    return 1
  fi

  git checkout main || return 1
  git pull || return 1
  git branch -d "$branch" || return 1

  echo "Deleted branch: $branch"
}

# omarchy aliases
unalias a c cx cy d r t h ic ix icx
