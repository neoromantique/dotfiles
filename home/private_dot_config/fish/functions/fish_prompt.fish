function fish_prompt
    set -l last_status $status
    set -l git_prompt
    set -l git_branch

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

    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set git_branch (git symbolic-ref --quiet --short HEAD 2>/dev/null; or git rev-parse --short HEAD 2>/dev/null)

        if test "$git_branch" != main -a "$git_branch" != master
            set git_prompt " [$git_branch"
        else
            set git_prompt " ["
        end

        if test -n "$(git status --porcelain --ignore-submodules=dirty 2>/dev/null)"
            set git_prompt "$git_prompt"(set_color red)"*"
        else
            set git_prompt "$git_prompt"(set_color green)"✓"
        end

        set git_prompt "$git_prompt"(set_color normal)"]"
    end

    # Red prompt on error, normal otherwise
    if test $last_status -ne 0
        set_color red
    end
    printf '%s%s> ' (prompt_pwd) "$git_prompt"
    set_color normal
end
