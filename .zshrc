# transient prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Устанавливаем директорию для zinit и плагинов
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Проверяем, скачан ли Zinit, если нет - скачиваем
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git --depth=1 "$ZINIT_HOME"
fi

# Запускаем Zinit
source "${ZINIT_HOME}/zinit.zsh"

# powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Пути
export GOPATH=$HOME/go/
PATH=$PATH:~/.local/bin

# Плагины
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# эти сниппеты требуют наличия clipcopy, не знаю, из какого это пакета
# zinit snippet OMZP::copybuffer
# zinit snippet OMZP::copypath
# zinit snipper OMZP::copyfile

# Load completions
autoload -U compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# Комбинации клавиш

# Искать в истории по текущему вводу (назад/вперед)
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward


# История команд
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt autocd


# Настройки автодополнения
# не учитывать регистр
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# что-то с цветами, не разобрался, просто скопировал
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# так как выше меню автодополнения заменено на fzf tab отключаем стандартное меню автодополнения
zstyle ':completion:*' menu no
# показывать превью
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa --long --icons --group-directories-first $realpath'
# для zoxide
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'exa --long --icons --group-directories-first $realpath'



# Другие алиасы
alias vim='nvim'
alias cb='xclip -selection clipboard'

# На убунту exa замещена eza
alias exa='eza'
alias ls="exa --long --icons --group-directories-first"
alias la="exa --long --tree --icons --group-directories-first"

alias grv="git remote -v"
alias gs="git status"
alias gd="git diff"

# Shell integrations
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# pacman
# alias pacmanclean="sudo pacman -Rs $(pacman -Qtdq)"
# alias cleancache="sudo pacman -Scc"

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

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey '^H' backward-kill-word
bindkey '5~' kill-word

# aliases for ubuntu
if [[ -f /etc/os-release ]]; then
	source /etc/os-release
	if [[ $ID == 'ubuntu' ]]; then
		alias python='python3'
		alias pip='pip3'
		alias ipython='ipython3'
	fi
fi

# Временный алиас для wsl
alias desktop='cd /mnt/c/Users/я/Desktop'


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

