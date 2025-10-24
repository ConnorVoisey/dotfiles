dnf repoquery --userinstalled --qf "%{name}\n" > $HOME/dotfiles/pkglist.txt

echo "Successfully wrote package list to $HOME/dotfiles/pkglist.txt"
