#!/usr/bin/env bash
# Re-render publications.qmd whenever a .bib file changes.
# Run alongside `quarto preview publications.qmd`: the preview server notices
# the updated docs/publications.html and reloads the browser by itself.
#
#   ./watch-bib.sh            # watches papers/*.bib
#   ./watch-bib.sh cv.qmd     # re-render a different page instead

set -u
cd "$(dirname "$0")"
target="${1:-publications.qmd}"

prev=$(md5sum papers/*.bib | md5sum)
echo "watching papers/*.bib, re-rendering $target on change (ctrl-c to stop)"
while true; do
    sleep 2
    cur=$(md5sum papers/*.bib | md5sum)
    if [ "$cur" != "$prev" ]; then
        prev=$cur
        echo "[$(date +%H:%M:%S)] bib changed, rendering $target"
        quarto render "$target" 2>&1 | grep --line-buffered -E "^(Output created|ERROR|Error)" || true
    fi
done
