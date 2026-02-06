#!/bin/sh
set -eu

usage() {
  cat <<'USAGE'
Usage: tools/sync_work.sh <workrepo_dir> <template_dir>

Copies files from workrepo_dir into template_dir using rsync with exclusions.
USAGE
  exit 2
}

[ -z "$2" ] && usage

SRC=${1%/}
DST=${2%/}

if [ ! -d "$SRC" ] || [ ! -d "$DST" ]; then
  echo "error: both <workrepo_dir> and <template_dir> must exist" >&2
  exit 2
fi

# Build rsync --exclude args from the heredoc list below.
EXCLUDE_ARGS=""
while IFS= read -r pat; do
  [ -z "$pat" ] && continue
  EXCLUDE_ARGS="$EXCLUDE_ARGS --exclude=$pat"
done <<'EOF'
.git/
.venv/
node_modules/
dist/
build/
.cache/
.idea/
.vscode/
.DS_Store
__pycache__/
*.pyc
.env
.env.*
secrets.*
*.key
*.pem
EOF

# shellcheck disable=SC2086
rsync -a --human-readable --info=stats2,progress2 --prune-empty-dirs \
  $EXCLUDE_ARGS \
  "$SRC"/ "$DST"/
