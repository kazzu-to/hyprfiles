if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting ""

if not contains $HOME/.local/bin $PATH
    set -gx PATH $HOME/.local/bin $PATH
end

set -x XDG_DESKTOP_DIR $HOME/Desktop
set -x XDG_DOWNLOAD_DIR $HOME/Downloads
set -x XDG_PICTURES_DIR $HOME/Pictures
set -x XDG_DOCUMENTS_DIR $HOME/Documents
set -x XDG_VIDEOS_DIR $HOME/Videos
	


############
alias hyprconf="nvim $HOME/.config/hypr/hyprland.conf"
alias pac="sudo pacman -S"
alias paru="paru --skipreview" 
alias rns="sudo pacman -Rns"
alias bin="cd $HOME/.local/bin"
alias conf="cd $HOME/.config"
alias hypr="cd $HOME/.config/hypr/"
alias grep='rg'
###########
abbr  --add gst "git status"

##########
fastfetch
