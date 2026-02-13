# AGENTS.md — repository operating rules (FPF + text-repo)

## Source-of-truth pointers
- FPF spec lives at: `refs/fpf/FPF-Spec.md` (synced from upstream; never edit this file).
- Repository docs live under `docs/` and must stay readable in GitLab.
- Files under `tools/` are helper tools and you should not read, process and verify them unless I explicitly ask you about that.

## Link & file conventions (GitLab-readable)
- Use standard Markdown links: `[Title](relative/path.md)`.
- Do NOT use wiki-links like `[[Title]]` in committed files.
- Do NOT wrap links in code blocks; use Markdown links inline in prose.
- File naming: lowercase + kebab-case, stable paths. Prefer moving/renaming via git mv.
- Links to linked concepts are recommended in all files

## FPF invariants (always-on)
- Strict Distinction / IDS (A.7): Object ≠ Description ≠ Carrier; Role ≠ Work; Method ≠ MethodDescription
- Context locality and scope discipline (A.2.6): any rule/meaning is bounded-context-local; avoid global claims.
- Plan–Run split: plans/specs are not execution logs; execution facts are separate.
- Unknown is not coerced: missing evidence -> abstain/degrade; never default-to-pass.
- Evidence chains (A.10): Every claim needs evidence reference
- Role-Method-Work alignment (A.15): Clear separation of intent, plan, execution


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

## Decision Framework (Quick Mode)
**When to use:** Single decisions, easily reversible, doesn't need persistent evidence trail.
**Process:** Present this framework to the user and work through it together.

```
DECISION: [What we're deciding]
CONTEXT: [Why now, what triggered this]

OPTIONS:
1. [Option A]
   + [Pros]
   - [Cons]

2. [Option B]
   + [Pros]
   - [Cons]

WEAKEST LINK: [What breaks first in each option?]

REVERSIBILITY: [Can we undo in 2 weeks? 2 months? Never?]

RECOMMENDATION: [Which + why, or "need your input on X"]
```

## Repo-Specific Rules
- Never use `cat << EOF` to generate files. If you cannot create a file via normal editing, stop and report the error to the user.
- In all documents except those under `docs/_sources/`, use neutral, professional language. Professional jargon is allowed if it is not overly conversational or slang-heavy.
- In `docs/`, only link to `docs/_sources/` when the page content actually uses information from that source.
- When making substantive semantic decisions or changes, capture DRR(s) immediately in `docs/work/drr/` (and update `docs/work/drr/README.md`) in the same change; do not defer DRR writing to later turns.
- When using bullets in responses, include an ID for each bullet so the user can refer to them.
   - This does not apply to code blocks, quoted templates, or when the user explicitly requests a paragraph-only response.
- Never read files under `.cache/`
- Always use the project `venv` Python for commands and tests
- If facts in different files contradict each other, do not make changes and ask the user how to proceed
- Always use `apply_patch` for file edits. If `apply_patch` cannot be used, stop and report the blocker to the user before making any file changes.
