#!/usr/bin/env bash

sudo apt install python3-pylsp gopls clangd rust-analyzer -y

cp init.el nano -rv ~/.emacs.d/ 
