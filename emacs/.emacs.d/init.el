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

;; Third-party packages get natively compiled in the background the
;; first time they're loaded on a new machine. That compilation
;; surfaces style nits in code we don't control (missing
;; `lexical-binding' cookies, free-variable references, etc.) as a
;; `*Warnings*' buffer that pops up and steals focus on startup. The
;; warnings are cosmetic upstream noise, not signs of a broken
;; config, so suppress the pop-up; native-comp keeps compiling and
;; logging quietly either way.
(when (boundp 'native-comp-async-report-warnings-errors)
  (setq native-comp-async-report-warnings-errors nil))

(require 'org)
(org-babel-load-file (expand-file-name "config.org" user-emacs-directory))

(provide 'init)
;;; init.el ends here
