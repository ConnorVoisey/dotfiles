pacman -S --needed git

git clone https://github.com/ConnorVoisey/dotfiles.git $HOME/dotfiles

pacman -S --needed git base-devel yay

./download_packages.sh
stow .
