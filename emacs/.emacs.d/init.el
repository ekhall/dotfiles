;;; init.el --- Bootstrap for literate Emacs configuration -*- lexical-binding: t; -*-

;;; Commentary:

;; This file only bootstraps two things:
;;
;;   1. `custom-file': Emacs's own Customize system writes generated
;;      settings (selected packages, custom faces, ...) to a dedicated
;;      file instead of appending them here or into `config.org', where
;;      Emacs can't safely rewrite them.
;;
;;   2. The literate configuration: `org-babel-load-file' tangles
;;      `config.org' (in this same directory) into `config.el' and
;;      loads it, re-tangling only when `config.org' is newer than the
;;      generated `config.el'.
;;
;; All actual configuration (packages, keybindings, UI, etc.) lives in
;; `config.org' as prose plus `emacs-lisp' source blocks. Edit that
;; file, not this one, and not the generated `config.el'.

;;; Code:

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

(require 'org)
(org-babel-load-file (expand-file-name "config.org" user-emacs-directory))

(provide 'init)
;;; init.el ends here
