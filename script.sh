#!/bin/bash

set -e

repo_path=""
csv_output_dir_path=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --repo)
            repo_path="$2"
            shift 2
            ;;
        --output)
            csv_output_dir_path="$2"
            shift 2
            ;;
        *)
            echo "Unknown argument: $1"
            echo "Usage: $0 --repo <repo_path> --output <csv_output_dir_path>"
            exit 1
            ;;
    esac
done

if [[ -z "$repo_path" || -z "$csv_output_dir_path" ]]; then
    echo "Usage: $0 --repo <repo_path> --output <csv_output_dir_path>"
    exit 1
fi

repo_url=$(git -C "$repo_path" remote get-url origin)

if [[ "$repo_url" == git* ]]; then
    repo_host=$(echo "$repo_url" | awk -F '[@:]' '{print $2}')
    author_username=$(echo "$repo_url" | awk -F '[:/]' '{print $2}')
    repo_name=$(echo "$repo_url" | awk -F '/' '{print $NF}' | awk -F '\\.git' '{print $1}')
    repo_url="https://$repo_host/$author_username/$repo_name"
elif [[ "$repo_url" == https* ]]; then
    repo_host=$(echo "$repo_url" | awk -F '[:/]' '{print $4}')
    author_username=$(echo "$repo_url" | awk -F '[:/]' '{print $5}')
    repo_name=$(echo "$repo_url" | awk -F '/' '{print $NF}' | awk -F '\\.git' '{print $1}')
    repo_url="https://$repo_host/$author_username/$repo_name"
fi 

logs=$(git log --pretty=format:"commit_date=%ah commit_msg=%s commit_sha=%H" --reverse)

echo "date,message,url,tree_url" > "$csv_output_dir_path/commits.csv"

echo "$logs" | while IFS= read -r log_line; do
    commit_date=$(echo "$log_line" | awk -F 'commit_date=| commit_msg=| commit_sha=' '{print $2}')
    commit_msg=$(echo "$log_line" | awk -F 'commit_date=| commit_msg=| commit_sha=' '{print $3}')
    commit_sha=$(echo "$log_line" | awk -F 'commit_date=| commit_msg=| commit_sha=' '{print $4}')

    # The commit_url and repo_tree is currently structured for GitHub.
    # TODO: Add support for other Git hosting services like GitLab, Bitbucket, etc.
    commit_url="${repo_url}/commit/$commit_sha"
    repo_tree="${repo_url}/tree/$commit_sha"

    echo "\"$commit_date\",\"$commit_msg\",\"$commit_url\",\"$repo_tree\"" >> "$csv_output_dir_path/commits.csv"
done