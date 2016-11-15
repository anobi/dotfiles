#/usr/bin/env bash

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 575159689BEFB442
echo 'deb http://download.fpcomplete.com/debian jessie main'|sudo tee /etc/apt/sources.list.d/fpco.list

echo ":: Updating..."
sudo apt-get update

echo ":: Installing stuff..."
sudo apt-get install -y build-essential git tmux zsh stack ruby-dev lua5.2-dev libncurses5-dev python3-dev python3 python3-venv python3-pip vim-nox

echo ":: Cleaning up..."
sudo apt-get -y autoremove

echo ":: Files of dot and other configs"

wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh 
chsh -s /bin/zsh vagrant

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
