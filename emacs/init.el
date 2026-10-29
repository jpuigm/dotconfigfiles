;;; init.el --- The Founder's Config  -*- lexical-binding: t; -*-

;; --- 1. GUI CLEANUP ---
;; Make it look like a modern app, not a 1990s workstation
(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(set-fringe-mode 10)
(set-face-attribute 'default nil :font "JetBrains Mono" :height 120)

;; --- 2. PACKAGE MANAGEMENT ---
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")))
(package-initialize)
(unless package-archive-contents (package-refresh-contents))

;; Use-package is built-in in Emacs 29
(require 'use-package)
(setq use-package-always-ensure t)

;; --- 3. THE "BRAIN": ORG-MODE ---
(use-package org
  :ensure t
  :config
  (setq org-ellipsis " ⤵")
  (setq org-hide-emphasis-markers t)
  (setq org-log-done 'time) ; Track when you finish tasks (great for burn-rate logs)
  (setq org-directory "~/org")
  (setq org-agenda-files '("~/org/startup.org" "~/org/life.org")))

;; --- 4. MODERN INTERFACE (VERTICO) ---
;; This makes the "Minibuffer" (bottom bar) behave like a modern search
(use-package vertico
  :init (vertico-mode))

(use-package orderless
  :custom (completion-styles '(orderless basic)))

(use-package marginalia
  :init (marginalia-mode))

;; --- 5. THE THEME ---
(use-package doom-themes
  :config (load-theme 'doom-one t))

;; --- 6. DEVELOPER ESSENTIALS ---
(use-package magit) ; The best Git interface in existence

(use-package project
  :ensure nil) ; Built-in project management

;; --- 7. LANGUAGES ---
;; Optional per-language modules, symlinked next to this file by install.sh
(load (expand-file-name "erlang.el" user-emacs-directory) t)

;; --- 8. CUSTOM ---
;; Keep Custom's auto-generated settings out of version control
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t)
