---

name: create-push-commit
description: Read current changes, create reasonable commits, and push to remote
---

---

# Create Push Commit

Input: $ARGUMENTS

## Goal

This is for lab work.

Read current project changes, group related files by folder or topic, create reasonable conventional
commits, then push to remote.

## Commit Format

Use short lab-style scopes when possible.

```text
<type>(<scope>): <short topic>
```

Preferred lab format:

```text
<type>(w<week>-<lab>): <short topic>
```

Examples:

```text
chore(w8-01): add s3 bucket lab
feat(w8-02): add ec2 instance config
fix(w8-03): update terraform provider
docs(w8-04): add lab notes
refactor(w8-05): clean terraform variables
```

If the lab number is not clear, use only the week:

```text
chore(w8): add terraform lab
docs(w8): update aws notes
```

Allowed types:

- feat
- fix
- refactor
- docs
- test
- chore
- build
- ci

## Workflow

1. Check current repository state:

```bash
git status
git branch --show-current
git diff --stat
git diff
```

2. Ensure:

- no unresolved merge conflicts
- working tree is valid
- no obvious secrets are included

3. Determine target branch:

- use `$ARGUMENTS` if provided
- otherwise use current branch

```bash
git branch --show-current
```

4. Review changed files:

- read changed files by folder
- understand what each change is doing
- group related changes together
- avoid mixing unrelated changes in one commit

5. For each group of related changes:

- stage files explicitly by filename
- create a short conventional commit message
- commit the staged files

Example:

```bash
git add path/to/file1 path/to/file2
git commit -m "chore(w8-01): add s3 bucket lab"
```

6. Push to remote:

```bash
git push origin <target-branch>
```

7. Show final result:

```bash
git rev-parse --short HEAD
git log -1 --pretty=%B
```

Output:

- pushed branch
- latest commit SHA
- latest commit message

## Rules

- This is a lab workflow, so keep it simple
- Automatically inspect files before committing
- Automatically stage only relevant files
- Do not use `git add .`
- Do not use `git add -A`
- Do not use `git commit -am`
- Never use `--force` unless explicitly requested
- Abort if there are merge conflicts
- Never commit secrets
- Avoid committing generated files unless needed for the lab
- Keep commit messages short and conventional
- Prefer lab-style commit scopes like `w8-01`, `w8-02`, or `w8`
