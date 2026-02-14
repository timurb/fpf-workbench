#!/usr/bin/env bash
set -euo pipefail

DEFAULT_UPSTREAM_URL="https://github.com/ailev/FPF.git"
DEFAULT_UPSTREAM_SPEC_PATH="FPF-Spec.md"

usage() {
  printf 'Usage: tools/sync_fpf.sh [UPSTREAM_GIT_URL] [path/to/FPF-Spec.md in upstream]\n' >&2
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  usage
  exit 0
fi

if [[ "$#" -gt 2 ]]; then
  usage
  exit 2
fi

UPSTREAM_URL="${1:-${UPSTREAM_URL:-${DEFAULT_UPSTREAM_URL}}}"
UPSTREAM_SPEC_PATH="${2:-${UPSTREAM_SPEC_PATH:-${DEFAULT_UPSTREAM_SPEC_PATH}}}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd -P)"
CACHE_DIR="${ROOT_DIR}/.cache/fpf-upstream"
OUT_DIR="${ROOT_DIR}/refs/fpf"
OUT_SPEC="${OUT_DIR}/FPF-Spec.md"
OUT_META="${OUT_DIR}/UPSTREAM.txt"
TMP_SPEC="$(mktemp)"
TMP_META="$(mktemp)"

cleanup() {
  rm -f "${TMP_SPEC}" "${TMP_META}"
}
trap cleanup EXIT

mkdir -p "${CACHE_DIR}" "${OUT_DIR}"

if [[ -d "${CACHE_DIR}/.git" ]]; then
  git -C "${CACHE_DIR}" remote set-url origin "${UPSTREAM_URL}"
  git -C "${CACHE_DIR}" fetch --prune origin
else
  rm -rf "${CACHE_DIR}"
  git clone --depth 1 "${UPSTREAM_URL}" "${CACHE_DIR}"
fi

REMOTE_HEAD_REF="$(git -C "${CACHE_DIR}" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null || true)"
if [[ -n "${REMOTE_HEAD_REF}" ]]; then
  REV="$(git -C "${CACHE_DIR}" rev-parse "${REMOTE_HEAD_REF}")"
else
  REV="$(git -C "${CACHE_DIR}" rev-parse HEAD)"
fi

if ! git -C "${CACHE_DIR}" cat-file -e "${REV}:${UPSTREAM_SPEC_PATH}" 2>/dev/null; then
  echo "ERROR: Spec not found in upstream: ${UPSTREAM_SPEC_PATH}"
  echo "Checked revision: ${REV}"
  exit 2
fi

git -C "${CACHE_DIR}" show "${REV}:${UPSTREAM_SPEC_PATH}" > "${TMP_SPEC}"

SPEC_CHANGED=0
if [[ ! -f "${OUT_SPEC}" ]] || ! cmp -s "${TMP_SPEC}" "${OUT_SPEC}"; then
  mv "${TMP_SPEC}" "${OUT_SPEC}"
  SPEC_CHANGED=1
fi

CURRENT_URL="$(sed -n 's/^upstream_url=//p' "${OUT_META}" 2>/dev/null | head -n 1 || true)"
CURRENT_SPEC_PATH="$(sed -n 's/^upstream_spec_path=//p' "${OUT_META}" 2>/dev/null | head -n 1 || true)"

META_CHANGED=0
if [[ ! -f "${OUT_META}" || "${CURRENT_URL}" != "${UPSTREAM_URL}" || "${CURRENT_SPEC_PATH}" != "${UPSTREAM_SPEC_PATH}" || "${SPEC_CHANGED}" -eq 1 ]]; then
  TS="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  printf 'upstream_url=%s\n' "${UPSTREAM_URL}" > "${TMP_META}"
  printf 'upstream_spec_path=%s\n' "${UPSTREAM_SPEC_PATH}" >> "${TMP_META}"
  printf 'upstream_rev=%s\n' "${REV}" >> "${TMP_META}"
  printf 'synced_at_utc=%s\n' "${TS}" >> "${TMP_META}"
  mv "${TMP_META}" "${OUT_META}"
  META_CHANGED=1
fi

if [[ "${SPEC_CHANGED}" -eq 0 && "${META_CHANGED}" -eq 0 ]]; then
  echo "OK: no changes in ${UPSTREAM_URL}:${UPSTREAM_SPEC_PATH}"
else
  echo "OK: synced ${UPSTREAM_URL}@${REV} -> refs/fpf/FPF-Spec.md"
fi
