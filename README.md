Mike Porter's dotfiles
======================

Personal dotfiles managed with [chezmoi](https://chezmoi.io). Covers shell
configuration, aliases, git, tmux, neovim, karabiner, aerospace, and more.


Install
-------

```sh
brew install chezmoi
chezmoi init --source ~/.dotfiles git@github.com:mupi2k/dotfiles.git
chezmoi apply
```

If you already have the repo cloned at `~/.dotfiles`:

```sh
brew install chezmoi
chezmoi apply
```

chezmoi reads `~/.config/chezmoi/chezmoi.toml` to find the source directory.
If that file doesn't exist yet, create it:

```toml
sourceDir = "/Users/<you>/.dotfiles"
```


Structure
---------

| Path | Deploys to |
|------|-----------|
| `dot_*` | `~/.*` |
| `dot_config/` | `~/.config/` |
| `default-configs/` | sourced by `.bashrc` / `.zshrc` |
| `custom-configs/` | local overrides (gitignored) |


Custom Configs
--------------

Files in `default-configs/` are sourced automatically by both `.bashrc` and
`.zshrc`. To override one on a specific machine, drop a file with the same
name into `custom-configs/` — the default will be skipped in favour of yours.

Any `*.sh` or `*.zsh` files added directly to `custom-configs/` are also
sourced unconditionally, making it a good place for machine-local settings
and secrets (API keys, work-specific aliases, etc.). The `custom-configs/`
directory is gitignored.


Locale
------

Make sure `LC_ALL` is set:

```sh
export LC_ALL=en_US.UTF-8
```
