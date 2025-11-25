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

# swaync
cp -r ~/dotfiles/swaync/* ~/.config/swaync/

# restart
pkill waybar 
waybar & disown

swaync-client -R -rs & notify-send -i ~/.config/swaync/icons/image.png "UI reload complete"

