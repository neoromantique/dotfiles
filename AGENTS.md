# AGENTS Guide: Dotfiles Repository

Chezmoi-managed dotfiles. Source in `~/dotfiles/`, deployed via `chezmoi apply`.

## Device Profiles

| Profile | Hostname | Primary Monitor | Touchpad | Battery |
|---------|----------|-----------------|----------|---------|
| desktop | box | DP-2 | No | No |
| laptop | bluefin | eDP-1 | Yes | Yes |

## Template Variables

`{{ .deviceProfile }}` (desktop/laptop), `{{ .hostname }}`, `{{ .primaryMonitor }}`, `{{ .hasTouchpad }}`, `{{ .hasBattery }}`, `{{ .idleTimeout }}` (300/180), `{{ .secretsPath }}` (~/secrets)

## File Naming

- `private_dot_*` — hidden, 700 perms
- `dot_*` — hidden, 755 perms
- `executable_*` — 755
- `*.tmpl` — Go template

## Structure

```
home/
├── private_dot_config/   # hypr/, fish/, waybar/, ghostty/, quickshell/
├── dot_local/bin/        # scripts
└── .chezmoiscripts/      # one-time setup
```

## Hyprland (`home/private_dot_config/hypr/`)

`hyprland.conf.tmpl` (main/keybinds/rules), `monitors.conf.tmpl`, `autostart.conf.tmpl`, `colors.conf`, `workspaces.conf`, `hyprpaper.conf.tmpl`, `hypridle.conf.tmpl`, `hyprlock.conf`

## Standards

- Scripts: `#!/usr/bin/env bash` + `set -euo pipefail`
- Secrets via `{{ .secretsPath }}`
- Use `windowrulev2` (not `windowrule`)
- Use `{{-` to trim whitespace in templates

## QuickShell (`home/private_dot_config/quickshell/shell.qml.tmpl`)

Single-file bottom bar + popups. VPN scripts in `dot_local/bin/executable_vpn-{status,switcher,helper}`.

### Design Language

- **Theme**: dark, minimal, no rounded corners (`radius: 0` on modules)
- **Colors** (all defined as root properties, no raw hex in components):
  - Backgrounds: `bgColor` `#0f0f0f`, `bgSecondary` `#1a1a1a` (modules/cards), `bgTertiary` `#242424` (hovers)
  - Text: `fgColor` `#e0e0e0`, `textSecondary` `#b0b0b0`, `dimColor` `#888888`
  - Accent: `accentColor` `#e67e22`
  - Status: `okColor` `#2ecc71`, `warnColor` `#f1c40f`, `critColor` `#e74c3c`, `infoColor` `#3498db`
  - Borders: `borderColor` `#333333`, `borderSubtle` `#2a2a2a`
- **Font**: `"Terminus, IBM Plex Mono, JetBrainsMono Nerd Font, monospace"` at 12px (11px for section headers)
- **Text-only indicators** — no icons. Prefixed labels: `VOL 85%`, `MIC muted`, `NET eth 10.0.0.5`, `CPU 12%`, `MEM 34%`, `BAT 72%`, `BRT 50%`, `TIME 2025-01-15 14:30`
- **Bar**: bottom-anchored, 34px total height, 4px outer margin, 6px inner row padding
- **Modules**: `ModuleBox` component — `bgSecondary` bg, 1px border, 22px height, content padded 12px wide
- **Layout**: left group (workspaces) + flexible spacer + right group (vpn, vol, mic, net, [bat, brt on laptop], cpu, mem, clock, tray), 6px spacing between modules
- **Popups**: item rows 24px, hover `bgTertiary`, `●` active / `○` inactive, section headers `━━ Title ━━` in dim color

### QuickShell Patterns

- **Popups**: fullscreen transparent overlay `PanelWindow` (all anchors true, `ExclusionMode.Ignore`), NOT a second positioned PanelWindow. Three mouse layers: background dismiss, absorb on popup rect, content Column `z: 1`
- **Cross-window positioning**: `mapToItem(null, 0, 0)` only maps within own window. Compute popup X from layout math against `rightGroup.implicitWidth`
- **Process sync**: pending counter, decrement in each `onStreamFinished`, combine at 0
- **Bash safety**: `command -v foo &>/dev/null && foo || echo '{}'`. Use `---TAG---` separators for JS parsing
- **QML reactivity**: assign NEW object (`Object.assign({}, old, changes)`) to trigger bindings
- **Keyboard input in popups**: set `focusable: true` on the PanelWindow
- **PulseAudio**: `pactl list sinks` (not `short`) for descriptions; filter sources with `grep -v '\.monitor'`
