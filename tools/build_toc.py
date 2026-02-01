#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path

def main() -> int:
    root = Path(__file__).resolve().parents[1]
    docs = root / "docs"
    out = docs / "_generated" / "toc.md"
    out.parent.mkdir(parents=True, exist_ok=True)

    md_files = sorted(p for p in docs.rglob("*.md") if "_generated" not in p.parts)
    lines = ["# Docs TOC", ""]
    for p in md_files:
        rel = p.relative_to(docs)
        if rel.as_posix() == "index.md":
            continue
        lines.append(f"- [{rel.stem}]({rel.as_posix()})")
    lines.append("")

    out.write_text("\n".join(lines), encoding="utf-8")
    print(f"OK: wrote {out.relative_to(root)}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
