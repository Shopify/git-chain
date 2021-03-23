# Git Chain

Tool to rebase multiple Git branches based on the previous one.

## What does Git Chain do?

If you're working on a larger feature that you want to ship in smaller, easier reviewable pull requests, there's a big chance
that you're creating separate branches for each of them. If the changes don't depend on each other – congratulations 🎉! 
You can simply base all branches on the master branch and work on them and merge without interference.

But if your second branch depends on changes in the first and your third branch on changes in the second you'll end up
doing a lot of manual rebases in case one of your base branches changes (e.g. because you addressed a comment in a review).

Git Chain can help you with automating this task. You can specify a chain of branches and rebase them all with a
single command: `git chain rebase`.

## Requirements

- Git (of course)
- System Ruby (`/usr/bin/ruby -v >= 2.3.7`) 

## Installation

```sh
$ git clone https://github.com/Shopify/git-chain /usr/local/share/git-chain # Or any folder you see fit
$ ln -sv /usr/local/share/git-chain/bin/git-chain /usr/local/bin/ # Or any location in your PATH

$ git chain # Should now work
```

## Demo

![Demo recording](docs/demo.gif)
 
## Example

Let's have a look at an example. Imagine the following feature: You want to add a new database table (pull request 1), add a model
using the table (pull request 2) and build a user interface for editing records (pull request 3).

At the beginning you'll have this nice clean git history (`git log --oneline --all --graph`, branch names in parentheses):

```
* e7888f9 (HEAD -> feature-ui) feature-ui.2
* a743802 (feature-model) feature-model.1
* 9cc4914 (feature-database) feature-database.1
* f6ba0e9 (master) master.1
```

You continue work on your branches, your colleagues merge their changes into the master and after a while the git history
looks like this:

```
* 56b953a (feature-model) feature-model.2
| * e7888f9 (HEAD -> feature-ui) feature-ui.2
| * 14090bb feature-ui.1
|/  
* a743802 feature-model.1
| * 8c46072 (feature-database) feature-database.2
|/  
* 9cc4914 feature-database.1
| * fdca13e (master) master.2
|/  
* f6ba0e9 master.1
```

Getting back to the linear git history requires you to manually rebase all branches on top of each other, i.e the `database`
branch onto `master`, the `model` branch onto `database` and the `ui` branch on top of `model`.

Let's automate this using Git Chain.

### Setting up a chain

Git Chain first needs to learn about the intended branch order. We call this a 'branch chain'. You can create one using
the `git chain` command.

```
$ git chain setup -c awesome-feature master feature-database feature-model feature-ui
Setting up chain awesome-feature
```

The name of the chain can be specified using the `-c` option. The first argument (in this case `master`) is the name of
base branch that we want the chain to be rebased onto in the future.

This setup step only needs to be done once per chain.

### Rebasing a chain

You can now rebase all branches in one go:

```
$ git chain rebase
Rebasing the following branches: ["master", "feature-database", "feature-model", "feature-ui"]
```

Git Chain detects the current chain based on the branch you're currently on (a branch can only be part of one chain). You can
specify a chain explicitly by using the `-c` option you already saw during setup.

```
$ git checkout master
$ git chain rebase   
Current branch 'master' is not in a chain.
$ git chain rebase -c awesome-feature
Rebasing the following branches: ["master", "feature-database", "feature-model", "feature-ui"]
```

After that you'll end up with a clean history:

```
* 7974771 (HEAD -> feature-ui) feature-ui.2
* 1427391 feature-ui.1
* 9877787 (feature-model) feature-model.2
* 3ad1096 feature-model.1
* 8e333d6 (feature-database) feature-database.2
* 00ac4d1 feature-database.1
* fdca13e (master) master.2
* f6ba0e9 master.1
```

## Handling conflicts

Of course, not everything will be as easy as in this idealized case. You'll certainly end up in situations where the rebase 
operations won't apply cleanly and you need to resolve merge conflicts. Git Chain stops when a rebase fails and
leaves the repository at that state. You'll have to manually resolve the conflict, finish the current rebase and invoke
`git chain rebase` again to continue.

Let's look at another example which contains conflicting changes.

```
* 97637af (a) a.2 (conflicting with b)
| * 953b860 (c) c.1
| * 34a2c98 (b) b.1
|/  
* 8d9b8fd a.1
* 0d3fd86 (HEAD -> master) master.1
```

The rebase of branch `a` onto `master` will work but `b` will have a conflict when rebased on `a`.

```
$ git chain rebase
Rebasing the following branches: ["master", "a", "b", "c"]
Cannot merge b onto a. Fix the rebase and run 'git chain rebase' again. 
...

[...resolving the conflict...]
$ git rebase --continue
Successfully rebased and updated refs/heads/b.
$ git chain rebase
Rebasing the following branches: ["master", "a", "b", "c"]
```

## Pushing chains to GitHub pull requests

GitHub supports setting a base branch of a pull request via the user interface. You'll need to do this for all branches
in a chain manually for now.

Edit a pull request:

![Pull request header](docs/screenshot_pr_header.png)

Setting the base branch:

![Edit pull request base](docs/screenshot_pr_header_edit.png)

Once this is done and all remotes are set you can push all branches in a chain using `git chain push`.
