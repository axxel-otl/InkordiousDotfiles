# Inkordious Dotfiles

> To install the Bedrock Linux version you have to use pmm configured to mimick pacman, otherwise, the install script will fail. Thid will be fixed when the on-the-fly ui mode for pmm is added in Bedrock Linux 0.8: Naga

Howdy, I'm axxel, the creator of the dotfiles in this repository. This repository includes:

- zsh configs

- git commands

<!-- - fastfetch configs -->

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
│   └── .config
│       └── fastfetch
│           ├── config.jsonc
│           └── pngs
│               └── .gitkeep
├── bedrock
│   └── .config
│       └── fastfetch
│           ├── config.jsonc
│           └── pngs
│               └── .gitkeep
├── CONTRIBUTING.md
├── CREDITS.md
├── install.sh
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

I'd like to add more documentation, but I'm not too good at it, however, this way, you will have my dotfiles :3
