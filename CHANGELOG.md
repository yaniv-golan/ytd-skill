# Changelog

All notable changes to this project will be documented in this file.

## [0.3.0] - 2026-03-14

### Added

- JavaScript runtime (nodejs/deno) auto-install for better format detection
- Confirmation step before download showing selections and full command
- Error handling table — parses yt-dlp errors and gives actionable advice instead of raw output

## [0.2.0] - 2026-03-14

### Added

- Browser-based authentication for restricted videos (age-restricted, private, members-only)
- Playwright cookie extraction workflow for sandboxed environments (Cowork, cloud)
- DRM detection with clear user messaging

## [0.1.0] - 2026-03-14

### Added

- Initial release
- Interactive resolution selection with AskUserQuestion
- Subtitle/caption detection (manual and auto-generated)
- SRT conversion for downloaded subtitles
- Auto-install of yt-dlp and ffmpeg via pip
- Support for best quality, 1080p, 720p, and audio-only downloads
- Cross-platform support: Claude Code, Cursor, Manus, ChatGPT, Codex CLI
