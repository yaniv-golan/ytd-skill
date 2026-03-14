---
name: youtube-downloader
description: "Download YouTube videos with interactive resolution and subtitle selection using yt-dlp. Use when the user wants to download a YouTube video, save a video from YouTube, get video subtitles/captions, or mentions youtube download, yt-dlp, video resolution, or SRT subtitles from YouTube."
license: MIT
metadata:
  author: Yaniv Golan
  version: "0.2.0"
  compatibility: "Requires yt-dlp and ffmpeg. Auto-installs via pip if missing."
---

# YouTube Downloader

Downloads YouTube videos interactively — lists available resolutions, checks for subtitles, and lets the user choose exactly what to download.

## Prerequisites (auto-install)

Before doing anything else, silently check if both tools are available:

```bash
yt-dlp --version 2>/dev/null; echo "yt-dlp:$?"
ffmpeg -version 2>/dev/null | head -1; echo "ffmpeg:$?"
```

If anything is missing, **install it automatically** — no need to ask the user. Both tools are pip-installable and require no sudo or system package manager:

```bash
pip install -U yt-dlp    # pure Python, works everywhere
pip install ffmpeg-static # pre-built ffmpeg binary, no sudo needed
```

If `pip` is not found, try `pip3`. If `ffmpeg-static` fails, try `imageio[ffmpeg]` as a fallback which bundles its own ffmpeg binary. As a last resort on macOS try `brew install ffmpeg`, on Linux try `apt-get install -y ffmpeg` (may need sudo — only then ask the user).

After installation, verify both tools work before proceeding. Tell the user what was installed.

## Workflow

Follow these steps in order when the user provides a YouTube URL.

### Step 1: List available formats

Run `yt-dlp -F "URL"` to get the format table. Parse the output and present a **summary** to the user — do not dump the raw table. Group the results into:

- **Video+Audio** (single files): list resolution, codec, and approximate size
- **Video-only**: list resolution, codec, and approximate size
- **Audio-only**: list quality, codec, and approximate size

Use AskUserQuestion to let the user pick. Offer sensible defaults:

| Option | Description |
|--------|------------|
| Best quality (Recommended) | Best video + best audio, merged automatically |
| 1080p MP4 | Cap at 1080p, force MP4 container |
| 720p MP4 | Smaller file, good for mobile |
| Audio only | Best audio, no video |
| Custom | User specifies resolution or format code |

### Step 2: Check for subtitles

Run:
```bash
yt-dlp --list-subs "URL" 2>&1
```

Parse the output and tell the user:
- Which **manual** (creator-uploaded) subtitle languages are available
- Which **auto-generated** caption languages are available
- Whether no subtitles are available at all

Use AskUserQuestion to let the user choose:

| Option | Description |
|--------|------------|
| No subtitles | Download video only |
| English SRT (Recommended) | Download English subtitles, convert to SRT |
| All available languages | Download all subtitle tracks as SRT |
| Specific language(s) | User picks from the available list |

If the user's preferred language is only available as auto-generated, inform them and ask if that's acceptable.

### Step 3: Build and run the download command

Construct the `yt-dlp` command based on user choices. Use these format selectors:

| User choice | Format selector |
|------------|----------------|
| Best quality | `-f "bv*+ba/b"` |
| 1080p MP4 | `-f "bv*[height<=1080][ext=mp4]+ba[ext=m4a]/b[ext=mp4]"` |
| 720p MP4 | `-f "bv*[height<=720][ext=mp4]+ba[ext=m4a]/b[ext=mp4]"` |
| Audio only | `-f "ba/b" --extract-audio --audio-format mp3` |

For subtitles, append these flags:

| Subtitle choice | Flags |
|----------------|-------|
| Manual subs | `--write-subs --sub-langs "LANG" --convert-subs srt` |
| Auto-generated | `--write-auto-subs --sub-langs "LANG" --convert-subs srt` |
| Both manual + auto | `--write-subs --write-auto-subs --sub-langs "LANG" --convert-subs srt` |
| All languages | `--write-subs --write-auto-subs --sub-langs "all" --convert-subs srt` |

Always add `--convert-subs srt` when downloading subtitles — YouTube serves VTT/srv3 natively, and SRT is more universally compatible.

Run the command and show the user the download progress.

### Step 4: Confirm results

After download completes, list the downloaded files with their sizes:
```bash
ls -lh FILENAME*
```

Tell the user:
- The video file path and size
- Any subtitle files downloaded
- The actual resolution and codec of the downloaded video

## Format Selector Reference

| Selector | Meaning |
|----------|---------|
| `bv*` | Best video (may include audio) |
| `ba` | Best audio-only |
| `b` | Best single file |
| `+` | Merge two streams |
| `/` | Fallback if first unavailable |
| `[height<=720]` | Filter by max resolution |
| `[ext=mp4]` | Filter by container format |

## Authentication via Browser (for restricted videos)

Some videos require authentication: age-restricted, private, or members-only content. When yt-dlp reports an error like "Sign in to confirm your age", "Private video", or "Join this channel to get access", use this workflow:

### On desktop (Claude Code, Cursor)

Add `--cookies-from-browser chrome` (or `firefox`, `edge`, `safari`) to the yt-dlp command. This reads cookies from the user's local browser profile. The user must be logged into YouTube in that browser.

### In sandboxed environments (Cowork, cloud)

There's no local browser profile, so use Playwright to get cookies:

1. Launch a browser and navigate to YouTube:
   ```
   Use browser_navigate to go to https://accounts.google.com
   ```

2. Tell the user to log in. Wait for them to complete the Google login flow — use `browser_snapshot` to check if they've reached the YouTube homepage or their Google account page.

3. Once logged in, extract cookies:
   ```
   Use browser_evaluate to run: JSON.stringify(await (async () => {
     const cookies = document.cookie.split('; ').map(c => {
       const [name, ...rest] = c.split('=');
       return { name, value: rest.join('='), domain: '.youtube.com' };
     });
     return cookies;
   })())
   ```

   **Better approach** — if the Playwright MCP exposes a cookies API, use that directly to get all cookies for `.youtube.com` and `.google.com` domains.

4. Write cookies to a Netscape cookie file:
   ```
   # Netscape cookie file format (one line per cookie):
   # domain\tinclude_subdomains\tpath\tsecure\texpiry\tname\tvalue
   .youtube.com	TRUE	/	TRUE	0	COOKIE_NAME	COOKIE_VALUE
   ```

   Save to a temporary file, e.g., `/tmp/yt-cookies.txt`.

5. Retry the yt-dlp command with `--cookies /tmp/yt-cookies.txt`.

6. Clean up the cookie file after download completes.

### What authentication CANNOT fix

**DRM-protected content** (rented/purchased movies, YouTube Premium originals) cannot be downloaded even with authentication. The video stream is encrypted. If yt-dlp reports a DRM error, inform the user that this content is not downloadable.

## Troubleshooting

**Slow download**: YouTube may throttle. Add `--concurrent-fragments 4` for parallel fragment downloads.

**Geo-restricted video**: Requires a VPN or proxy. Use `--proxy URL` if the user provides one.
