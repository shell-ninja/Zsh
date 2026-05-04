# ~/.zsh/functions.sh
#
# copy and paste Function
function cpy() {
  # Get the last argument as the destination
  local destination="${@[-1]}/"

  # Check if the destination exists and is a directory
  if [[ ! -d "$destination" ]]; then
    # If not, create it
    mkdir -p "$destination"
  fi

  # Get all arguments except the last one (items to copy)
  local items=("${@:1:$#-1}")

  # Iterate through the items and copy them
  for item in "${items[@]}"; do
    if [[ -f "$item" ]]; then
      printf ":: Copying a file: %s\n" "$item"
      cp "$item" "$destination"
    elif [[ -d "$item" ]]; then
      printf ":: Copying a directory: %s\n" "$item"
      cp -r "$item" "$destination"
    else
      printf ":: Skipping: %s (not found or invalid)\n" "$item"
    fi
  done
}

# remove files and directories
function rmv() {
    for item in "$@"; do
        if [[ -f "$item" ]]; then
            printf ":: Removing a file\n"
            rm "$item"
        elif [[ -d "$item" ]]; then
            printf ":: Removing a directory\n"
            rm -rf "$item"
        else
            printf "[ !! ]\n$item does not exist or is neither a regular file nor a directory\n"
        fi
    done
}

# disk spaces
function rsc(){
    case $1 in
        __disk)
            disk_total=$(df / -h | awk 'NR==2 {print $2}')
            disk_used=$(df / -h | awk 'NR==2 {print $3}')
            disk_free=$(df / -h | awk 'NR==2 {print $4}')
            printf "Total: $disk_total\nUsed: $disk_used\nFree: $disk_free\n"
            ;;
        __memory)
            mem_total=$(free -h | awk 'NR==2 {print $2}')
            mem_used=$(free -h | awk 'NR==2 {print $3}')
            mem_free=$(free -h | awk 'NR==2 {print $7}')
            printf "Total: $mem_total\nUsed: $mem_used\nFree: $mem_free\n"
            ;;
    esac
}

# check updates
function cu() {
    if command -v pacman >/dev/null 2>&1; then  # Arch Linux
        # Check for updates
        local aur=0
        if command -v yay >/dev/null 2>&1; then
            aur=$(yay -Qua 2>/dev/null | wc -l)
        elif command -v paru >/dev/null 2>&1; then
            aur=$(paru -Qua 2>/dev/null | wc -l)
        fi
        
        local ofc=0
        if command -v checkupdates >/dev/null 2>&1; then
            ofc=$(checkupdates 2>/dev/null | wc -l)
        fi

        # Calculate total available updates
        local upd=$(( ofc + aur ))
        printf "[ UPDATES ]\n:: You have \e[1;32m%d\e[0m updates available.\n:: Main: %d\n:: Aur: %d\n" "$upd" "$ofc" "$aur"
    
    elif command -v dnf >/dev/null 2>&1; then  # Fedora
        local upd=$(dnf check-update -q | wc -l)
        printf "[ UPDATES ]\n:: You have \e[1;32m%d\e[0m updates available\n" "$upd"

    elif command -v zypper >/dev/null 2>&1; then  # openSUSE
        local upd=$(zypper lu --best-effort | grep -c 'v  |')
        printf "[ UPDATES ]\n:: You have \e[1;32m%d\e[0m updates available\n" "$upd"

    elif command -v apt >/dev/null 2>&1; then   # debian/ubuntu
        local upd=$(apt list --upgradable 2> /dev/null | grep -c '\[upgradable from')
        printf "[ UPDATES ]\n:: You have \e[1;32m%d\e[0m updates available\n" "$upd"

    else
        printf "\e[1;31m Unsupported package manager for now, please let us know in the github repository...\e[1;0m \n https://github.com/me-js-bro/Bash\n"
        return 1
    fi
}

# package updates
function update() {
    if command -v pacman >/dev/null 2>&1; then  # Arch Linux
        if command -v yay >/dev/null 2>&1; then
            yay -Syyu --noconfirm
        elif command -v paru >/dev/null 2>&1; then
            paru -Syyu --noconfirm
        else
            sudo pacman -Syyu --noconfirm
        fi
    elif command -v dnf >/dev/null 2>&1; then  # Fedora
        sudo dnf update -y && sudo dnf upgrade -y --refresh
    elif command -v zypper >/dev/null 2>&1; then  # openSUSE
        sudo zypper ref && sudo zypper up -y
    elif command -v apt >/dev/null 2>&1; then  # Debian/Ubuntu
        sudo apt update -y && sudo apt upgrade -y
    else
        printf "\e[1;31m Unsupported package manager for now, please let us know in the github repository...\e[1;0m \n https://github.com/me-js-bro/Bash\n"
        return 1
    fi
}

