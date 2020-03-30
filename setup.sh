#/usr/bin/env bash

echo ":: Updating..."
sudo apt update

echo ":: Installing stuff..."
sudo apt install -y curl git tmux zsh stack ruby-dev lua5.2-dev libncurses5-dev python3-dev python3 python3-venv python3-pip vim-nox

echo ":: Cleaning up..."
sudo apt -y autoremove

echo ":: Files of dot and other configs"

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/anobi/vim
git clone https://github.com/anobi/dotfiles
git clone https://github.com/powerline/fonts

./fonts/install.sh
rm -R fonts

ln -s dotfiles/tmux/.tmux.conf ~/

echo ":: Vim"
mv vim .vim 2>&1 >/dev/null
ln -s .vim/.vimrc ~/.vimrc
git clone https://github.com/VundleVim/vundle.vim ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall 2>&1 >/dev/null

echo ":: DONE!"
