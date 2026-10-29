;;; erlang.el --- Erlang setup  -*- lexical-binding: t; -*-

(use-package erlang
  :mode (("\\.app\\'" . erlang-mode)
         ("app\\.src\\'" . erlang-mode)
         ("\\.config\\'" . erlang-mode)
         ("\\.rel\\'" . erlang-mode)
         ("\\.script\\'" . erlang-mode)
         ("\\.escript\\'" . erlang-mode))
  :hook (erlang-mode . (lambda () (imenu-add-to-menubar "Imenu")))
  :config
  (setq erlang-electric-commands nil)
  ;; Look for headers and deps when compiling from inside a rebar-style tree
  (setq erlang-compile-extra-opts
        '(bin_opt_info debug_info
          (i . "../include") (i . "../deps") (i . "../../") (i . "../../../deps")))
  ;; Where compiled .beam files go
  (setq erlang-compile-outdir "../ebin"))

;;; erlang.el ends here
