# Cross-Platform Architecture

This skill ships from a single source of truth and works across multiple AI platforms. This document explains how.

## Source of Truth

```
skills/youtube-downloader/
├── SKILL.md              <- canonical skill definition
└── agents/
    └── openai.yaml       <- Codex CLI UI metadata
```

## How Each Platform Consumes the Skill

### Claude Code — direct from repo

- Installs from the plugin marketplace: `/plugin marketplace add yaniv-golan/ytd-skill`
- Manifest: `.claude-plugin/plugin.json` with `"skills": "./skills"`
- Claude Code discovers `skills/youtube-downloader/SKILL.md` automatically

### Cursor — direct from repo

- Installs as a plugin: Settings -> paste repo URL into "Search or Paste Link"
- Manifest: `.cursor-plugin/plugin.json` (no `skills` field needed — auto-discovers from `skills/`)
- Same `SKILL.md` as Claude Code

### Manus — upload zip from GitHub Releases

- Download `youtube-downloader.zip` from the latest release
- Upload at Settings -> Skills -> + Add -> Upload
- The zip contains a flat `youtube-downloader/` folder

### ChatGPT — same zip as Manus

- Download same `youtube-downloader.zip` from GitHub Releases
- Upload at Settings -> Skills -> New Skill -> Upload from your Computer

### Codex CLI — install from repo or zip

**From repo (preferred):**

```
$skill-installer https://github.com/yaniv-golan/ytd-skill
```

**From zip (manual):** Download `youtube-downloader.zip` from GitHub Releases and extract to `~/.codex/skills/`.

### Others (Windsurf, etc.) — same zip

- Download and extract to `~/.agents/skills/` or `.agents/skills/` in the project root

## Release Workflow

CI (`.github/workflows/release.yml`) runs on version tags (`v*`) and produces the generic zip:

```bash
cp -r skills/youtube-downloader youtube-downloader
sed -i 's|\${CLAUDE_SKILL_DIR}/||g' youtube-downloader/SKILL.md
zip -r "youtube-downloader.zip" youtube-downloader/
```

## Version Management

The canonical version lives in `VERSION` at the repo root. Run `./tools/bump-version.sh` to propagate it to all locations. See [VERSIONING.md](../VERSIONING.md) for the full release process.
