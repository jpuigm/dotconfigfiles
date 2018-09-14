# Configure emacs

## Getting started

To configure basic emacs configuration, simply run the script located under `install` directory.

```
$ install/install_emacs_config.sh
```

It does create a symbolic link from the home directory to this repository, loading `basic.el`. This file has the ability to load further confuguration files as needed (see `load-config-files`).

## Install additional packages

This emacs gets configure with a number of emacs package repositories. To launch the `package` mode,

```
M-x package-list-packages
```

## Git repositories

emacs provides a great tool to manage git repositories, `magit`. To install it, simply select it in the package manager. To lunch `magit` mode,

```
M-x magit
```
