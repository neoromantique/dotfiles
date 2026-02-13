# AGENTS Guide: Dotfiles Repository

Chezmoi-managed dotfiles with device-adaptive templates. Source files in `~/dotfiles/`, deployed to `~/` via `chezmoi apply`.

## Device Profiles

| Profile | Hostname | Primary Monitor | Has Touchpad | Has Battery |
|---------|----------|-----------------|--------------|-------------|
| desktop | box | DP-2 | No | No |
| laptop | bluefin | eDP-1 | Yes | Yes |

## Template Variables

```go
{{ .deviceProfile }}   // "desktop" or "laptop"
{{ .hostname }}        // "box" or "bluefin"
{{ .primaryMonitor }}  // "DP-2" or "eDP-1"
{{ .hasTouchpad }}     // boolean
{{ .hasBattery }}      // boolean
{{ .idleTimeout }}     // 300 (desktop) or 180 (laptop)
{{ .secretsPath }}     // "~/secrets"
```

## File Naming Conventions

| Pattern | Effect |
|---------|--------|
| `private_dot_*` | Hidden file with 700 permissions |
| `dot_*` | Hidden file with 755 permissions |
| `executable_*` | Executable (755) |
| `*.tmpl` | Processed as Go template |

## Directory Structure

```
home/
├── private_dot_config/     # ~/.config/
│   ├── hypr/               # Hyprland configs
│   ├── fish/               # Shell
│   ├── waybar/             # Status bar
│   └── ghostty/            # Terminal
├── dot_local/bin/          # ~/.local/bin/ scripts
└── .chezmoiscripts/        # One-time setup scripts
```

## Hyprland Config Files

All in `home/private_dot_config/hypr/`:

| File | Purpose |
|------|---------|
| `hyprland.conf.tmpl` | Main config, keybindings, window rules |
| `monitors.conf.tmpl` | Monitor setup |
| `autostart.conf.tmpl` | Startup applications |
| `colors.conf` | Color palette |
| `workspaces.conf` | Workspace definitions |
| `hyprpaper.conf.tmpl` | Wallpaper |
| `hypridle.conf.tmpl` | Idle/power management |
| `hyprlock.conf` | Lock screen |

## Template Conditionals

```go
{{- if eq .deviceProfile "desktop" }}
# Desktop only
{{- else if eq .deviceProfile "laptop" }}
# Laptop only
{{- end }}

{{- if .hasBattery }}
# Battery-dependent (laptop brightness keys, etc.)
{{- end }}

{{- if .hasTouchpad }}
# Touchpad settings
{{- end }}
```

## Key Commands

```bash
chezmoi apply          # Deploy changes
chezmoi diff           # Preview changes
chezmoi edit <file>    # Edit managed file
chezmoi add <file>     # Add new file to management
```

## Standards

- Scripts: `#!/usr/bin/env bash` with `set -euo pipefail`
- Secrets: Store in `~/secrets/`, reference via `{{ .secretsPath }}`
- Window rules: Use `windowrulev2` (not deprecated `windowrule`)
- Whitespace: Use `{{-` to trim in templates
