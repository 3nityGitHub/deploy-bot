# Deploy Bot

A self-documenting deployment toolkit: four Bash scripts that take a project
from source code to a verified, running service. Built to practise the full
Linux + Git + build-tool workflow end to end.

## What it does

| Script          | Job                                                           |
|-----------------|---------------------------------------------------------------|
| `healthcheck.sh`| Verify every required build tool is installed before starting |
| `build.sh`      | Build a project with the chosen tool, report the artifact     |
| `run.sh`        | Start the app in the background and confirm it is running     |
| `deploy.sh`     | Chain build → run, stopping at the first failure              |

## Requirements

`java`, `maven`, `gradle`, `node`, `npm`. `healthcheck.sh` checks for all of
them and exits non-zero if any are missing.

## Usage

```bash
# Check the environment
./healthcheck.sh

# Build a project (tool = maven | gradle | node)
./build.sh maven ~/week3-project/my-app

# Start an app and verify it is alive
./run.sh "sleep 30" ./logs

# Full pipeline: build then run, stops if anything fails
./deploy.sh maven ~/week3-project/my-app "sleep 30" ./logs
```

## How it works together

`deploy.sh` begins with `set -euo pipefail`, so if any step fails the whole
pipeline stops immediately — a broken build can never reach the run step.
`build.sh` runs `healthcheck.sh` itself, so the environment is always verified
before a build begins.

## What broke and how I fixed it

**Wrong shebang.** I wrote `#!/dev/bash` instead of `#!/bin/bash`. The script
refused to run with "bad interpreter: No such file or directory". bash lives in
`/bin`, not `/dev` — `which bash` confirms the path, it was just an oversight. I fixed by correcting the
shebang to `#!/bin/bash`.

**Quoting a command with arguments.** `run.sh` reported "Failed to start" even
though the app was fine. I ran `cat` on the log file and saw
`sleep 30: command not found` — with `"$APP"` quoted, bash looked for a single
program literally named "sleep 30". Removing the quotes (`$APP`) let bash split
it into the command `sleep` plus its argument `30`, and the run succeeded.

**PR merged into the wrong branch.** After building `build.sh`, `main` still
only had `healthcheck.sh`. The build work had been committed and pushed to its
feature branch but the pull request was never merged into `main`. I fixed it by
pushing the branch, opening the PR against `main`, and merging it — and the
lesson was to always check the PR's base branch before merging.

## What I learned

This project sharpened my Bash scripting and gave me a much clearer grasp of
script automation: exit codes as the real success/failure signal, passing and
validating arguments with `$1`/`$2`, chaining scripts safely with
`set -euo pipefail`, and running a proper Git feature-branch and pull-request
workflow on GitHub.
