;; Ido-mode - Shows folder contents while looking for a file.
(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)

;; Misc
(line-number-mode)
(column-number-mode) ;; displays column and line numbers
(delete-selection-mode 1)
(show-paren-mode)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
(setq-default c-basic-offset 4)
