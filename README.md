<h1 align="center">Custom zsh by Shell Ninja</h1>

## Features

- Custom functions and alias
- Lightweight package manager `zinit`
- Better `ls` with `eza`
- Better `cd` with `zoxide`
- Better `cat` with `bat`
- Fuzzy finding with `fzf` and preview with `bat`
- Auto correct commands.
- Command mistake correction with `thefu*k`
- Minimal `powerlevel10k` theme
- Syntax highlighting
- Auto suggestions
- Autocd

### Note

By default, all the config files will be storred into a `.zsh` directory in your `$HOME` directory.

### Customization

If you want to customize it after the installation, just navigate to `~/.zsh` directory and open it with your prferred text editor. Now you will be able to make changes to your `.zshrc`, `.p10k.zsh` and other files.

### Supported Distros for the install script

The installation script is be able to install necessary packages with `pacman`, `dnf`, `zypper`, `apt` package managers. I'm not sure if it will work with `brew` in `MacOs`, yet I have added scripts for it.

## Installation

### Direct Installation

You can directly run the command bellow and it will automaticly clone the repository and install the config. Before that make sure you have `curl` installed in your system. If not, simply install it using `pacman`, `dnf`, `zypper` or `apt`.

- Run this command in your terminal:

```
bash <(curl https://raw.githubusercontent.com/shell-ninja/Zsh/main/direct_install.sh)
```

### Manual Installation

- Open terminal and run these commands.

```
git clone --depth=1 https://github.com/shell-ninja/Zsh.git

cd Zsh
chmod +x install.sh
./install.sh
```

## Edit alias & functions

Simply go to `~/.zsh` directory. Inside it, you will find `.zshrc`, `alias.zsh` and `functions.sh` and `functions.zsh` file. Just edit these files and you are good to go.

<br>

## Command Shortcuts

| Shortcut  | Command                                                                               | Description                                                                                              |
| --------- | ------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| `cu`      | `paru/yay -Qua / checkupdates`, `sudo dnf check-update` or `sudo zypper list-updates` | Checks system updates (Arch, Fedora, OpenSuse. Also prints both Official and Aur updates in Arch Linux). |
| `update`  | `paru/yay -Syyu`, `sudo dnf upgrade`, `sudo zypper update`, or `sudo apt-get update`  | Updates the system packages (Arch, Fedora, OpenSuse, Debian/Ubuntu).                                     |
| `install` | `paru/yay -S`, `sudo dnf install`, `sudo zypper install`, or `sudo apt-get install`   | Install package (Arch, Fedora, OpenSuse, Debian/Ubuntu).                                                 |
| `remove`  | `paru/yay -Rns`, `sduo dnf remove`, `sudo zypper remove`, or `sudo apt-get remove`    | Uninstall package (Arch, Fedora, OpenSuse, Debian/Ubuntu).                                               |
| `add`     | `git add .`                                                                           | Add.                                                                                                     |
| `clone`   | `git clone`                                                                           | Clone a repository.                                                                                      |
| `cloned`  | `git clone --depth=1`                                                                 | Clone a repository with depth 1.                                                                         |
| `commit`  | `git commit -m`                                                                       | Commit with a message.                                                                                   |
| `push`    | `git push`                                                                            | Push changes to the remote repository.                                                                   |
| `pushm`   | `git push -u origin main`                                                             | Push changes and set upstream to main.                                                                   |
| `pusho`   | `git push origin [branch]`                                                            | Push to a specified branch.                                                                              |
| `pull`    | `git pull origin [branch]`                                                            | Pull from a specified branch.                                                                            |
| `info`    | `git info`                                                                            | Git Information.                                                                                         |
| `gpush`   | `binding of some commands`                                                            | Binding of `git add .`, `git commit -m "commit msg"`, `git push`                                         |
