#!/bin/sh

# waybar
cp -r ~/dotfiles/waybar/* ~/.config/waybar/

# wofi
cp -r ~/dotfiles/wofi/* ~/.config/wofi/

# eww
# cp -r ~/dotfiles/eww/* ~/.config/eww/

# ignis
cp -r ~/dotfiles/ignis/* ~/.config/ignis

# hyprland
cp -r ~/dotfiles/hypr/* ~/.config/hypr/

# kitty
cp ~/dotfiles/kitty/mykitty.conf ~/.config/kitty/mykitty.conf

# nvim
cp -r ~/dotfiles/neovim ~/.config/neovim

# superfile
cp -r ~/dotfiles/superfile/* ~/.config/superfile/

# restart
pkill waybar 
waybar & disown
# ignis init
# pkill hyprpaper && hyprpaper & disown
