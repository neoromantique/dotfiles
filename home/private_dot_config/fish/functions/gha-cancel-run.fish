function gha-cancel-run --description "Cancel a GitHub Actions run using its URL"
    if test -z "$argv[1]"
        echo "Usage: gha-cancel-run <GitHub Actions run URL>"
        echo "Example: gha-cancel-run https://github.com/OWNER/REPO/actions/runs/123456789"
        return 1
    end

    set -l run_url $argv[1]

    # Extract owner, repo, and run_id from the URL using regular expressions
    # This regex is specifically designed to parse the run URL format
    if not string match --regex 'https://github.com/([^/]+)/([^/]+)/actions/runs/([0-9]+)' "$run_url"
        echo "Error: Invalid GitHub Actions run URL format."
        echo "Expected format: https://github.com/OWNER/REPO/actions/runs/RUN_ID"
        return 1
    end

    set -l owner (string match --regex --groups=1 'https://github.com/([^/]+)/([^/]+)/actions/runs/([0-9]+)' "$run_url")[2]
    set -l repo (string match --regex --groups=2 'https://github.com/([^/]+)/([^/]+)/actions/runs/([0-9]+)' "$run_url")[2]
    set -l run_id (string match --regex --groups=3 'https://github.com/([^/]+)/([^/]+)/actions/runs/([0-9]+)' "$run_url")[2]

    echo "Attempting to cancel run ID: $run_id in $owner/$repo..."

    gh api \
        --method POST \
        -H "Accept: application/vnd.github.v3+json" \
        "/repos/$owner/$repo/actions/runs/$run_id/cancel"

    if test $status -eq 0
        echo "Cancellation request sent successfully for run ID: $run_id"
    else
        echo "Failed to send cancellation request for run ID: $run_id"
        echo "Check the error message above for details."
        return 1
    end
end
