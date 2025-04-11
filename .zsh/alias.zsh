# ~/.zsh/alias
source ~/.zsh/functions.zsh

## list ##
alias ls='eza --color=always --icons=always'
alias la='eza -a --icons=always'
alias ll='eza -l -a --icons=always --no-time'
alias lst='eza -T --level=2 --color=always --icons=always'
alias lsf='eza -f -a --color=always --icons=always'
alias lstd='eza -D -T --level=2 --color=always --icons=always'
alias tree='eza -T --level=3 --color=always --icons=always'

alias cat='bat --style header --style snip --style changes --style header'  # cat

alias grubup="sudo update-grub" # most other distros like Arch, Ubuntu
alias susegrub="sudo grub2-mkconfig -o /boot/grub2/grub.cfg"    # opensuse
alias fedbup="sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg" # fedora
alias ..='cd ..'    # go back
alias ...='cd ../..'    # go back 2 steps
alias .='cd /'  # go to root dir
alias cd='z'

# other
alias src='source ~/.zsh/.zshrc' #source .bashrc
alias clr='clear'   #clear
alias cls='clear'
alias clar='clear'
alias c='clear'
alias q='exit'

# disk spaces and RAM usage
alias du='du -sh'
alias mem='rsc __memory'
alias disk='rsc __disk'

#fzf
alias find='nvim $(fzf --preview="bat --color=always {}")'

#nvim
alias nv='nvim'
alias nvm='nvim .'
alias snv='sudo -E nvim -d'

# check updates

# updates
alias dup='sudo zypper dup -y' # distro update for opensuse

# git alias
alias add='git add .'
alias clone='git clone'
alias cloned='git clone --depth=1'
alias branch='git branch -M main'
alias commit='git commit -m'
alias push='git push'
alias pushm='git push -u origin main'
alias pusho='git push origin' # and add your branch name 
alias pull='git pull'
alias info='git_info'
alias status='git status'

# others
alias nc='clr && neofetch'
alias neofetch='clr && neofetch'
alias ff='clr && fastfetch'
alias sys='btop'
alias clock='tty-clock -c -t -D -s'

alias mkdir='mkdir -pv'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Alias for neovim
if [[ -x "$(command -v nvim)" ]]; then
	alias vi='nvim'
	alias vim='nvim'
	alias svi='sudo nvim'
	alias vis='nvim "+set si"'
elif [[ -x "$(command -v vim)" ]]; then
	alias vi='vim'
	alias svi='sudo vim'
	alias vis='vim "+set si"'
fi

# Alias to launch a document, file, or URL in it's default X application
if [[ -x "$(command -v xdg-open)" ]]; then
	alias open='runfree xdg-open'
fi

# Alias to launch a document, file, or URL in it's default PDF reader
if [[ -x "$(command -v evince)" ]]; then
    alias pdf='runfree evince'
fi

# Alias For bat
# Link: https://github.com/sharkdp/bat
if [[ -x "$(command -v bat)" ]]; then
    alias cat='bat'
fi

# Alias for lazygit
# Link: https://github.com/jesseduffield/lazygit
if [[ -x "$(command -v lazygit)" ]]; then
    alias lg='lazygit'
fi

# Alias for FZF
# Link: https://github.com/junegunn/fzf
if [[ -x "$(command -v fzf)" ]]; then
    alias fzf='fzf --preview "bat --style=numbers --color=always --line-range :500 {}"'
    # Alias to fuzzy find files in the current folder(s), preview them, and launch in an editor
	if [[ -x "$(command -v xdg-open)" ]]; then
		alias preview='open $(fzf --info=inline --query="${@}")'
	else
		alias preview='edit $(fzf --info=inline --query="${@}")'
	fi
fi

# Get local IP addresses
if [[ -x "$(command -v ip)" ]]; then
    alias iplocal="ip -br -c a"
else
    alias iplocal="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"
fi

# Get public IP addresses
if [[ -x "$(command -v curl)" ]]; then
    alias ipexternal="curl -s ifconfig.me && echo"
elif [[ -x "$(command -v wget)" ]]; then
    alias ipexternal="wget -qO- ifconfig.me && echo"
fi
# make executable script
alias exe='chmod +x'
