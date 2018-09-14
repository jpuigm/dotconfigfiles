#!/bin/bash

REPOSITORY_DIR=/vagrant/src/github.com/jpuigm
REPOSITORY_NAME=dotconfigfiles
CONFIG_DIR=emacs_config

echo "Installing basic emacs configuration..."
ln -s $REPOSITORY_DIR/$REPOSITORY_NAME/$CONFIG_DIR $HOME/.emacs
echo "Done!"
echo ""
file $HOME/.emacs

