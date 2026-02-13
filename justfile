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
    pkill -USR2 qs || true

hypr-reload:
    hyprctl reload

# Combined helpers
apply-niri: apply niri-validate niri-reload

apply-qs: apply qs-reload

check: diff niri-validate
