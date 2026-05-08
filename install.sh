#!/usr/bin/env bash

sudo apt install python3-pylsp gopls clangd rust-analyzer nodejs libperl-languageserver-perl -y

corepack enable yarn

yarn global add @vtsls/language-server

cp init.el nano -rv ~/.emacs.d/ 
