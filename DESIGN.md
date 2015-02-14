dotfileleader design
-------------------

dotfileleader is a tool for helping manage dotfiles and ~/bin across
machines.

It is:
- written in Ruby
  - mixlib-shellout
- designed to be self-contained
  - bundle install/bundle exec

It uses:
- ssh
- git
- rsync
- YAML for configs

Manages:
- public dotfiles
- private dotfiles (building config files from env variables or gpg
encrypted sourced)
- application bundles (tarball of a compiled binary for when you can't
easily install a newer version on a machine but can rsync a copy in
~/bin

Syncs:
- tracks and keeps remote git repositories in sync for backups/sharing
- keeps remote machines in sync
  - supports auto-push
  - can auto-push or just alert when a machine is out of sync,
toggleable
- supports configuring what goes where by
  - groups of machines (wildcard.example.com)
  - sets of files
- shell function to check if remote machines are up to date (ssh
wrapper?)

Binaries:
- separate repo for binaries we want to have available to copy? use
github releases? circle-ci + docker for builds?
