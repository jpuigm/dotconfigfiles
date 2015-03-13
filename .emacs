;; emacs configuration file

;; Set user information 
(setq user-full-name "Juan Puig Martinez")
(setq user-mail-address "juan.puig@gmail.com")


;; Erlang Emacs Mode -- Configuration Start
(setq erlang-root-dir "/usr/local/lib/erlang")
(setq load-path (cons (car (file-expand-wildcards (concat erlang-root-dir "/lib/tools-*/emacs"))) load-path))
(setq erlang-electric-commands nil)
(setq exec-path (cons "/usr/local/lib/erlang/bin" exec-path))
(require 'erlang-start)
;; Erlang Emacs Mode -- Configuration End

(add-hook 'after-init-hook 'my-after-init-hook)
(defun my-after-init-hook ()
  (require 'edts-start))

(add-hook 'erlang-mode-hook
          '(lambda()
             (imenu-add-to-menubar "Imenu")))

; define auto erlang mode for these files/extensions.
(add-to-list 'auto-mode-alist '(".*\\.app\\'" . erlang-mode))
(add-to-list 'auto-mode-alist '(".*app\\.src\\'" . erlang-mode))
(add-to-list 'auto-mode-alist '(".*\\.config\\'" . erlang-mode))
(add-to-list 'auto-mode-alist '(".*\\.rel\\'" . erlang-mode))
(add-to-list 'auto-mode-alist '(".*\\.script\\'" . erlang-mode))
(add-to-list 'auto-mode-alist '(".*\\.escript\\'" . erlang-mode))

; add include directory to default compile path.
(defvar erlang-compile-extra-opts
  '(bin_opt_info debug_info (i . "../include") (i . "../deps") (i . "../../") (i . "../../../deps")))

; define where put beam files.
(setq erlang-compile-outdir "../ebin")

;;;----------------------------------------
;;; flymake
;;;----------------------------------------

(require 'flymake)
(setq flymake-log-level 3)

(defun flymake-compile-script-path (path)
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list path (list local-file))))

(defun flymake-syntaxerl ()
  (flymake-compile-script-path "~/bin/syntaxerl"))

(add-hook 'erlang-mode-hook
          '(lambda()
             (add-to-list 'flymake-allowed-file-name-masks '("\\.erl\\'" flymake-syntaxerl))
             (add-to-list 'flymake-allowed-file-name-masks '("\\.hrl\\'" flymake-syntaxerl))
             (add-to-list 'flymake-allowed-file-name-masks '("\\.app\\'" flymake-syntaxerl))
             (add-to-list 'flymake-allowed-file-name-masks '("\\.app.src\\'" flymake-syntaxerl))
             (add-to-list 'flymake-allowed-file-name-masks '("\\.config\\'" flymake-syntaxerl))
             (add-to-list 'flymake-allowed-file-name-masks '("\\.rel\\'" flymake-syntaxerl))
             (add-to-list 'flymake-allowed-file-name-masks '("\\.script\\'" flymake-syntaxerl))
             (add-to-list 'flymake-allowed-file-name-masks '("\\.escript\\'" flymake-syntaxerl))

             ;; should be the last.
             (flymake-mode 1)
             ))

;; Stolen from http://www.emacswiki.org/emacs/FlyMake
;; Shows flymake message even in xterm by typing C-c f
(defun my-flymake-err-at (pos)
  (let ((overlays (overlays-at pos)))
    (remove nil
            (mapcar (lambda (overlay)
                      (and (overlay-get overlay 'flymake-overlay)
                           (overlay-get overlay 'help-echo)))
                    overlays))))

(defun my-flymake-err-echo ()
  (interactive)
  (message "%s" (mapconcat 'identity (my-flymake-err-at (point)) "\n")))

(global-set-key (kbd "C-c f") 'my-flymake-err-echo)

;; Avoids some flymake crashses.

(eval-after-load "flymake"
    '(setq flymake-gui-warnings-enabled nil
           flymake-log-level 0))

;; EQC Emacs Mode -- Configuration Start
;; (add-to-list 'load-path "/usr/local/lib/erlang/lib/eqc-1.22/emacs/")
;; (autoload 'eqc-erlang-mode-hook "eqc-ext" "EQC Mode" t)
;; (add-hook 'erlang-mode-hook 'eqc-erlang-mode-hook)
;; (setq eqc-max-menu-length 30)
;; (setq eqc-root-dir "/usr/local/lib/erlang/lib/eqc-1.22")
;; EQC Emacs Mode -- Configuration End

;; Variables
(setq-default indent-tabs-mode nil)
(setq-default c-basic-offset 4)

;; Misc
(line-number-mode)
(column-number-mode) ;; displays column and line numbers
(delete-selection-mode 1)
(show-paren-mode)

;; Ido-mode - Shows folder contents while looking for a file.
(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

(eval-after-load "magit" 
 '(mapc (apply-partially 'add-to-list 'magit-repo-dirs)
              '("~/layer/ctrl" "~/layer/ecu" "~/layer/edb" "~/layer/esd" "~/layer/rabbitmq-erlang-client" "~/layer/tmc" "~/layer/shift")))

;; change magit diff colors
(eval-after-load 'magit
  '(progn
     (set-face-background 'magit-item-highlight "White")))

;; ;; .org
;; (setq load-path (cons "/Users/maggie-mbp/Downloads/Other/org-mode/lisp" load-path))
;; (setq load-path (cons "/Users/maggie-mbp/Downloads/Other/org-mode/contrib/lisp" load-path))
;; ;; The following lines are always needed.  Choose your own keys.
;; (add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode)) ; not needed since Emacs 22.2
;; (add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
;; (global-set-key "\C-cl" 'org-store-link)
;; (global-set-key "\C-ca" 'org-agenda)
;; (global-set-key "\C-cb" 'org-iswitchb)

;; ;;jabber.erl 
;; (setq jabber-username "jupi2004" ;; notice: leave off the @gmail.com
;;       jabber-server "gmail.com"     ;; this is a part of your user ID, not a part of the server you will connect to.
;;       jabber-network-server "talk.google.com"  ;; this is the actual server to connect to
;;       jabber-port 5222
;;       jabber-connection-type 'ssl)

;; (defun jabber ()
;;   (interactive)
;;   (jabber-connect)
;;   (switch-to-buffer "*-jabber-*"))

;; (require 'jabber-autoloads)
;; (setq jabber-account-list
;;      '(("jupi2004@gmail.com" 
;;         (:network-server . "talk.google.com")
;;         (:password . nil)
;;         ;; (:port . 5223)
;;         (:port . 443)
;;         (:connection-type . ssl))));

;(custom-set-variables
 ;; '(jabber-avatar-verbose nil)
 ;; '(jabber-vcard-avatars-retrieve nil)
 ;; '(jabber-chat-buffer-format "*-jabber-%n-*")
; '(jabber-history-enabled t)
; '(jabber-mode-line-mode t)
;; '(jabber-auto-reconnect t)
;; '(password-cache-expiry nil)
 ;; '(jabber-roster-buffer "*-jabber-*")
 ;; '(jabber-roster-line-format "%S %c %-25n %u %-8s (%r)")
; '(jabber-show-offline-contacts nil))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(edts-man-root "/Users/juan/.emacs.d/edts/doc/17.1"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;rsense
(require 'rsense)

;;rinari
(require 'rinari)
(global-rinari-mode)

;; Ruby lines
(add-hook 'after-init-hook 'inf-ruby-switch-setup)
(add-hook 'ruby-mode-hook 'linum-mode) ;; technically using 'prog-mode-hook instead would work for all major prog modes
