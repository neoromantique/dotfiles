function tmpdir --description "Create and cd into a temp directory under ~/tmp"
    set -l date (date +%Y%m%d)

    if test -n "$argv[1]"
        set -l dir ~/tmp/$date-$argv[1]
        mkdir -p $dir && cd $dir
    else
        set -l dir ~/tmp/{$date}_(random)
        mkdir -p $dir && cd $dir
    end
end
