#!/bin/bash

#==============================================================================

# ███████╗██╗  ██╗███████╗██╗         ███╗   ██╗██╗███╗   ██╗     ██╗ █████╗ 
# ██╔════╝██║  ██║██╔════╝██║         ████╗  ██║██║████╗  ██║     ██║██╔══██╗
# ███████╗███████║█████╗  ██║         ██╔██╗ ██║██║██╔██╗ ██║     ██║███████║
# ╚════██║██╔══██║██╔══╝  ██║         ██║╚██╗██║██║██║╚██╗██║██   ██║██╔══██║
# ███████║██║  ██║███████╗███████╗    ██║ ╚████║██║██║ ╚████║╚█████╔╝██║  ██║
# ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝    ╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚════╝ ╚═╝  ╚═╝
                                                                            
#==============================================================================

# color defination
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
megenta="\e[1;1;35m"
cyan="\e[1;36m"
end="\e[1;0m"

# prompt function
msg() {
    local actn=$1
    local msg=$2

    case "$actn" in
        act)
            echo -e "${green}=>${end} $msg"
            ;;
        att)
            echo -e "${yellow}!!${end} $msg"
            ;;
        ask)
            echo -e "${orange}??${end} $msg"
            ;;
        dn)
            echo -e "${cyan}::${end} $msg\n"
            ;;
        skp)
            echo -e "${magenta}[ SKIP ]${end} $msg"
            ;;
        err)
            echo -e "${red}>< Ohh no! an error...${end}\n   $msg\n"
            ;;
    esac
}

# log file
dir=`pwd`
log="$dir/zsh-install-$(date +%I:%M_%p).log"
touch "$log"

# required packages
common_packages=(
    bat
    curl
    eza
    fastfetch
    figlet
    fzf
    git
    rsync
    zoxide
    zsh
)

for_opensuse=(
    python311
    python311-pip
    python311-pipx
    xclip
)

# package installation function
fn_install() {
    local pkg=$1

    if [ -n "$(command -v pacman)" ]; then  # Arch Linux
        if sudo pacman -Q "$pkg" &> /dev/null; then
            msg skp "Skipping $pkg, it was already installed..."
        else
            msg act "Installing $pkg..."
            sudo pacman -S --noconfirm "$pkg" 2>&1 | tee -a "$log" &> /dev/null
            if sudo pacman -Q "$pkg" &> /dev/null; then
                msg dn "$pkg was installed successfully!"
            else
                msg err "Could not install $pkg"
            fi
        fi
    elif [ -n "$(command -v dnf)" ]; then  # Fedora
        if rpm -q "$pkg" &> /dev/null; then
            msg skp "Skipping $pkg, it was already installed..."
        else
            msg act "Installing $pkg..."
            sudo dnf install -y "$pkg" 2>&1 | tee -a "$log"
            if rpm -q "$pkg" &> /dev/null; then
                msg dn "$pkg was installed successfully!"
            else
                msg err "Could not install $pkg"
            fi
        fi
    elif [ -n "$(command -v zypper)" ]; then # opensuse
        if sudo zypper se -i "$pkg" &> /dev/null; then
            msg skp "Skipping $pkg, it was already installed..."
        else
            msg act "Installing $pkg..."
            sudo zypper in -y "$pkg" 2>&1 | tee -a "$log"
            if sudo zypper se -i "$pkg" &> /dev/null; then
                msg dn "$pkg was installed successfully!"
            else
                msg err "Could not install $pkg"
            fi
        fi
    elif [ -n "$(command -v apt)" ]; then	# debian
        sudo apt install -y "$pkg" 2>&1 | tee -a "$log"
    else
         if [[ "$(uname)" == "Darwin" ]]; then
            echo "Running on macOS..."
            if [ -n "$(command -v brew)" ]; then
                brew install "$pkg" 2>&1 | tee -a "$log"
            elif [ -z "$(command -v brew)" ]; then
                echo "Homebrew is not installed. Install it from https://brew.sh/ before running this script."
                exit 1
            fi
        fi
   fi
}

# install the packages
for pkgs in "${common_packages[@]}"; do
   fn_install "$pkgs" 2>&1 | tee -a "$log"
done

if command -v zypper &> /dev/null; then
    for pkgs in "${for_opensuse[@]}"; do
        sudo zypper in -y "$pkgs" 2>&1 | tee -a "$log"
    done

    # installing thefu*k
    if command -v pipx &> /dev/null; then
        pipx runpip thefuck install setuptools &> /dev/null
        sleep 0.5
        pipx install --python python3.11 thefuck &> /dev/null 2>&1 | tee -a "$log"

        if command -v thefuck &> /dev/null; then
            printf "${cyan}::${end} thef*ck was installed successfully!\n" && sleep 1
        fi
    fi

elif command -v pacman &> /dev/null; then  # Arch Linux
    fn_install thefuck 2>&1 | tee -a "$log"
elif command -v dnf &> /dev/null; then  # Fedora
    fn_install thefuck 2>&1 | tee -a "$log"
elif command -v brew &> /dev/null; then
    brew install thefuck 2>&1 | tee -a "$log"
fi

printf "${cyan}::${end} Installation completed, now changing default shell to ${green}zsh${end} \n"
chsh -s $(which zsh)
sleep 1

printf "${action}=>${end} Now proceeding to the next step. Configuring $HOME/.zshrc file\n"
sleep 2

# Check and backup the directories and file
mkdir -p "$HOME/.zsh-Backup"-${USER}
for item in "$HOME/.zsh" "$HOME/.zshrc" "$HOME/.p10k.zsh"; do
    if [[ -d $item ]]; then
        case $item in
            $HOME/.zsh)
                printf "${green}!!${end} A ${green}.zsh${end} directory is available, backing it up\n" 
                mv "$item" "$HOME/.zsh-Backup"-${USER}/
                ;;
        esac
    elif [[ -f $item ]]; then
        case $item in
            $HOME/.zshrc)
                printf "${green}!!${end} A ${green}.zshrc${end} file is available, backing it up\n" 
                mv "$item" "$HOME/.zsh-Backup"-${USER}/
                ;;
            $HOME/.p10k.zsh)
                printf "${green}!!${end} A ${green}.zshrc${end} file is available, backing it up\n" 
                mv "$item" "$HOME/.zsh-Backup"-${USER}/
                ;;
        esac
    fi
done

sleep 1

printf "${green}=>${end} Copying configs\n"
sleep 1
cp -r "$HOME/.cache/Zsh/.zsh" ~/
ln -sf "$HOME/.zsh/.zshrc" "$HOME/.zshrc"

printf "${cyan}::${end} Installation and configuration of zsh finished!\n"
sleep 1
exit 0
