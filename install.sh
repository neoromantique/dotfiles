#!/usr/bin/env bash
#
# Dotfiles Bootstrap & Management Script
#

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info()  { echo -e "${BLUE}[INFO]${NC} $*"; }
log_ok()    { echo -e "${GREEN}[OK]${NC} $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }

DISTRO="unknown"
DOTFILES_DIR="$HOME/dotfiles"

detect_distro() {
    if [[ -f /etc/arch-release ]]; then
        echo "arch"
    elif command -v rpm-ostree &>/dev/null; then
        echo "fedora-atomic"
    elif [[ -f /etc/fedora-release ]]; then
        echo "fedora"
    else
        echo "unknown"
    fi
}

install_chezmoi() {
    if command -v chezmoi &>/dev/null; then
        log_ok "chezmoi already installed: $(chezmoi --version | head -1)"
        return 0
    fi

    log_info "Installing chezmoi..."
    case "$DISTRO" in
        arch)
            sudo pacman -S --noconfirm chezmoi
            ;;
        fedora)
            sudo dnf install -y chezmoi
            ;;
        fedora-atomic)
            if command -v brew &>/dev/null; then
                brew install chezmoi
            else
                mkdir -p ~/.local/bin
                sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
                export PATH="$HOME/.local/bin:$PATH"
            fi
            ;;
        *)
            mkdir -p ~/.local/bin
            sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
            export PATH="$HOME/.local/bin:$PATH"
            ;;
    esac
    log_ok "chezmoi installed"
}

setup_secrets() {
    local secrets_dir="$HOME/secrets"
    if [[ ! -d "$secrets_dir" ]]; then
        log_info "Creating secrets directory..."
        mkdir -p "$secrets_dir/vpn"
        chmod 700 "$secrets_dir"
        log_ok "Created $secrets_dir"
    fi
}

init_chezmoi() {
    local repo_url="${1:-}"
    if [[ -n "$repo_url" ]]; then
        log_info "Initializing from: $repo_url"
        chezmoi init "$repo_url"
    elif [[ -d "$DOTFILES_DIR/home" ]]; then
        log_info "Initializing from local: $DOTFILES_DIR/home"
        chezmoi init --source="$DOTFILES_DIR/home" --prompt=false
    else
        log_error "No repo URL and ~/dotfiles not found"
        exit 1
    fi
}

is_initialized() {
    [[ -f "$HOME/.config/chezmoi/chezmoi.toml" ]] && chezmoi source-path &>/dev/null
}

check_config_outdated() {
    # Check if config template has changed
    if chezmoi diff 2>&1 | grep -q "config file template has changed"; then
        log_warn "Config template changed, regenerating..."
        chezmoi init --source="$DOTFILES_DIR/home" --prompt=false
        log_ok "Config regenerated"
    fi
}

show_menu() {
    echo ""
    echo "  1) diff    - Show pending changes"
    echo "  2) apply   - Apply dotfiles"
    echo "  3) reinit  - Re-initialize (change profile)"
    echo "  4) update  - Pull latest and apply"
    echo "  5) edit    - Edit a managed file"
    echo "  q) quit"
    echo ""
}

manage_menu() {
    while true; do
        show_menu
        read -rp "Choice: " choice
        echo ""
        case "$choice" in
            1|diff)
                chezmoi diff | less -R
                ;;
            2|apply)
                chezmoi apply -v
                log_ok "Applied!"
                ;;
            3|reinit)
                chezmoi init --force
                ;;
            4|update)
                chezmoi update -v
                log_ok "Updated!"
                ;;
            5|edit)
                read -rp "File to edit (e.g. ~/.config/hypr/hyprland.conf): " file
                [[ -n "$file" ]] && chezmoi edit "$file"
                ;;
            q|quit|exit)
                break
                ;;
            *)
                log_warn "Invalid choice"
                ;;
        esac
    done
}

main() {
    DISTRO=$(detect_distro)

    echo ""
    echo "========================================"
    echo "         Dotfiles Manager              "
    echo "========================================"
    echo ""
    log_info "Distro: $DISTRO | Host: $(hostname)"

    install_chezmoi
    setup_secrets

    if is_initialized; then
        log_ok "Chezmoi already initialized"
        check_config_outdated
        manage_menu
    else
        init_chezmoi "${1:-}"
        echo ""
        log_ok "Bootstrap complete!"
        echo ""
        read -rp "Apply dotfiles now? [Y/n] " apply
        if [[ ! "$apply" =~ ^[Nn]$ ]]; then
            chezmoi apply -v
            log_ok "Applied!"
        else
            echo "Run 'chezmoi diff' to review, 'chezmoi apply' to install"
        fi
    fi
}

main "$@"
