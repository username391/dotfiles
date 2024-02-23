# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export HISTFILE=$HOME/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000

setopt hist_ignore_all_dups
setopt hist_ignore_space

# autocd
setopt auto_cd

# theme
# source "$HOME/.zsh/themes/robbyrussell.zsh-theme"
source "$HOME/.zsh/themes/powerlevel10k/prompt_powerlevel9k_setup"
[[ ! -f ~/.config/.p10k.zsh ]] || source ~/.config/.p10k.zsh

# zsh plugins that i used, but turned off
# git, archlinux, copypath, copyfile, copybuffer, dirhistory, jsontools

# source $ZSH/oh-my-zsh.sh

# plugins
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.zsh/zsh-dirhistory/dirhistory.plugin.zsh
source $HOME/.zsh/zsh-json-tools/jsontools.plugin.zsh


# User configuration

# NNN
export NNN_FIFO=/tmp/nnn.fifo
export NNN_PLUG='p:preview-tui'
export NNN_TERMINAL='alacritty --title preview-tui'

n () {
	# block this in nnn subshell
	if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
		echo "nnn is already running"
		return
	fi

	export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

	nnn -d "$@"

	if [ -f "$NNN_TMPFILE" ]; then
		. "$NNN_TMPFILE"
		rm -f "$$NNN_TMPFILE"
	fi
}


# copypath from copypath plugin
function copypath {
	# If no argument passed, use current directory
	local file="${1:-.}"

	# If argument is not an absolute path, prepend $PWD
	[[ $file = /* ]] || file="$PWD/$file"

	# Copy the absolute path without resolving symlinks
	# If clipcopy fails, exit the function with an error
	print -n "${file:a}" | clipcopy || return 1

	echo ${(%):-"%B${file:a}%b copied to clipboard."}
}

# copyfile from copyfile plugin
function copyfile {
	emulate -L zsh
	clipcopy $1

	local file="${1:-.}"
	[[ $file = /* ]] || file="$PWD/$file"
	print -n "${file:a}" | clipcopy || return 1
	echo ${(%):-"%B${file:a}%b content copied to clipboard."}
}


# copybuffer from copybuffer plugin
copybuffer () {
  if which clipcopy &>/dev/null; then
    printf "%s" "$BUFFER" | clipcopy
  else
    zle -M "clipcopy not found. Please make sure you have Oh My Zsh installed correctly."
  fi
}


zle -N copybuffer

bindkey -M emacs "^O" copybuffer
bindkey -M viins "^O" copybuffer
bindkey -M vicmd "^O" copybuffer

# other aliases
alias vim="nvim"
alias cb="xclip -selection clipboard"

# exa aliases
alias ls="exa --long --icons --group-directories-first"
alias la="exa --long --tree --icons --group-directories-first"

# git aliases
alias grv="git remote -v"
alias gs="git status"
alias gd="git diff"

# pacman
alias pacmanclean="sudo pacman -Rs $(pacman -Qtdq)"
alias cleancache="sudo pacman -Scc"

# yay
alias yaclean="yay -Scc"
alias yaupg="yay -Syyu --noconfirm"

# history
alias history='history 1 -1'
alias h='history'
alias hg='history | grep'
alias hgi='history | grep -i'

# bluetooth
alias blc='bluetoothctl connect'
alias bld='bluetoothctl disconnect'

# cp command
alias cp='rsync -aP'

# some variables
export HP_ID='18:B9:6E:01:7C:53'

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey '^H' backward-kill-word
bindkey '5~' kill-word

# z and zi for zoxide
eval "$(zoxide init --cmd cd zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


