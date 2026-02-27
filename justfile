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
    mon=$(chezmoi execute-template '{{ "{{" }} .primaryMonitor {{ "}}" }}')
    res=$(chezmoi execute-template '{{ "{{" }} .primaryResolution {{ "}}" }}')
    echo "Applying $res to $mon"
    hyprctl keyword monitor "$mon,$res,0x0,1"

# Combined helpers
apply-niri: apply niri-validate niri-reload

apply-qs: apply qs-reload

check: diff niri-validate
