# Stub: real aliases live in bash_aliases (no dot, so it shows up in LazyVim's tree)
_d="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
[ -f "$_d/bash_aliases" ] && . "$_d/bash_aliases"
unset _d
