#!/bin/sh

if [ -e ~/.vim ];then
mv -f ~/.vim ~/.vim_old
fi
if [ -e ~/.vimrc ];then
mv -f ~/.vimrc ~/.vimrc_old
fi
ln -s `pwd` ~/.vim
ln -s `pwd`/vimrc ~/.vimrc 
