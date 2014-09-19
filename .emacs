;; emacs configuration file

;; Set user information 
(setq user-full-name "Juan Puig Martinez")
(setq user-mail-address "juan.puig@gmail.com")


;; Erlang Emacs Mode -- Configuration Start
(setq erlang-root-dir "/usr/local/lib/erlang")
(setq load-path (cons  "/usr/local/lib/erlang/lib/tools-2.6.15/emacs" load-path))
(setq exec-path (cons "/usr/local/lib/erlang/bin" exec-path))
(require 'erlang-start)
;; Erlang Emacs Mode -- Configuration End

(add-to-list 'load-path "/Users/juan/dev/src/edts")
(require 'edts-start)


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

;; CoffeeScript
(custom-set-variables '(coffee-tab-width 2))
(setq tab-width 2)

;; Stolen from http://www.emacswiki.org/emacs/FlyMake
;; Shows flymake message even in xterm by typing C-c f
;; (defun my-flymake-err-at (pos)
;;   (let ((overlays (overlays-at pos)))
;;     (remove nil
;;             (mapcar (lambda (overlay)
;;                       (and (overlay-get overlay 'flymake-overlay)
;;                            (overlay-get overlay 'help-echo)))
;;                     overlays))))
 
;; (defun my-flymake-err-echo ()
;;   (interactive)
;;   (message "%s" (mapconcat 'identity (my-flymake-err-at (point)) "\n")))
 
;; (global-set-key (kbd "C-c f") 'my-flymake-err-echo)

;; ;; Avoids some flymake crashses.

;; (eval-after-load "flymake"
;;     '(setq flymake-gui-warnings-enabled nil
;;            flymake-log-level 0))

;; (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
;;                          ("marmalade" . "http://marmalade-repo.org/packages/")
;;                          ("melpa" . "http://melpa.milkbox.net/packages/")))

;; (require 'package)
;; (package-initialize)

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

;(eval-after-load "magit" 
;  '(mapc (apply-partially 'add-to-list 'magit-repo-dirs)
;               '("~/dev/src/project1" "~/dev/src/project2")))

;; change magit diff colors
(eval-after-load 'magit
  '(progn
     (set-face-background 'magit-item-highlight "White")))

;; JavaScript
(autoload 'js3-mode "js3" nil t)
   (add-to-list 'auto-mode-alist '("\\.js$" . js3-mode))

(require 'handlebars-mode)

;; ;; go mode
;; (setq load-path (cons "/usr/local/go/misc/emacs" load-path))
;; (require 'go-mode-load)

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
 '(edts-man-root "~/.emacs.d/edts/doc/R16B03"))
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
