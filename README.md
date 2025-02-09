## Git Log to CSV (`git-log-to-csv`)

This script converts git commit logs into a CSV file with commit date, message, URL, and tree URL.

## Usage

```bash
./script.sh --repo <repo_path> --output <csv_output_dir_path>
```

### Arguments

- `--repo <repo_path>`: Path to the git repository.
- `--output <csv_output_dir_path>`: Directory path where the CSV file will be saved.

### Example

```bash
./script.sh --repo /path/to/repo --output /path/to/output
```

This will generate a `commits.csv` file in the specified output directory with the following columns:
- `date`: The date of the commit.
- `message`: The commit message.
- `url`: The URL to the commit on the remote repository.
- `tree_url`: The URL to the tree of the commit on the remote repository.

### Notes

- The script currently supports GitHub URLs. Support for other Git hosting services like GitLab, Bitbucket, etc., can be added.
- Ensure you have the necessary permissions to access the repository and write to the output directory.

### License

This project is licensed under the [MIT License](https://choosealicense.com/licenses/mit/)