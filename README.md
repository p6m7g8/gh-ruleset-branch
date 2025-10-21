# P6’s POSIX.2: gh-ruleset-branch

## Table of Contents

- [P6’s POSIX.2: gh-ruleset-branch](#p6s-posix2-gh-ruleset-branch)
  - [Table of Contents](#table-of-contents)
  - [Badges](#badges)
  - [Summary](#summary)
  - [Installation](#installation)
  - [Usage](#usage)
    - [Commands](#commands)
    - [Options](#options)
    - [Aliases](#aliases)
    - [Functions](#functions)
  - [Examples](#examples)
    - [Create a new ruleset](#create-a-new-ruleset)
    - [Show an existing ruleset](#show-an-existing-ruleset)
    - [Activate or deactivate](#activate-or-deactivate)
    - [Delete](#delete)
    - [Update simple toggles](#update-simple-toggles)
    - [Update parameterized rules](#update-parameterized-rules)
    - [Update status checks](#update-status-checks)
  - [Hierarchy](#hierarchy)
  - [Contributing](#contributing)
  - [Code of Conduct](#code-of-conduct)
  - [Author](#author)

---

## Badges

[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)
[![Mergify](https://img.shields.io/endpoint.svg?url=https://gh.mergify.io/badges//gh-ruleset-branch/&style=flat)](https://mergify.io)
[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com//gh-ruleset-branch)

---

## Summary

`gh-ruleset-branch` is a portable, GitHub CLI extension for managing **branch rulesets** directly from the command line.

It wraps the [GitHub REST API v3](https://docs.github.com/en/rest/repos/rules?apiVersion=2022-11-28) for repository rulesets and exposes simple subcommands to:
- create, show, activate, deactivate, or delete branch rulesets
- toggle individual rule types (`required_signatures`, `non_fast_forward`, `merge_queue`, etc.)
- set or modify parameters for multi-argument rules like `pull_request`, `merge_queue`, and `copilot_code_review`
- update rule parameters dynamically using a declarative `<rule>.<param>=<value>` syntax

---

## Installation

1. Ensure dependencies are installed:
   ```bash
   gh extension install p6m7g8/gh-ruleset-branch
   which jq gh
   ```
2. Verify access:
   ```bash
   gh auth status
   ```
3. Confirm the extension is working:
   ```bash
   gh ruleset-branch help
   ```

---

## Usage

```text
gh-ruleset-branch.zsh [options] <cmd> [<args>...]
```

### Commands

| Command | Description |
|----------|-------------|
| `activate <name>` | Activate a branch ruleset |
| `create <name>` | Create a branch ruleset |
| `deactivate <name>` | Deactivate a branch ruleset |
| `delete <name>` | Delete a branch ruleset |
| `show <name>` | Show a branch ruleset |
| `update <name> <what>=<value>` | Update a branch ruleset |

### Options

| Option | Description |
|---------|-------------|
| `-h` | Show help message |

---

### Aliases

You can alias the script to shorten invocations:

```bash
alias ghrb="gh ruleset-branch"
```

---

### Functions

| Function | Purpose |
|-----------|----------|
| `p6_usage()` | Prints help text |
| `p6_cmd_activate(name)` | Activates a ruleset |
| `p6_cmd_deactivate(name)` | Deactivates a ruleset |
| `p6_cmd_create(name)` | Creates a new ruleset |
| `p6_cmd_delete(name)` | Deletes a ruleset |
| `p6_cmd_show(name)` | Shows JSON for a ruleset |
| `p6_cmd_update(name, ...)` | Updates or patches ruleset content |

---

## Examples

### Create a new ruleset

```bash
gh ruleset-branch create default
```

### Show an existing ruleset

```bash
gh ruleset-branch show default | jq
```

### Activate or deactivate

```bash
gh ruleset-branch activate default
gh ruleset-branch deactivate default
```

### Delete

```bash
gh ruleset-branch delete default
```

### Update simple toggles

```bash
gh ruleset-branch update default required_signatures=enabled
gh ruleset-branch update default required_signatures=disabled
```

### Update parameterized rules

```bash
# Update pull request approvals and stale-review behavior
gh ruleset-branch update default pull_request.required_approving_review_count=2 pull_request.dismiss_stale_reviews_on_push=true

# Adjust merge queue parameters
gh ruleset-branch update default merge_queue.merge_method=SQUASH merge_queue.check_response_timeout_minutes=7

# Enable Copilot code reviews
gh ruleset-branch update default copilot_code_review.review_on_push=true copilot_code_review.review_draft_pull_requests=true
```

### Update status checks

```bash
gh ruleset-branch update default required_status_checks.context=build required_status_checks.integration_id=15368
```

---

## Hierarchy

```text
.
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── FUNDING
├── init.zsh
├── LICENSE
├── README.md
├── SECURITY.md
└── SUPPORT
```

---

## Contributing

Pull requests are welcome.
Please lint with `shellcheck`, test with `bash -n`.

See [How to Contribute](https://github.com//.github/blob/main/CONTRIBUTING.md).

---

## Code of Conduct

See [Code of Conduct](https://github.com//.github/blob/main/CODE_OF_CONDUCT.md).

---

## Author

**Philip M. Gollucci** <pgollucci@p6m7g8.com>