# Install software
function install() {
    if command -v pacman >/dev/null 2>&1; then  # Arch Linux
        if command -v yay >/dev/null 2>&1; then
            yay -S --noconfirm "$@"
        elif command -v paru >/dev/null 2>&1; then
            paru -S --noconfirm "$@"
        else
            sudo pacman -S --noconfirm "$@"
        fi
    elif command -v dnf >/dev/null 2>&1; then  # Fedora
        sudo dnf install -y "$@"
    elif command -v zypper >/dev/null 2>&1; then  # openSUSE
        sudo zypper in -y "$@"
    elif command -v apt >/dev/null 2>&1; then  # Ubuntu or Ubuntu-based
        sudo apt install -y "$@"
    else
        printf "\e[1;31m Unsupported package manager for now, please let us know in the GitHub repository...\e[1;0m \n https://github.com/me-js-bro/Bash\n"
        return 1
    fi
}

# package remove
function remove() {
    if command -v pacman >/dev/null 2>&1; then  # Arch Linux
        if command -v yay >/dev/null 2>&1; then
            yay -Rns "$@"
        elif command -v paru >/dev/null 2>&1; then
            paru -Rns "$@"
        else
            sudo pacman -Rns "$@"
        fi
    elif command -v dnf >/dev/null 2>&1; then  # Fedora
        sudo dnf remove "$@"
    elif command -v zypper >/dev/null 2>&1; then  # openSUSE
        sudo zypper rm "$@"
    elif command -v apt >/dev/null 2>&1; then  # ubunt or related
        sudo apt remove "$@"
    else
        printf "\e[1;31m Unsupported package manager for now, please let us know in the github repository...\e[1;0m \n https://github.com/me-js-bro/Bash\n"
        return 1
    fi
}

# compile cpp file with gcc
function cpp() {
    local filename="${1%.cpp}"
    if command -v g++ >/dev/null 2>&1; then
        printf "\e[0;36m[ * ] - Compiling...!\e[0m\n\n"

        if g++ -std=c++20 "$filename.cpp" -o "$filename"; then
            printf "\e[1;92m[ ✓ ] - Successfully compiled your code...!\e[0m\n"
            if [[ "$2" == "-o" ]]; then
                printf "\e[1;92m        Output: \e[0m\n\n" 
                ./"$filename"
            fi
        else
            printf "\n\e[1;91m[  ] - Error: Could not compile your code...!\e[0m\n"
        fi
    fi
}

# Prints random height bars across the width of the screen
# (great with lolcat application on new terminal windows)
function random_bars() {
	columns=$(tput cols)
	chars=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)
	for ((i = 1; i <= $columns; i++))
	do
		echo -n "${chars[RANDOM%${#chars} + 1]}"
	done
	echo
}

# y shell wrapper that provides the ability to change the current working directory when exiting Yazi.
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}


# fn to push git commits easily
function gpush() {

    # Push function
    __push() {
        local current="$1"
        local commit="$2"
        if [[ "$current" == "main" ]]; then
            git add .
            git commit -m "$commit"
            git push
        else
            git add .
            git commit -m "$commit"
            git push origin "$current"
        fi
    }

    # Check if current directory is a Git repository
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        # Get the current branch name
        branch_name=$(git branch --show-current 2>/dev/null)

        # Count untracked files
        untracked_count=$(git status --porcelain | grep '^??' | wc -l)

        # Count unstaged changes (modified but not staged)
        unstaged_count=$(git diff --name-only | wc -l)

        # Count staged changes (staged but not committed)
        staged_count=$(git diff --cached --name-only | wc -l)

        # Display information
        if [[ -n "$branch_name" ]]; then
            if [[ "$untracked_count" -gt 0 ]]; then
                printf "=> %s untracked files\n" "$untracked_count"
            fi

            if [[ "$unstaged_count" -gt 0 ]]; then
                printf "=> %s uncommitted changes\n" "$unstaged_count"
            fi

            if [[ "$staged_count" -gt 0 ]]; then
                printf "=> %s staged changes\n" "$staged_count"
            fi

            if [[ "$untracked_count" -eq 0 && "$unstaged_count" -eq 0 && "$staged_count" -eq 0 ]]; then
                printf "✓ Nothing to push.\n"
            else
                printf "=> %s branch\n" "$branch_name"
                printf "\nWrite the commit message\n=> "
                read -r msg
                sleep 0.5 && echo

                if command -v gum &> /dev/null; then
                    gum spin --spinner dot \
                        --title "Pushing to branch: $branch_name" -- \
                        sleep 2
                    __push "$branch_name" "$msg" &> /dev/null
                else
                    printf "Pushing to branch: %s\n" "$branch_name"
                    __push "$branch_name" "$msg" &> /dev/null
                fi

                sleep 1

                # Check the result of the last command
                if [[ "$untracked_count" -eq 0 || "$unstaged_count" -eq 0 || "$staged_count" -eq 0 ]]; then
                    printf ":: Pushed successfully!\n"
                else
                    printf "!! Sorry, push failed. Please check for errors.\n"
                fi
            fi
        fi
    else
        printf "!! Not inside a Git repository.\n"
    fi
}

