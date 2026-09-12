# Inkordious Dotfiles

<a href="https://github.com/Axxel-otl/InkordiousDotfiles/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/Axxel-otl/InkordiousDotfiles?style=flat-square&color=81a1c1" alt="License" />
  </a>
  <a href="https://github.com/Axxel-otl/InkordiousDotfiles/graphs/contributors">
    <img src="https://img.shields.io/github/contributors/Axxel-otl/InkordiousDotfiles?style=flat-square&color=a3be8c" alt="Contributors" />
  </a>
  <a href="https://github.com/Axxel-otl/InkordiousDotfiles/stargazers">
    <img src="https://img.shields.io/github/stars/Axxel-otl/InkordiousDotfiles?style=flat-square&color=ebcb8b" alt="Stars" />
  </a>

Howdy, I'm axxel, the creator of the dotfiles in this repository.

- zsh configs

- git commands

- fastfetch configs

- kitty configs

And I'm planning to add more! ¯\\\_(ツ)_/¯

## Guide

- [Inkordious Dotfiles](#inkordious-dotfiles)

- [Guide](#guide)

- [Tree](#tree)

- [Supported Distros](#supported-distros)

- [Install Instructions](#install-instructions)

  - [Uninstall Instructions](#uninstall-instructions)

## Tree

<details>
  <summary>Repository Structure</summary>
  <!-- TREE_START -->

  ```text
  .
  ├── .gitignore
  ├── arch
  │   ├── .config
  │   │   ├── fastfetch
  │   │   │   ├── config.jsonc
  │   │   │   └── pngs
  │   │   │       └── .gitkeep
  │   │   └── kitty
  │   │       ├── kitty.conf
  │   │       ├── theme.conf
  │   │       └── userprefs.conf
  │   └── .local
  │       └── bin
  │           ├── git-cc
  │           ├── git-db
  │           ├── git-fork
  │           ├── git-graph
  │           ├── git-nb
  │           ├── git-pr
  │           └── git-tree
  ├── bedrock
  │   ├── .config
  │   │   ├── fastfetch
  │   │   │   ├── config.jsonc
  │   │   │   └── pngs
  │   │   │       └── .gitkeep
  │   │   └── kitty
  │   │       ├── kitty.conf
  │   │       ├── theme.conf
  │   │       └── userprefs.conf
  │   └── .local
  │       └── bin
  │           ├── git-cc
  │           ├── git-db
  │           ├── git-fork
  │           ├── git-graph
  │           ├── git-nb
  │           ├── git-pr
  │           └── git-tree
  ├── CONTRIBUTING.md
  ├── CREDITS.md
  ├── install.sh
  ├── install.sh.old
  ├── LICENSE
  ├── manifest.yaml
  └── README.md

  ```

  <!-- TREE_END -->
</details>

## Supported Distros

This repository supports 2 Linux Distributions so far: [Bedrock Linux](https://bedrocklinux.org) and [Arch Linux](https://archlinux.org)

## Install Instructions
To install my dotfiles, you can run this in your terminal:
```bash
curl -LfsS "https://gitlab.com/axxel-otl/InkordiousDotfiles/-/raw/$(curl -LfsS 'https://gitlab.com/api/v4/projects/axxel-otl%2FInkordiousDotfiles/releases/permalink/latest' | yq -r '.tag_name')/install.sh" | bash
```
### Uninstall Instructions
If you don't want to install them but to **un**install them, you can run this in your terminal:
```bash
curl -LfsS "https://gitlab.com/axxel-otl/InkordiousDotfiles/-/raw/$(curl -LfsS 'https://gitlab.com/api/v4/projects/axxel-otl%2FInkordiousDotfiles/releases/permalink/latest' | yq -r '.tag_name')/install.sh" | bash -s -- -u
```

And that's it, this way, you will have my dotfiles :3
