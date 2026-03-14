# YouTube Downloader

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Agent Skills Compatible](https://img.shields.io/badge/Agent_Skills-compatible-4A90D9)](https://agentskills.io)
[![Claude Code Plugin](https://img.shields.io/badge/Claude_Code-plugin-F97316)](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/plugins)
[![Cursor Plugin](https://img.shields.io/badge/Cursor-plugin-00D886)](https://cursor.com/docs/plugins)

An AI agent skill for downloading YouTube videos with interactive resolution and subtitle selection. Lists available formats, checks for subtitles, and lets you choose exactly what to download.

Uses the open [Agent Skills](https://agentskills.io) standard. Works with Claude, ChatGPT, Codex CLI, Cursor, Windsurf, Manus, and any other compatible tool.

## Prerequisites

This skill requires two command-line tools installed on your system:

- **[yt-dlp](https://github.com/yt-dlp/yt-dlp)** — YouTube video downloader
- **[ffmpeg](https://ffmpeg.org/)** — Required to merge video and audio streams

```bash
# macOS
brew install yt-dlp ffmpeg

# Linux
pip install -U yt-dlp && sudo apt install ffmpeg

# Windows
pip install -U yt-dlp && choco install ffmpeg
```

## Installation

### Claude Desktop

1. Click **Customize** in the sidebar
2. Click **Browse Plugins**
3. Go to the **Personal** tab and click **+**
4. Add: `yaniv-golan/ytd-skill`

### Claude Code (CLI)

```bash
/plugin marketplace add yaniv-golan/ytd-skill
```

### Cursor

1. Open **Cursor Settings**
2. Paste `https://github.com/yaniv-golan/ytd-skill` into the **Search or Paste Link** box

### Manus

1. Download [`youtube-downloader.zip`](https://github.com/yaniv-golan/ytd-skill/releases/latest/download/youtube-downloader.zip)
2. Go to **Settings** -> **Skills**
3. Click **+ Add** -> **Upload**
4. Upload the zip

### ChatGPT

1. Download [`youtube-downloader.zip`](https://github.com/yaniv-golan/ytd-skill/releases/latest/download/youtube-downloader.zip)
2. Go to **Settings** -> **Skills** -> **New Skill** -> **Upload from your Computer**
3. Upload the zip

### Codex CLI

Use the built-in skill installer:

```
$skill-installer https://github.com/yaniv-golan/ytd-skill
```

Or install manually:

1. Download [`youtube-downloader.zip`](https://github.com/yaniv-golan/ytd-skill/releases/latest/download/youtube-downloader.zip)
2. Extract the `youtube-downloader/` folder to `~/.codex/skills/`

### Other Tools (Windsurf, etc.)

Download [`youtube-downloader.zip`](https://github.com/yaniv-golan/ytd-skill/releases/latest/download/youtube-downloader.zip) and extract the `youtube-downloader/` folder to:

- **Project-level**: `.agents/skills/` in your project root
- **User-level**: `~/.agents/skills/`

## Usage

The skill auto-activates when you ask to download a YouTube video. Just paste a URL:

```
Download this video: https://www.youtube.com/watch?v=dQw4w9WgXcQ
```

The skill will:

1. **List available resolutions** and let you pick (best quality, 1080p, 720p, audio-only, or custom)
2. **Check for subtitles** — both creator-uploaded and auto-generated captions
3. **Download** with your chosen settings, merging video + audio automatically
4. **Confirm** the downloaded files with paths and sizes

## License

MIT
