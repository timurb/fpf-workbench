#!/usr/bin/env bash
set -euo pipefail

UPSTREAM_URL="git@github.com:ailev/FPF.git"
UPSTREAM_SPEC_PATH="FPF-Spec.md"

ROOT_DIR="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/..")"
CACHE_DIR="${ROOT_DIR}/.cache/fpf-upstream"
OUT_DIR="${ROOT_DIR}/refs/fpf"
OUT_SPEC="${OUT_DIR}/FPF-Spec.md"
OUT_META="${OUT_DIR}/UPSTREAM.txt"

mkdir -p "${CACHE_DIR}" "${OUT_DIR}"

if [[ -d "${CACHE_DIR}/.git" ]]; then
  git -C "${CACHE_DIR}" remote set-url origin "${UPSTREAM_URL}"
  git -C "${CACHE_DIR}" fetch --all --prune
  git -C "${CACHE_DIR}" pull --ff-only
else
  rm -rf "${CACHE_DIR}"
  git clone "${UPSTREAM_URL}" "${CACHE_DIR}"
fi

if [[ ! -f "${CACHE_DIR}/${UPSTREAM_SPEC_PATH}" ]]; then
  echo "ERROR: Spec not found in upstream: ${UPSTREAM_SPEC_PATH}"
  echo "Checked: ${CACHE_DIR}/${UPSTREAM_SPEC_PATH}"
  exit 2
fi

cp "${CACHE_DIR}/${UPSTREAM_SPEC_PATH}" "${OUT_SPEC}"

REV="$(git -C "${CACHE_DIR}" rev-parse HEAD)"
TS="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

cat > "${OUT_META}" <<EOF
upstream_url=${UPSTREAM_URL}
upstream_spec_path=${UPSTREAM_SPEC_PATH}
upstream_rev=${REV}
synced_at_utc=${TS}
EOF

echo "OK: synced ${UPSTREAM_URL}@${REV} -> refs/fpf/FPF-Spec.md"
