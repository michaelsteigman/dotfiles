---
name: chezmoi
description: Manage chezmoi-tracked dotfiles — edit a managed file, add a new one, refresh the Brewfile, then commit and push to the dotfiles repo. Use whenever the user wants to update, add, sync, or push their dotfiles / chezmoi config (e.g. "update my zshrc in chezmoi", "add this file to chezmoi", "refresh my Brewfile", "commit and push my dotfiles").
---

# Manage chezmoi dotfiles

Operate on the user's chezmoi-managed dotfiles and the backing git repo.

## Environment

- chezmoi binary: `/opt/homebrew/bin/chezmoi` (use full path; Homebrew shims aren't always on PATH in non-interactive shells)
- Source dir: `~/.local/share/chezmoi` (resolve dynamically with `chezmoi source-path`)
- Remote: `git@github.com:michaelsteigman/dotfiles.git`
- Managed files use chezmoi's `dot_` prefix in source (e.g. `~/.zshrc` ⇄ `dot_zshrc`).

## Before doing anything

1. Run `chezmoi source-path` to confirm the source dir.
2. Run `chezmoi status` and `chezmoi git -- status -s` to see what's already dirty or out of sync. Report this to the user before making changes — there may be unrelated pending edits they didn't expect to commit.

## Common tasks

### Edit a managed file
Prefer editing the source and applying, so the repo stays the source of truth:
1. `chezmoi edit --apply ~/.<file>` — but in this harness, instead locate the source file (`chezmoi source-path ~/.<file>`) and use the Edit tool on it directly, then run `chezmoi apply ~/.<file>`.
2. Show the user `chezmoi diff` before applying if the change is non-trivial.

### Add a new file to chezmoi
1. `chezmoi add ~/.<file>` (use `--encrypt` only if the user says it's a secret).
2. Confirm it landed: `chezmoi managed | grep <file>`.

### Refresh the Brewfile
The user does not run the dump themselves — Claude runs it on request (e.g. "update/sync my Brewfile").
1. `brew bundle dump --global --force --no-dump-vscode --no-dump-npm` (writes `~/.Brewfile` from currently-installed packages; `--no-dump-vscode` and `--no-dump-npm` keep VS Code extensions and global npm packages out of the dump, so no manual trimming is needed).
2. A dump reflects what's installed *right now* — it drops anything uninstalled and won't carry hand-added `tap` lines. Run `chezmoi diff ~/.Brewfile` and show the user the net adds/removes before committing, so an unexpected drop gets caught.
3. `chezmoi re-add ~/.Brewfile`, then commit and push.

### Pull in changes made directly on the system
If the user edited a dotfile in place (not via chezmoi), re-add it: `chezmoi add ~/.<file>`, then commit.

## Commit and push (the usual close-out)

After staging changes into the source dir:
1. `chezmoi git -- add .`
2. `chezmoi git -- commit -m "<concise message describing what changed>"`
3. `chezmoi git -- push`

Write a real commit message describing the change (e.g. "update p10k theme, add ripgrep to Brewfile"), not a generic "updates".

## Sync on another machine (pull latest)

To bring a second machine up to date with what was pushed:
1. `chezmoi update` — pulls the latest commits into the source dir **and** applies them in one step. This is the usual sync command.
2. Or, to inspect before writing: `chezmoi git pull` → `chezmoi diff` → `chezmoi apply`.

Caveat: `apply` overwrites live files with the repo version. If the other machine has its own local drift, `apply` will clobber it. Always `chezmoi diff` first — `-` lines are what would be lost, `+` lines are what the repo would write. If that machine is actually ahead on something, `chezmoi re-add` it before applying.

Note on `settings.json`: tracking `~/.claude/settings.json` couples machines to compatible Claude Code versions. Newer hook events (e.g. `PermissionRequest`, `StopFailure`) will error at launch on an older Claude Code. Keep machines on the same Claude Code version, or move version-sensitive hooks to `settings.local.json` (machine-local, not chezmoi-tracked).

## New-machine bootstrap (reference)

If the user is setting up a fresh Mac:
1. Install Homebrew: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
2. `brew install chezmoi`
3. `chezmoi init --apply michaelsteigman`
4. `brew bundle install --global` (installs from the `~/.Brewfile` chezmoi just placed)
5. Manual apps not in Brewfile: 1Password, Alfred (Powerpack via 1Password), VMWare Fusion; set up Dash docsets/cheatsheets.

## Rules

- Always show the user a diff (`chezmoi diff`) or the git status before committing anything.
- Never commit secrets unencrypted. If a file looks like it holds credentials/keys, stop and ask before `chezmoi add`.
- Don't commit unrelated pending changes silently — if `git status` shows edits you didn't make this session, point them out and let the user decide whether they go in the same commit.
- Confirm the push succeeded and report the commit hash.
