# MemBar

A tiny macOS menu bar app that shows your current memory usage as a percentage.

![macOS](https://img.shields.io/badge/macOS-13%2B-blue)
![License](https://img.shields.io/badge/license-MIT-green)

## Features

- Displays RAM usage percentage in the menu bar
- Updates every 3 seconds
- No dock icon — runs entirely in the menu bar
- Tracks active + wired + compressed memory

## Build

Requires Swift 5.9+ and macOS 13+.

```bash
swift build -c release
```

The binary will be at `.build/release/MemBar`.

## Install

```bash
# Copy to Applications
mkdir -p ~/Applications/MemBar.app/Contents/MacOS
cp .build/release/MemBar ~/Applications/MemBar.app/Contents/MacOS/
cp Info.plist ~/Applications/MemBar.app/Contents/

# Launch
open ~/Applications/MemBar.app
```

### Auto-start at login

Create `~/Library/LaunchAgents/com.bentley.membar.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.bentley.membar</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/YOU/Applications/MemBar.app/Contents/MacOS/MemBar</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
```

Then load it:

```bash
launchctl load ~/Library/LaunchAgents/com.bentley.membar.plist
```

## License

[MIT](LICENSE)
