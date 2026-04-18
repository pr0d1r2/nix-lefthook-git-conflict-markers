# shellcheck shell=bash
# Lefthook-compatible git conflict marker checker.
# Usage: lefthook-git-conflict-markers file1 [file2 ...]
# NOTE: sourced by writeShellApplication — no shebang or set needed.

if [ $# -eq 0 ]; then
    exit 0
fi

files=()
for f in "$@"; do
    [ -f "$f" ] || continue
    files+=("$f")
done

if [ ${#files[@]} -eq 0 ]; then
    exit 0
fi

found=0
for f in "${files[@]}"; do
    if grep -Hn '^<<<<<<<\|^>>>>>>>\|^=======$' "$f"; then
        found=1
    fi
done

exit "$found"
