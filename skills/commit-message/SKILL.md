---
name: commit-message
description: Generate Git commit messages from staged changes using a conventional commit subject (English, <= 72 chars) and a Korean body (wrapped at 72 chars). Use when asked to write, suggest, or refine a git commit message.
---

# Commit Message Convention

## Use staged changes only

- Run `git diff --cached` to review what will be committed.
- If nothing is staged, stage files explicitly (do not use `git add -u` or `git add -A`).
  - Prefer `git add path/to/file` (repeat per file).

## Write the message

- Output the commit message as plain text (no Markdown).
- Write the first line as a conventional commit subject in English (max 72 chars): `feat: ...`, `fix: ...`, `docs: ...`, etc.
- Leave an empty line after the subject.
- Write the body in Korean, wrapped at 72 chars, explaining what changed and why.

## Commit command template

```bash
git commit -m "$(cat <<'EOF'
type(scope): subject

변경 내용과 이유를 72자 폭으로 줄바꿈해 작성합니다.
EOF
)"
```

## Final checks

- Match the message to `git diff --cached` only.
- Keep the subject specific; explain rationale/impact in the body.
- If you need examples, see `references/examples.md`.
