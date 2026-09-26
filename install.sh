#!/usr/bin/env bash
#
# Link every tracked file in this repo into $HOME, mirroring the repo layout.
#
#   _configs/.bash_aliases             -> ~/.bash_aliases
#   _configs/.config/starship.toml     -> ~/.config/starship.toml
#   _configs/.config/lazygit/config.yml -> ~/.config/lazygit/config.yml
#
# Only files known to git are linked, so run `git add <file>` before this script.
# An existing real file at the target is renamed to <file>.bak.<timestamp>.
# Running this twice is safe.
#
# Usage: ./install.sh [--dry-run]

set -euo pipefail

repo="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
stamp="$(date +%Y%m%d%H%M%S)"
dry_run=0

if [[ "${1:-}" == "--dry-run" ]]; then
  dry_run=1
fi

# Repo files that must never be linked into $HOME.
skip=(install.sh README.md LICENSE .gitignore .gitattributes bash_aliases)

is_skipped() {
  local candidate="$1" name
  for name in "${skip[@]}"; do
    if [[ "$candidate" == "$name" ]]; then
      return 0
    fi
  done
  return 1
}

run() {
  if (( dry_run )); then
    printf '    would: %s\n' "$*"
  else
    "$@"
  fi
}

linked=0
kept=0

while IFS= read -r rel; do
  if is_skipped "$rel"; then
    continue
  fi

  src="${repo}/${rel}"
  dst="${HOME}/${rel}"

  # Skip files listed in git but deleted on disk.
  if [[ ! -e "$src" ]]; then
    printf 'missing  %s\n' "$src"
    continue
  fi

  if [[ -L "$dst" && "$(readlink -f -- "$dst")" == "$src" ]]; then
    printf 'ok       %s\n' "$dst"
    kept=$(( kept + 1 ))
    continue
  fi

  run mkdir -p -- "$(dirname -- "$dst")"

  stale_link=0

  if [[ -L "$dst" ]]; then
    # A symlink that points into this repo (or nowhere) is a leftover from an
    # earlier layout. Drop it rather than leave a useless .bak behind.
    link_target="$(readlink -- "$dst")"

    if [[ "$link_target" == "$repo"/* || ! -e "$dst" ]]; then
      printf 'relink   %s (was %s)\n' "$dst" "$link_target"
      run rm -f -- "$dst"
      stale_link=1
    fi
  fi

  if (( ! stale_link )) && [[ -e "$dst" || -L "$dst" ]]; then
    printf 'backup   %s -> %s.bak.%s\n' "$dst" "$dst" "$stamp"
    run mv -- "$dst" "${dst}.bak.${stamp}"
  fi

  run ln -s -- "$src" "$dst"
  printf 'linked   %s -> %s\n' "$dst" "$src"
  linked=$(( linked + 1 ))
done < <(git -C "$repo" ls-files)

printf '\n%d linked, %d already correct\n' "$linked" "$kept"
