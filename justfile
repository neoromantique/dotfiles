set shell := ["bash", "-euo", "pipefail", "-c"]

# Show available recipes
default:
    @just --list

# Chezmoi workflows
apply:
    chezmoi apply

diff:
    chezmoi diff

status:
    chezmoi status

edit file:
    chezmoi edit {{file}}

# Niri workflows
niri-reload:
    niri msg action load-config-file

niri-validate:
    chezmoi execute-template < home/private_dot_config/niri/config.kdl.tmpl > /tmp/niri-config.kdl
    niri validate -c /tmp/niri-config.kdl

# Quickshell / Hypr helpers
qs-reload:
    qs kill || true
    qs -d

hypr-reload:
    hyprctl reload

fix-res:
    #!/usr/bin/env bash
    set -euo pipefail
    chezmoi apply ~/.config/hypr/monitors.conf
    batch=""
    while IFS= read -r line; do
        line=$(echo "$line" | xargs)
        [[ -z "$line" || "$line" == \#* ]] && continue
        [[ "$line" == monitor* ]] || continue
        rule="${line#monitor = }"
        echo "Applying: $rule"
        batch+="keyword monitor $rule;"
    done < ~/.config/hypr/monitors.conf
    hyprctl --batch "$batch"

# Combined helpers
apply-niri: apply niri-validate niri-reload

apply-qs: apply qs-reload

check: diff niri-validate
