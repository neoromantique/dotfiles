complete -c j -a "(__z -l | string replace -r '^\S*\s*' '')" -f -k
complete -c j -s c -l clean -d "Cleans out \$Z_DATA"
complete -c j -s e -l echo -d "Prints best match, no cd"
complete -c j -s l -l list -d "List matches, no cd"
complete -c j -s p -l purge -d "Purges \$Z_DATA"
complete -c j -s r -l rank -d "Searches by rank, cd"
complete -c j -s t -l recent -d "Searches by recency, cd"
complete -c j -s h -l help -d "Print help"
complete -c j -s x -l delete -d "Removes the current directory from \$Z_DATA"
