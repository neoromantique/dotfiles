function fish_prompt
    set -l last_status $status

    # Only if the user has explicitly flipped SHOW_K8S on do we fetch & show
    if test "$SHOW_K8S" = "1"
        # Single kubectl call for both context and namespace
        set -l kube_info (kubectl config view --minify --output 'jsonpath={.current-context}/{..namespace}' 2>/dev/null)
        if test -n "$kube_info"
            # Default namespace if none set
            set kube_info (string replace -r '/$' '/default' $kube_info)
            echo -n "[k8s:$kube_info] "
        end
    end

    # Red prompt on error, normal otherwise
    if test $last_status -ne 0
        set_color red
    end
    printf '%s> ' (prompt_pwd)
    set_color normal
end

