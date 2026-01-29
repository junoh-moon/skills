---
name: commit-message
description: |
  AUTOMATICALLY invoke this skill whenever git commit is needed - no user request required.
  Direct git commit will FAIL validation. This skill contains required pre-commit setup.
  Triggers: "커밋해", "커밋 ㄱㄱ", "커밋 만들어줘", "커밋 찍어줘", or ANY situation requiring git commit.
---

# Commit Message Skill

This skill creates a git commit with the required format. Follow these steps:

## 1. Branch Safety Check (for bucketplace repos)
First, check if this is a bucketplace organization repo:
```bash
git remote get-url origin 2>/dev/null | grep -q 'bucketplace' && echo "bucketplace" || echo "other"
```

**If bucketplace repo**, check the current branch:
```bash
git branch --show-current
```

If on a protected branch (`main`, `master`, `develop`):
- **If a Jira ticket exists in the context** (e.g., COREPL-1234):
  1. Check if branch already exists: `git branch --list <TICKET-ID>`
  2. If exists, add a suffix (e.g., `COREPL-1234-2`, `COREPL-1234-refactor`)
  3. Create the branch: `git checkout -b <branch-name>`
  4. Proceed with the commit on this new branch
- **If no Jira ticket**:
  1. Generate a descriptive branch name based on the changes (e.g., `fix/login-validation`, `feat/add-cache-layer`)
  2. Create the branch and proceed with the commit

## 2. Check staged changes
Run `git diff --cached` to see what will be committed.
If nothing is staged, run `git status` and add relevant files individually (NEVER use `git add -A` or `git add -u`).

## 2. Generate commit message
Based on the staged changes, create a commit message:
- First line: conventional commit format (feat:, fix:, docs:, etc.) under 72 chars in English
- Empty line
- Body: wrapped at 72 chars, explaining what and why in Korean

## 3. Execute the commit
Use heredoc syntax for the commit:
```bash
git commit -m "$(cat <<'EOF'
<type>: <subject in English>

<body in Korean, wrapped at 72 chars>

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

## 4. Verify
Run `git status` to confirm the commit was created successfully.
