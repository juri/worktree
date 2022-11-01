# Worktrees

A helper tool for git worktrees.

## What it does

Right now it has one command: `add-new-branch`.

### add-new-branch

Creates a new worktree, pointing at a new branch, starting from committish.

You specify three arguments:

- A prefix that's applied to the worktree name to form the branch name
- The commit to branch off from
- The worktree name

The order of the arguments is designed for easy usage with git aliases.
Example:

```
[alias]
    wta = !worktree add-new-branch username/ main
```

Now running `git wta feature` will create brach `username/feature` starting from
`main`, tracked in worktree `feature`.

## Licensing

This software is licensed under the terms of the MIT license. For details, see the file LICENSE.
