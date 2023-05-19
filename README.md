# Dotfiles

This repository contains my collection of dotfiles, including a comprehensive
Fish shell setup and additional tools such as Black, Ruff, Mypy, and more.

To quickly set up your environment, I recommend using the
[OS Setup](https://github.com/Nachtalb/os-setup) tool. It provides an automated
installation process that includes the dotfiles from this repository.

## Installation

For a convenient installation without cloning the repository, you can use the
following command:

> ⚠ Disclaimer: Use caution when using the OS Setup tool as it installs various
> dependencies and components other than just these dotfiles, and may overwrite
> or conflict with existing settings; for a manual installations look at the
> `install.d` folder as mentioned further down.

```bash
bash <(curl https://raw.githubusercontent.com/Nachtalb/os-setup/master/web-install.sh) --noconfirm
```

This command will automatically download and run the installation script,
skipping any confirmation prompts.

If you already have an existing installation and prefer a manual setup, you can
explore the files in the `install.d` folder of the
[OS Setup](https://github.com/Nachtalb/os-setup) repository. These files provide
step-by-step instructions and configuration details specific to each component
of the OS setup.

## Feature List

- 📋 `ccopy` and `cpaste` scripts for clipboard interaction (Linux, macOS,
  Windows/WSL).
- 🔄 `git tohttp [remote]` and `git tossh [remote]` for rewriting Git remotes.
- 📦 `install-pandoc` script for Pandoc dependencies and additional themes.
- 📄 `to-pdf` script for file to PDF conversion with Pandoc.
- 🔄 `update-neovim-nightly` for updating Neovim on Arch.
- 📤 `catbox [file]` and `litterbox [file]` for file uploads.
- 🗃️ `extract [file]` for extracting common archives.
- 🐙 `gh [user/repo]` and `gl [user/repo]` for cloning from GitHub and GitLab.
- ✨ `vim` wrapper for Neovim with Session.vim support.
- 🚀 Starship shell integration for customizable prompt.
- 🖥️ Full tmux config and plugins.
- 🔑 SSH, Git, and GnuPG configuration.
- 📦 Tools: Black, Mypy, Isort, XDG-Open, Ruff, Ruff-LSP.
- 🚀 Git abbreviations and aliases.
- 🚀 Shell aliases and abbreviations.
- 📚 Auto-setup of PATH for package managers.

## Other Projects

- [OS Setup](https://github.com/Nachtalb/os-setup): An installation script for
  new Arch setups as described above.
- [Git Open](https://github.com/Nachtalb/git-open-rs): A git-open command
  written in Rust, similar to paulirish/git-open.
- [VimConfig](https://github.com/Nachtalb/vimconfig): Neovim configuration with
  Vim-Plug and Coc.nvim support.
- [Licenses API](https://licenses.nachtalb.io/) |
  [GitHub Repository](https://github.com/Nachtalb/licenses_api): An API for
  retrieving software license information, including SPDX ID, permissions,
  conditions, and more.
- [Leeplate](https://leeplate.nachtalb.io/) |
  [GitHub Repository](https://github.com/Nachtalb/leeplate): A privacy-oriented
  alternative frontend for translation providers.
