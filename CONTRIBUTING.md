# Contributing to gh-ruleset-branch

Thanks for your interest in contributing to the gh-ruleset-branch ❤️

This document describes how to set up a development environment and submit your changes. Please
let us know if it's not up-to-date (even better, submit a PR with your  corrections ;-)).

- [Contributing to gh-ruleset-branch](#contributing-to-gh-ruleset-branch)
  - [Getting Started](#getting-started)
    - [Setup](#setup)
  - [Pull Requests](#pull-requests)
    - [Merge](#merge)

## Getting Started

The alternative is to use [Gitpod](https://www.gitpod.io/), a Cloud IDE for your development.

### Setup

```console
gh repo fork p6m7g8/gh-ruleset-branch --clone --org  $org --remote
cd gh-ruleset-branch
gh extensions install .
gh parallel -h
```

We recommend that you use [Visual Studio Code](https://code.visualstudio.com/).

## Pull Requests

- Create a commit with your changes and push them to a [fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo).

- Create a [pull request on Github](https://docs.github.com/en/github/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork).

- Pull request title and message (and PR title and description) must adhere to
  [conventionalcommits](https://www.conventionalcommits.org).
  - The title must begin with `feat(module): title`, `fix(module): title`, `refactor(module): title` or
    `chore(module): title`.
  - Title should be lowercase.
  - No period at the end of the title.

- Pull request message should describe _motivation_. Think about your code reviewers and what information they need in
  order to understand what you did. If it's a big commit (hopefully not), try to provide some good entry points so
  it will be easier to follow.

- Pull request message should indicate which issues are fixed: `fixes #<issue>` or `closes #<issue>`.

- Shout out to collaborators.

- If not obvious (i.e. from unit tests), describe how you verified that your change works.

- If this PR includes breaking changes, they must be listed at the end in the following format
  (notice how multiple breaking changes should be formatted):

  ```text
  BREAKING CHANGE: Description of what broke and how to achieve this behavior now
  * **module-name:** Another breaking change
  * **module-name:** Yet another breaking change
  ```

- Once the pull request is submitted, a reviewer will be assigned by the maintainers.

- Discuss review comments and iterate until you get at least one "Approve". When iterating, push new commits to the
  same branch. Usually all these are going to be squashed when you merge to master. The commit messages should be hints
  for you when you finalize your merge commit message.

- Make sure to update the PR title/description if things change. The PR title/description are going to be used as the
  commit title/message and will appear in the CHANGELOG, so maintain them all the way throughout the process.

### Merge

- Once approved and tested, one of our bots will squash-merge to master and will use your PR title/description as the
  commit message.
