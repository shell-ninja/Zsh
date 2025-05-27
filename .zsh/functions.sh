# fn to push git commits easily
gpush() {

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
ffstyle() {
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

ffimg() {
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
