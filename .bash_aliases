# navigation
alias ..='cd ..'
alias ...='cd ../..'

# https://github.com/eza-community/eza
alias l='eza -lF --git --icons --group-directories-first --time-style relative'
# all detail
alias la='eza -AlF --icons --time-style long-iso'
alias ll='la'
# tree
alias ld='eza -lF -T --level=2 --icons --time-style relative'
alias lt='eza -lF -T --level=3 --icons --time-style relative'

# verbose
alias cp='cp -v'
alias ln='ln -v'
alias mv='mv -v'
alias rm='rm -v'
