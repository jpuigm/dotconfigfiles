;;; init.el --- The Founder's Config  -*- lexical-binding: t; -*-

;; --- 1. GUI CLEANUP ---
;; Make it look like a modern app, not a 1990s workstation
(setq inhibit-startup-message t)
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(when (fboundp 'set-fringe-mode) (set-fringe-mode 10))
(set-face-attribute 'default nil :font "JetBrains Mono" :height 120)

;; --- 1b. PATH FOR DAEMONS ---
;; Daemons started by launchd/systemd get a minimal PATH, so tools from
;; Homebrew/Linuxbrew (git-crypt, etc.) are not found. Add whichever exists.
(dolist (dir '("/opt/homebrew/bin"                    ; macOS, Apple Silicon
               "/usr/local/bin"                       ; macOS Intel / Unix
               "/home/linuxbrew/.linuxbrew/bin"       ; Linuxbrew
               "~/.local/bin"))
  (let ((dir (expand-file-name dir)))
    (when (and (file-directory-p dir) (not (member dir exec-path)))
      (add-to-list 'exec-path dir)
      (setenv "PATH" (concat dir path-separator (getenv "PATH"))))))

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
  :init (vertico-mode)
  :bind (:map vertico-map
         ("DEL"   . vertico-directory-delete-char)  ; backspace after "/" removes the whole folder
         ("M-DEL" . vertico-directory-delete-word)
         ("RET"   . vertico-directory-enter))
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(use-package orderless
  :custom (completion-styles '(orderless basic)))

(use-package marginalia
  :init (marginalia-mode))

;; --- 5. THE THEME ---
;; Built in to Emacs 28+; high-contrast, so comments and strings stay readable
(load-theme 'modus-vivendi t)

;; --- 6. DEVELOPER ESSENTIALS ---
(use-package magit) ; The best Git interface in existence

;; Top level (not in :config) so emacsclient can call it even before magit loads.
;; Called from the Claude PostToolUse hook; no idle timer, to keep load low.
(defun my/magit-refresh-visible ()
  "Refresh magit-status buffers that are on screen. Skipped while typing in the minibuffer."
  (unless (or (active-minibuffer-window) (bound-and-true-p magit-inhibit-refresh))
    (dolist (buf (buffer-list))
      (when (and (buffer-live-p buf)
                 (get-buffer-window buf t)
                 (eq (buffer-local-value 'major-mode buf) 'magit-status-mode))
        (with-current-buffer buf (magit-refresh-buffer))))))

(use-package project
  :ensure nil) ; Built-in project management

;; --- 7. LANGUAGES ---
;; Optional per-language modules, symlinked next to this file by install.sh
(load (expand-file-name "erlang.el" user-emacs-directory) t)

;; --- 8. CUSTOM ---
;; Keep Custom's auto-generated settings out of version control
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t)
