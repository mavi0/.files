# `.files`

Yet another dotfiles repo...

---

Dotfiles tested on MacOS and Ubuntu for the following programs:

 - ZSH
 - Git
 - Starship Prompt
 - Mackup
 - Vim 🚧
 - Act 🚧
 - Bat 🚧

## Installation

Simply symlink the relevant files and folders to your home directory. Or,
just run the provided `setup.sh` script to do this automatically.

> This install method is done automatically in a GitHub Codespaces provided your
> dotfiles repository is provided.

The setup script will also ensure some core applications are installed or the
setup will error.

## DevContainer Feature

To add these dotfiles (and relevant programs) to a debian-based devcontainer
image, simply add the feature to your `devcontainer.json`:

```json
...
"features": {
  ...
  "ghcr.io/willfantom/features/dotfiles:1": {}
},
...
```

## Docker Base Image

Also availaible are docker images (both debain and alpine base images) that can
be used as base images, baking the dotfiles into the container image. Available
on both AMD64 and ARM64.

- alpine based: `ghcr.io/willfantom/devcontainer:latest-alpine`
- debain based: `ghcr.io/willfantom/devcontainer:latest-debian`
