#!/bin/bash

#=============================================================================================
# ███████╗██╗  ██╗███████╗██╗     ██╗          ███╗   ██╗██╗███╗   ██╗     ██╗ █████╗ 
# ██╔════╝██║  ██║██╔════╝██║     ██║          ████╗  ██║██║████╗  ██║     ██║██╔══██╗
# ███████╗███████║█████╗  ██║     ██║          ██╔██╗ ██║██║██╔██╗ ██║     ██║███████║
# ╚════██║██╔══██║██╔══╝  ██║     ██║          ██║╚██╗██║██║██║╚██╗██║██   ██║██╔══██║
# ███████║██║  ██║███████╗███████╗███████╗     ██║ ╚████║██║██║ ╚████║╚█████╔╝██║  ██║
# ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝     ╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚════╝ ╚═╝  ╚═╝
#=============================================================================================

# --- Color Definitions ---
RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
BLUE="\e[1;34m"
MAGENTA="\e[1;35m"
CYAN="\e[1;36m"
ORANGE="\e[38;5;214m" # 256-color standard for orange
NC="\e[0m" # No Color

# --- Variables ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
LOG_FILE="$SCRIPT_DIR/zsh-install-$(date +%I:%M_%p).log"
BACKUP_DIR="$HOME/.zsh-Backup-$USER"

# --- Message Function ---
msg() {
    local type=$1
    local text=$2

    case "$type" in
        act) echo -e "${GREEN}=>${NC} $text" ;;
        att) echo -e "${YELLOW}!!${NC} $text" ;;
        ask) echo -e "${ORANGE}??${NC} $text" ;;
        dn)  echo -e "${CYAN}::${NC} $text\n" ;;
        skp) echo -e "${MAGENTA}[ SKIP ]${NC} $text" ;;
        err) echo -e "${RED}>< Ohh no! an error...${NC}\n   $text\n" ;;
    esac
}

# --- Initialize Log ---
touch "$LOG_FILE"
msg act "Log file created at: $LOG_FILE"

# --- Packages Lists ---
COMMON_PACKAGES=(bat curl eza fastfetch figlet fzf git rsync starship zoxide zsh)
OPENSUSE_PACKAGES=(python311 python311-pip python311-pipx xclip)

# --- OS Detection ---
msg act "Detecting Operating System..."
if command -v pacman &> /dev/null; then
    OS="arch"
elif command -v dnf &> /dev/null; then
    OS="fedora"
elif command -v zypper &> /dev/null; then
    OS="opensuse"
elif command -v apt &> /dev/null; then
    OS="debian"
elif [[ "$(uname)" == "Darwin" ]] && command -v brew &> /dev/null; then
    OS="macos"
elif [[ "$(uname)" == "Darwin" ]]; then
    msg err "Homebrew is not installed. Install it from https://brew.sh/ first."
    exit 1
else
    msg err "Unsupported OS or Package Manager."
    exit 1
fi
msg dn "Detected: $OS"

# --- Bulk Installation Function ---
install_packages() {
    local pkgs=("$@")
    msg act "Installing packages: ${pkgs[*]}..."

    case "$OS" in
        arch)
            sudo pacman -S --needed --noconfirm "${pkgs[@]}" 2>&1 | tee -a "$LOG_FILE"
            ;;
        fedora)
            sudo dnf install -y "${pkgs[@]}" 2>&1 | tee -a "$LOG_FILE"
            ;;
        opensuse)
            sudo zypper in -y "${pkgs[@]}" 2>&1 | tee -a "$LOG_FILE"
            ;;
        debian)
            sudo apt update 2>&1 | tee -a "$LOG_FILE"
            sudo apt install -y "${pkgs[@]}" 2>&1 | tee -a "$LOG_FILE"
            ;;
        macos)
            brew install "${pkgs[@]}" 2>&1 | tee -a "$LOG_FILE"
            ;;
    esac
    msg dn "Package installation phase completed."
}

# --- Run Main Installations ---
install_packages "${COMMON_PACKAGES[@]}"

if [[ "$OS" == "opensuse" ]]; then
    install_packages "${OPENSUSE_PACKAGES[@]}"
    
    # Installing thefuck via pipx
    if command -v pipx &> /dev/null; then
        msg act "Installing 'thefuck' via pipx..."
        pipx install --python python3.11 thefuck 2>&1 | tee -a "$LOG_FILE"
        msg dn "thefuck was installed successfully!"
    fi
else
    install_packages "thefuck"
fi

# --- Change Default Shell ---
if [[ "$SHELL" != *"zsh"* ]]; then
    msg act "Changing default shell to zsh..."
    chsh -s "$(command -v zsh)"
    msg dn "Shell changed. (You may need to log out and back in for this to take effect)."
else
    msg skp "zsh is already the default shell."
fi

sleep 1
msg act "Proceeding to configure ZSH environment..."

# --- Backup Existing Configs ---
mkdir -p "$BACKUP_DIR"
for item in "$HOME/.zsh" "$HOME/.zshrc"; do
    if [[ -e $item ]]; then
        msg att "Found existing $(basename "$item"), backing it up to $BACKUP_DIR"
        mv "$item" "$BACKUP_DIR/"
    fi
done

sleep 1

# --- Copy New Configs ---
msg act "Copying new configurations..."

if [[ -d "$SCRIPT_DIR/.zsh" ]]; then
    cp -r "$SCRIPT_DIR/.zsh" "$HOME/"
    ln -sf "$HOME/.zsh/.zshrc" "$HOME/.zshrc"
    msg dn "Installation and configuration of ZSH finished!"
else
    msg err "Could not find .zsh directory in $SCRIPT_DIR. Config copy failed."
fi

exit 0
