# refs/fpf

`FPF-Spec.md` is synced from an upstream repository.
Do not edit it manually.

Manual update:
- `tools/sync_fpf.sh [UPSTREAM_GIT_URL] [path/to/FPF-Spec.md in upstream]`

Defaults:
- `UPSTREAM_GIT_URL`: `https://github.com/ailev/FPF.git`
- `path`: `FPF-Spec.md`

Automated update:
- `.github/workflows/sync-fpf.yml` runs scheduled sync and opens a PR when changes are detected.
