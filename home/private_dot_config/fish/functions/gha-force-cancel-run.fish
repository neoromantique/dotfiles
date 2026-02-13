function gha-force-cancel-run --description "Force-cancel a GitHub Actions run using its URL"
    if test -z "$argv[1]"
        echo "Usage: gha-force-cancel-run <GitHub Actions run URL>"
        echo "Example: gha-force-cancel-run https://github.com/OWNER/REPO/actions/runs/123456789"
        return 1
    end

    set -l run_url $argv[1]
    set -l matches (string match --regex 'https://github.com/([^/]+)/([^/]+)/actions/runs/([0-9]+)' -- "$run_url")
    if test (count $matches) -eq 0
        echo "Error: Invalid GitHub Actions run URL format."
        echo "Expected format: https://github.com/OWNER/REPO/actions/runs/RUN_ID"
        return 1
    end

    set -l owner $matches[2]
    set -l repo $matches[3]
    set -l run_id $matches[4]

    echo "Attempting to force-cancel run ID: $run_id in $owner/$repo..."

    gh api \
        --method POST \
        -H "Accept: application/vnd.github.v3+json" \
        "/repos/$owner/$repo/actions/runs/$run_id/force-cancel"

    if test $status -eq 0
        echo "Force-cancel request sent successfully for run ID: $run_id"
    else
        echo "Failed to send force-cancel request for run ID: $run_id"
        echo "Check the error message above for details."
        return 1
    end
end
