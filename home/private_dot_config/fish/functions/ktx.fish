function ktx --description "Switch k8s context and enable prompt"
    kubeswitch ctx $argv
    set -g SHOW_K8S 1
end
