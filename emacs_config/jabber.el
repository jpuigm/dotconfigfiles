;; ;;jabber.el
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
