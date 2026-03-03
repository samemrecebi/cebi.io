---
date: 2023-10-19
description: Learn to manage your dotfiles effortlessly with Stow and Git for a streamlined developer experience.
tags:
  - git
  - blog
  - stow
  - dotfiles
title: Effortless Dotfile Management with Stow and Git
categories:
  - Dotfiles
  - Organization
keywords:
  - stow
slug: managing-dotfiles-stow-git
---

## Preface

Hello everybody, for my first (proper) post to this blog I wanted to talk about how I currently manage my dotfiles using Stow and git.

## Reasoning

As with anything related to the developer experience, there is an endless rabbit hole related to managing your dotfiles. I have tried a few of them like [Dotbot](https://github.com/anishathalye/dotbot) and [Chezmoi](https://www.chezmoi.io/). Both of them are great tools, but I found them to be needlessly complicated, especially for my use case.

Realistic an average user will only need to initialize their dofiles from scratch every so often. Also features to manage difference between machines are not needed for most people.

For my use case I wanted a tool to just create the necessary symlinks for my dotfiles and to be able to easily push and pull them from a git repo. Stow is a tool that does just that.

## My setup

The applications I need to manage are:

- Git
- Zsh
- [Starship](https://starship.rs/)
- [Emacs](https://www.gnu.org/software/emacs/)

### Directory setup

To start I created a `.dotfiles` in my home directory. This is where I will keep my dotfiles. The location is important as stow will create symlinks in the parent directory of the directory you are running it from.

My directory is set up like this:

```console
.dotfiles
├── .config
│   ├── alacritty
│   │   └── alacritty.yml
│   └── starship.toml
├── .emacs.d
│   └── init.el
├── .gitconfig
├── .gitignore
├── .stow-local-ignore
├── .zshrc
├── LICENSE
└── README.md
```

As you can see I recreated the directory structure of my home directory.

What I mean is, my starship config file needs to be in `~/.config/starship.toml`, so I created a `.config` directory in my dotfiles directory and put the `starship.toml` file in there.

### Stow setup

Before you start you need to install Stow for your system. On macOS you can simply install it using Homebrew.

```zsh
brew install stow
```

On Linux you can install it using your package manager.

```bash
# For Debian based distros
sudo apt install stow
# For Arch based distros
sudo pacman -S stow
```

Now you can start using Stow but before running it, I would recommend for you to create a `.stow-local-ignore` file. This file will be used by Stow to ignore files and directories that you don't want to symlink like the `.git` directory.

My `.stow-local-ignore` file looks like this:

```text
\.git
\.gitignore

^/README.*
^/LICENSE.*
^/COPYING
```

This will ignore the `.git` directory, the `.gitignore` file and any file that starts with `README` or `LICENSE`.

Now the only thing you need to run is

```zsh
stow .
```

and your files will be symlinked to your home directory.

## Closing thoughts

This method should give you a simple way to manage your dotfiles. If you want you could also try other methods based on your use cases like [Chezmoi](https://www.chezmoi.io/) or [Dotbot](https://github.com/anishathalye/dotbot) but for me, I prefer a solution that is simple and easy to understand.
