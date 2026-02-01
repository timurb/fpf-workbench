---
name: Bootstrap documentation repository
description: Bootstrap and standardize this repository’s GitLab-readable documentation structure under `docs/` (entrypoint, navigation, conventions, and initial skeleton). Use only when explicitly invoked by name (e.g. “use docs-bootstrap” / “$docs-bootstrap”) and not for generic writing/editing requests.
---

# Docs Bootstrap

## Overview

You are working in a text-only knowledge repository.

Create (or normalize) a small, consistent documentation skeleton for this repo: a clear `docs/` entrypoint, a navigation surface (TOC), and a few lightweight conventions so future docs stay consistent and reviewable.


## Guardrails (repo rules)

- Keep everything GitLab-readable Markdown (no wiki-links like `[[Title]]`).
- Prefer stable, lowercase, kebab-case doc filenames; use standard Markdown links (`[Title](relative/path.md)`).
- Never edit `refs/fpf/FPF-Spec.md` (it is synced from upstream).
- Do not read/process `tools/` unless explicitly asked.


## FPF invariants (required excerpts)

When the docs you create make FPF-relevant claims, follow the retrieval protocol: search `refs/fpf/FPF-Spec.md`, quote a minimal excerpt (3–8 lines) in the change rationale, and apply it to the concrete repo artifacts.

If not found, mark Unknown (do not assume).



## Workflow (bootstrap docs repository)

### Step 0 — Confirm explicit invocation

If the user did not explicitly request `$Bootstrap documentation repository` / “use Bootstrap documentation repository, stop and ask for confirmation. This skill should not run on generic “write docs” requests.

### Step 1 — Inventory current state

- List what exists under `docs/` (and whether anything looks generated, e.g. `docs/_generated/`).
- Identify the current entrypoint (usually `docs/index.md`) and the navigation surface (TOC or sidebar).

### Step 2 — Propose a minimal, reviewable skeleton

Aim for the smallest set of files that makes the docs usable and self-explanatory. Prefer adding/adjusting files under `docs/` only.

Recommended minimum (create if missing; normalize if present):
- `docs/index.md`: “start here” entrypoint, scope, and links.
- `docs/_generated/toc.md`: generated TOC (keep generated content clearly marked).
- `docs/contributing.md`: how to add/edit docs in this repo (links, naming, where to put new pages).
- `docs/style-guide.md`: Markdown conventions (headings, links, naming), plus any local terminology notes.

If the repo already has an established structure, adapt to it and only fill gaps.

### Step 3 — Implement with traceability

- Keep diffs small; if multiple files are needed, propose a short plan before editing.
- Ensure every new page is reachable from `docs/index.md` and/or the TOC.
- When making normative/FPF claims, include evidence links (and quote the required minimal excerpt in the change rationale).

### Step 4 — Leave room for future templates

If the user wants standardized page templates later (e.g., “concept page”, “method”, “decision record”), add them as files under `docs/templates/` or as a future `assets/` bundle inside this skill—only after the templates are agreed.
