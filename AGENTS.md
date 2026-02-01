# AGENTS.md — repository operating rules (FPF + text-repo)

## Source-of-truth pointers
- FPF spec lives at: `refs/fpf/FPF-Spec.md` (synced from upstream; do not edit).
- Repository docs live under `docs/` and must stay readable in GitLab.

## Link & file conventions (GitLab-readable)
- Use standard Markdown links: `[Title](relative/path.md)`.
- Do NOT use wiki-links like `[[Title]]` in committed files.
- File naming: lowercase + kebab-case, stable paths. Prefer moving/renaming via git mv.

## FPF invariants (always-on)
- Strict Distinction / IDS: Object ≠ Description/Spec ≠ Carrier(file) ≠ Work(event).
- Context locality: any rule/meaning is bounded-context-local; avoid global claims.
- Plan–Run split: plans/specs are not execution logs; execution facts are separate.
- Unknown is not coerced: missing evidence -> abstain/degrade; never default-to-pass.

## Retrieval protocol (no section IDs required)
When you apply an FPF rule:
1) Search `refs/fpf/FPF-Spec.md` by keywords / headings.
2) Quote a minimal excerpt (3–8 lines) into the answer / change rationale.
3) Apply it to the concrete repo artifacts.
If you can’t find a supporting excerpt -> mark Unknown and ask what evidence/norm is expected.

## Work style
- Prefer small, reviewable diffs.
- For multi-file edits: propose a plan, then apply changes with clear commits.
- Run repo checks when available (see `tools/`).
