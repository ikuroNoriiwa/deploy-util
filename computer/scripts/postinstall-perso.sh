#!/bin/bash
apt update -y
apt upgrade -y

apt install -y curl

## Install package list
for package in `curl -sSl https://raw.githubusercontent.com/ikuroNoriiwa/personal_configurations/master/computer/to-install/perso.lst`
do
        apt install -y $package
done

## Instal vim plugins
if (( "$SUDO_USER" != "root" ))
then
curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

## Install Oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

## Copy personal config
### Vim
curl -sSl https://raw.githubusercontent.com/ikuroNoriiwa/personal_configurations/master/computer/app/vim/.vimrc -o $HOME/.vimrc
mkdir $HOME/.vimrc/colors -p
curl -sSl https://raw.githubusercontent.com/NLKNguyen/papercolor-theme/master/colors/PaperColor.vim -o $HOME/.vimrc/colors/PaperColor.vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

### ZSH
curl -sSl https://raw.githubusercontent.com/ikuroNoriiwa/personal_configurations/master/computer/shell/zsh/.zshrc -o $HOME/.zshrc
curl -sSl https://raw.githubusercontent.com/ikuroNoriiwa/personal_configurations/master/computer/shell/zsh/.zshrc.pre-oh-my-zsh -o $HOME/.zshrc.pre-oh-my-zsh
curl -sSl https://raw.githubusercontent.com/ikuroNoriiwa/personal_configurations/master/computer/aliases/.zsh.aliases -o $HOME/.zsh.aliases
