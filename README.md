# dotconfigfiles

Repository hosting my personal config files.

## Configure emacs

### Getting started

To setup the basic emacs configuration, simply run the script located under `install` directory.

```
$ install/install_emacs_config
```

It does create a symbolic link from the home directory to this repository, loading `basic.el`. This file has the ability to load further confuguration files as needed (see `load-config-files`).

### Install additional packages

This emacs gets configure with a number of emacs package repositories. To launch the `package` mode,

```
M-x package-list-packages
```

Recommended packages:
- `markdown-mode`
- `magit`

### Git repositories

emacs provides a great tool to manage git repositories, `magit`. To install it, simply select it in the package manager. To launch `magit` mode,

```
M-x magit
```

## Configure tmux

### Getting started

To setup tmux configuration, simpy run the script located under `install` directory.

```
$ install/install_tmux.config
```

It does create a symbolic link from the home directory to this repository, loading `tmux.conf`. This file contains two references:

#### Battery-powered computers

* Two scripts that will display battery information. See [Battery](https://github.com/Goles/Battery) and [tmux_battery_charge_indicator](https://github.com/AaronLasseigne/tmux_battery_charge_indicator) for further information.
* `tmux-mem-cpu-load` that you can install via brew

## Configure git

```
$ git config --global user.name "Your Name"
$ git config --global user.email your@email.com
$ git config --global core.editor emacs
```

Check that your configuration is properly setup,

```
$ git config --list
```
