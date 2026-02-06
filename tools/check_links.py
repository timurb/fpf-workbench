#!/usr/bin/env python3
from __future__ import annotations

import re
import sys
from pathlib import Path

LINK_RE = re.compile(r"\[[^\]]*\]\(([^)]+)\)")

def is_url(target: str) -> bool:
    return target.startswith(("http://", "https://", "mailto:"))

def strip_anchor(target: str) -> str:
    return target.split("#", 1)[0]

def main() -> int:
    root = Path(__file__).resolve().parents[1]
    # AGENTS.md is operational guidance, not repo-doc content; don't treat it as
    # a link-checked artifact.
    skip = {root / "AGENTS.md"}
    md_files = [p for p in root.rglob("*.md") if p not in skip]

    broken = []
    for md in md_files:
        text = md.read_text(encoding="utf-8", errors="ignore")
        for m in LINK_RE.finditer(text):
            raw = m.group(1).strip()
            if not raw or is_url(raw):
                continue
            path_part = strip_anchor(raw)
            if not path_part:
                continue
            # Normalize common GitLab-style links like ./foo.md
            target = (md.parent / path_part).resolve()
            try:
                target.relative_to(root.resolve())
            except ValueError:
                # points outside repo
                broken.append((md, raw, "points outside repo"))
                continue

            if not target.exists():
                broken.append((md, raw, "missing file"))

    if broken:
        print("Broken links:")
        for md, raw, why in broken:
            rel = md.relative_to(root)
            print(f"- {rel}: ({raw}) -> {why}")
        return 1

    print("OK: no broken relative markdown links found.")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
