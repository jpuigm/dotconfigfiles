;; emacs basic configuration file

(package-initialize)

;; Set user information
(setq user-full-name "Juan Puig Martinez")
(setq user-mail-address "juan.puig@gmail.com")

;; default emacs configuration directory
(defconst toc:emacs-config-dir "/vagrant/src/github.com/jpuigm/dotconfigfiles/emacs_config/" "")

;; utility function to auto-load my package configurations
(defun toc:load-config-file (filelist)
  (dolist (file filelist)
    (load (expand-file-name
           (concat toc:emacs-config-dir file)))
    (message "Loaded config file:%s" file)
    ))

;; load my configuration files
(toc:load-config-file '("dev"
                        "package"
                        ))
