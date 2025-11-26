#!/usr/bin/env bash
# VPN status for waybar - outputs JSON

get_status() {
    local wg_status=""
    local nb_status=""
    local ts_status=""
    local text="VPN off"
    local tooltip="No VPN active"
    local class="disconnected"
    local has_tunnel=false  # true if WG, NetBird, or TS with exit node

    # Check NetBird
    if command -v netbird &>/dev/null; then
        nb_json=$(netbird status --json 2>/dev/null)
        if [[ -n "$nb_json" ]]; then
            nb_mgmt=$(echo "$nb_json" | jq -r '.management.connected // false')
            if [[ "$nb_mgmt" == "true" ]]; then
                nb_ip=$(echo "$nb_json" | jq -r '.netbirdIp // empty' | cut -d'/' -f1)
                nb_fqdn=$(echo "$nb_json" | jq -r '.fqdn // empty')
                nb_connected=$(echo "$nb_json" | jq -r '.peers.connected // 0')
                nb_total=$(echo "$nb_json" | jq -r '.peers.total // 0')

                # Extract network name from fqdn (e.g., box-128-45.lumia.overlay -> lumia)
                nb_net=$(echo "$nb_fqdn" | awk -F'.' '{print $(NF-1)}')

                nb_status="NB:${nb_net}(${nb_connected}/${nb_total})"
                tooltip="NetBird: ${nb_fqdn}\nIP: ${nb_ip}\nPeers: ${nb_connected}/${nb_total}"
                # NetBird mesh connection alone doesn't route all traffic like a VPN
            fi
        fi
    fi

    # Check WireGuard interfaces (excluding NetBird's wt0)
    wg_ifaces=$(ip link show type wireguard 2>/dev/null | grep -oP '^\d+: \K[^:]+' | grep -v '^wt')
    if [[ -n "$wg_ifaces" ]]; then
        wg_name=$(echo "$wg_ifaces" | head -1)
        wg_status="WG:$wg_name"
        [[ -z "$tooltip" || "$tooltip" == "No VPN active" ]] && tooltip=""
        [[ -n "$tooltip" ]] && tooltip+="\n"
        tooltip+="WireGuard: $wg_name"
        has_tunnel=true
    fi

    # Check Tailscale
    if command -v tailscale &>/dev/null; then
        ts_json=$(tailscale status --json 2>/dev/null)
        if [[ -n "$ts_json" ]]; then
            ts_state=$(echo "$ts_json" | jq -r '.BackendState // empty')

            if [[ "$ts_state" == "Running" ]]; then
                # Get tailnet name (domain)
                tailnet=$(echo "$ts_json" | jq -r '.CurrentTailnet.Name // empty')
                tailnet_short="${tailnet%.ts.net}"
                tailnet_short="${tailnet_short%.tail*}"

                # Check for exit node
                exit_node_id=$(echo "$ts_json" | jq -r '.ExitNodeStatus.ID // empty')
                exit_online=$(echo "$ts_json" | jq -r '.ExitNodeStatus.Online // false')

                if [[ -n "$exit_node_id" && "$exit_online" == "true" ]]; then
                    exit_host=$(echo "$ts_json" | jq -r '
                        .Peer | to_entries[] | select(.value.ExitNode == true) | .value.HostName // "exit"
                    ' 2>/dev/null)
                    [[ -z "$exit_host" || "$exit_host" == "null" ]] && exit_host="exit"

                    ts_status="TS:${tailnet_short}→${exit_host}"
                    [[ -n "$tooltip" ]] && tooltip+="\n"
                    tooltip+="Tailscale: ${tailnet}\nExit: ${exit_host}"
                    has_tunnel=true
                else
                    ts_status="TS:${tailnet_short}"
                    [[ -n "$tooltip" ]] && tooltip+="\n"
                    tooltip+="Tailscale: ${tailnet} (no exit)"
                    # No exit node = no tunnel, don't set has_tunnel
                fi
            fi
        fi
    fi

    # Build final output
    local parts=()
    [[ -n "$wg_status" ]] && parts+=("$wg_status")
    [[ -n "$nb_status" ]] && parts+=("$nb_status")
    [[ -n "$ts_status" ]] && parts+=("$ts_status")

    if [[ ${#parts[@]} -gt 0 ]]; then
        text=$(IFS=' | '; echo "${parts[*]}")
    fi

    # Only green if actual tunnel (WG, NetBird, or TS+exit)
    if [[ "$has_tunnel" == true ]]; then
        class="connected"
    elif [[ ${#parts[@]} -gt 0 ]]; then
        class="connected-no-tunnel"
    fi

    printf '{"text": "%s", "tooltip": "%s", "class": "%s"}\n' "$text" "$tooltip" "$class"
}

get_status