# fastfetch style
function ffstyle() {
    preferredDir="$HOME/.local/share/fastfetch/presets"

    if [[ ! -d "$preferredDir" ]]; then
        echo "Preset directory not found."
        return 1
    fi

    presets=()
    for preset in "$preferredDir"/*.jsonc(N); do
        presets+=("${preset##*/}")
    done

    # Strip .jsonc extension
    for ((i=1; i<=${#presets[@]}; i++)); do
        presets[i]=${presets[i]%.jsonc}
    done

    echo "-> Choose Fastfetch style you want"

    for ((i=1; i<=${#presets[@]}; i++)); do
        echo "$i. ${presets[i]}"
    done

    echo -n "Select: "
    read stl

    if [[ "$stl" -ge 1 && "$stl" -le ${#presets[@]} ]]; then
        __selected="${presets[stl]}"
        echo "Setting $__selected as fastfetch style..."
        sed -i "s|ffconfig=.*$|ffconfig=$__selected|g" "$HOME/.zsh/.zshrc"
    else
        echo "Invalid selection."
    fi
}

function ffimg() {
    local preferredDir="$HOME/.local/share/fastfetch/images"

    if [[ ! -d "$preferredDir" ]]; then
        echo "Image directory not found: $preferredDir"
        return 1
    fi

    [[ -n "$ffconfig" ]] || source "$HOME/.zshrc"

    if [[ "$ffconfig" != "minimal" ]]; then
        echo "minimal style is not selected."
        return 0
    fi

    local -a presets=()
    local preset
    for preset in "$preferredDir"/*; do
        [[ -f "$preset" ]] || continue
        presets+=("${preset:t}")  # :t gets the tail (filename) in zsh
    done

    if (( ${#presets[@]} == 0 )); then
        echo "No images found in $preferredDir"
        return 1
    fi

    echo "-> Choose Fastfetch image you want:"
    local i=1
    local prst
    for prst in "${presets[@]}"; do
        echo "$i. $prst"
        ((i++))
    done

    echo -n "Select (1-${#presets[@]}): "
    read stl

    if ! [[ "$stl" =~ '^[0-9]+$' ]]; then
        echo "Invalid input. Please enter a number."
        return 1
    fi

    if (( stl >= 1 && stl <= ${#presets[@]} )); then
        local __selected="${presets[$((stl))]}"
        echo "Setting $__selected as fastfetch image..."

        # Escape path for sed
        local escaped_path
        escaped_path="${__selected//\//\\/}"  # Escape forward slashes

        # Replace in JSONC (preserve trailing characters like ",)
        sed -i -E "s|(fastfetch/images/)[^\"/]+|\1$escaped_path|" "$HOME/.local/share/fastfetch/presets/minimal.jsonc"
    else
        echo "Invalid selection."
        return 1
    fi
}

function ss() {
    if command -v yay >/dev/null 2>&1; then 
        yay -Slq | fzf --multi --preview 'yay -Sii {1}' --preview-window=down:75% | xargs -ro yay -S --noconfirm
    elif command -v paru >/dev/null 2>&1; then 
        paru -Slq | fzf --multi --preview 'paru -Sii {1}' --preview-window=down:75% | xargs -ro paru -S --noconfirm
    else
        local pkg=""
        if command -v apt >/dev/null 2>&1; then pkg="apt"
        elif command -v dnf >/dev/null 2>&1; then pkg="dnf"
        elif command -v zypper >/dev/null 2>&1; then pkg="zypper"
        fi

        if [[ -z "$pkg" ]]; then
            echo "Unsupported package manager."
            return 1
        fi

        if [[ -z "$1" ]]; then
            echo -e "Please add your package name."
            echo -e "Usage: ss <package_name>"
            return 1
        else
            $pkg search "$1"
        fi
    fi
}
