;;; config.el --- generated from config.org -*- lexical-binding: t; -*-

;; [[file:config.org::*Package Management][Package Management:1]]
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(setq use-package-always-ensure t)
;; Package Management:1 ends here

;; [[file:config.org::*Basic UI and Startup Behavior][Basic UI and Startup Behavior:1]]
(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(setq visible-bell t)
(if (string-prefix-p "KevinsMacStudio" (system-name))
    (progn
      (add-to-list 'default-frame-alist '(width . 100))
      (add-to-list 'default-frame-alist '(height . 60)))
  (add-to-list 'default-frame-alist '(height . 45)))
;; Basic UI and Startup Behavior:1 ends here

;; [[file:config.org::*Fonts][Fonts:1]]
(defun my/apply-font-settings ()
  "Set the default and variable-pitch face families for this machine.
Must run with a graphical frame live: in a daemon session
`font-family-list' is empty until a frame connects to a display.

The `variable-pitch' face is the proportional face `mixed-pitch'
switches prose body text to (see `prose-mode'); we point it at
Apple's San Francisco text face when present. \"SF Pro Text\" is the
body-optimized cut (as opposed to \"SF Pro Display\" for headline
sizes); the umbrella \"SF Pro\" name does not resolve, so the specific
cuts are named. When neither is installed the face is left alone,
falling back to its default \"Sans Serif\"."
  (let ((mono-font (seq-find (lambda (f) (member f (font-family-list)))
                             '("SF Mono" "Menlo" "JetBrainsMono Nerd Font")))
        (prose-font (seq-find (lambda (f) (member f (font-family-list)))
                              '("SF Pro Text" "SF Pro Display"))))
    (set-face-attribute
     'default nil
     :family (or mono-font (face-attribute 'default :family))
     :height (if (string-prefix-p "KevinsMacStudio" (system-name)) 180 130))
    (when prose-font
      ;; Family only: leaving :height unspecified lets variable-pitch
      ;; inherit the per-machine default height above, so `prose-mode's
      ;; text-scale bump still applies on top.
      (set-face-attribute 'variable-pitch nil :family prose-font))))

(if (daemonp)
    (add-hook 'server-after-make-frame-hook #'my/apply-font-settings)
  (my/apply-font-settings))
;; Fonts:1 ends here

;; [[file:config.org::*Networking][Networking:1]]
(with-eval-after-load 'gnutls
  (add-to-list 'gnutls-trustfiles "/usr/local/etc/openssl/cert.pem"))
;; Networking:1 ends here

;; [[file:config.org::*Custom Keybindings][Custom Keybindings:1]]
(defun my/reload-config ()
  "Reload the Emacs configuration without restarting the daemon.
Loads `user-init-file', which reloads `custom.el' and re-tangles
and loads `config.org'.  Additive only: removed settings are not
undone until a full restart."
  (interactive)
  (load-file user-init-file)
  (message "Config reloaded from %s" (abbreviate-file-name user-init-file)))

(global-set-key (kbd "C-c r") #'my/reload-config)
;; Custom Keybindings:1 ends here

;; [[file:config.org::*Which-Key][Which-Key:1]]
(use-package which-key
  :init
  (which-key-mode)
  :custom
  (which-key-idle-delay 0.5))
;; Which-Key:1 ends here

;; [[file:config.org::*Minibuffer Defaults][Minibuffer Defaults:1]]
(use-package emacs
  :ensure nil
  :custom
  ;; Enable context menu. `vertico-multiform-mode' adds a menu in the
  ;; minibuffer to switch display modes.
  (context-menu-mode t)
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode. Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt.
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))
;; Minibuffer Defaults:1 ends here

;; [[file:config.org::*Consult][Consult:1]]
(use-package consult
  :init
  ;; Populates consult-buffer's "File" section with recently opened
  ;; files -- without this, recentf-mode is off by default and that
  ;; section stays empty.
  (recentf-mode 1)
  :bind
  (("C-x b" . consult-buffer)
   ("M-g g" . consult-goto-line)
   ("M-g i" . consult-imenu)
   ("M-s l" . consult-line)
   ("M-s r" . consult-ripgrep)))
;; Consult:1 ends here

;; [[file:config.org::*Embark][Embark:1]]
(use-package embark
  :bind
  (("C-." . embark-act)
   ("C-," . embark-dwim)
   ("C-h B" . embark-bindings))
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :after (embark consult)
  ;; Load eagerly once both Embark and Consult are present, rather
  ;; than waiting for first use. Embark itself checks (via
  ;; `with-eval-after-load' on Consult) whether embark-consult has
  ;; already been required, and warns if it hasn't -- which fires
  ;; immediately at startup if this package is left to load lazily,
  ;; even though it's installed.
  :demand t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))
;; Embark:1 ends here

;; [[file:config.org::*Marginalia][Marginalia:1]]
(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer. To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init
  (setq marginalia-field-width 120)

  ;; Marginalia must be activated in the :init section of use-package such
  ;; that the mode gets enabled right away. Note that this forces loading
  ;; the package.
  (marginalia-mode))
;; Marginalia:1 ends here

;; [[file:config.org::*Orderless][Orderless:1]]
(use-package orderless
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  ;; Disable defaults, use our settings.
  (completion-category-defaults nil)
  ;; Emacs 31: partial-completion behaves like substring.
  (completion-pcm-leading-wildcard t))
;; Orderless:1 ends here

;; [[file:config.org::*Savehist][Savehist:1]]
(use-package savehist
  :ensure nil
  :init
  (savehist-mode))
;; Savehist:1 ends here

;; [[file:config.org::*Vertico][Vertico:1]]
(use-package vertico
  :init
  (vertico-mode))
;; Vertico:1 ends here

;; [[file:config.org::*Cape][Cape:1]]
(use-package cape
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-keyword))
;; Cape:1 ends here

;; [[file:config.org::*Corfu][Corfu:1]]
(use-package corfu
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-cycle t))
;; Corfu:1 ends here

;; [[file:config.org::*Avy][Avy:1]]
(use-package avy
  :bind
  (("C-;" . avy-goto-char-timer)
   ("C-:" . avy-goto-char-2)
   ("M-g w" . avy-goto-word-1)
   ("M-g l" . avy-goto-line)))
;; Avy:1 ends here

;; [[file:config.org::*God Mode][God Mode:1]]
(use-package god-mode
  :bind
  (("<f13>" . god-mode-all)
   ("<Tools>" . god-mode-all)
   ("<XF86Tools>" . god-mode-all))
  :config
  (defun my/god-mode-update-cursor ()
    (setq cursor-type (if (or god-local-mode buffer-read-only) 'box 'bar)))
  (add-hook 'god-mode-enabled-hook #'my/god-mode-update-cursor)
  (add-hook 'god-mode-disabled-hook #'my/god-mode-update-cursor))
;; God Mode:1 ends here

;; [[file:config.org::*Magit][Magit:1]]
(use-package magit
  :bind
  ("C-x g" . magit-status))
;; Magit:1 ends here

;; [[file:config.org::*Rainbow Delimiters][Rainbow Delimiters:1]]
(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))
;; Rainbow Delimiters:1 ends here

;; [[file:config.org::*Vundo][Vundo:1]]
(use-package vundo
  :bind
  ("C-x u" . vundo))
;; Vundo:1 ends here

;; [[file:config.org::*Prose Writing][Prose Writing:1]]
(use-package olivetti
  :custom
  (olivetti-body-width 66))

(use-package mixed-pitch)

(use-package org-modern)
;; Prose Writing:1 ends here

;; [[file:config.org::*Prose Writing][Prose Writing:2]]
(defvar my/prose-text-scale
  (if (string-prefix-p "KevinsMacStudio" (system-name)) 0 1)
  "Extra `text-scale' steps `prose-mode' applies to the buffer.
Each step scales the buffer font by `text-scale-mode-step' (1.2x
by default).  KevinsMacStudio already runs a large 18pt default
face and gets no bump; framework gets one step over its ~13pt.")

(define-minor-mode prose-mode
  "Toggle a distraction-free prose writing environment.
Enables Olivetti, mixed-pitch, org-modern, soft line wrapping,
typewriter-style centered scrolling, and a buffer-local font bump
of `my/prose-text-scale' steps -- all in the current buffer only."
  :init-value nil
  :lighter " Prose"
  (if prose-mode
      (progn
        (olivetti-mode 1)
        (mixed-pitch-mode 1)
        (org-modern-mode 1)
        (visual-line-mode 1)
        (text-scale-set my/prose-text-scale)
        (setq-local line-spacing 0.3
                    scroll-conservatively 101
                    maximum-scroll-margin 0.5
                    scroll-margin 99999))
    (olivetti-mode -1)
    (mixed-pitch-mode -1)
    (org-modern-mode -1)
    (visual-line-mode -1)
    (text-scale-set 0)
    (kill-local-variable 'line-spacing)
    (kill-local-variable 'scroll-conservatively)
    (kill-local-variable 'maximum-scroll-margin)
    (kill-local-variable 'scroll-margin)))

(global-set-key (kbd "C-c w") #'prose-mode)
;; Prose Writing:2 ends here

;; [[file:config.org::*Themes][Themes:1]]
(setq custom-safe-themes t)
(use-package adwaita-dark-theme
  :ensure t)

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (optional).
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)

  ;; Load the theme (choose your favorite).
  (load-theme 'adwaita-dark t)

  ;; Enable flashing mode-line on errors.
  (doom-themes-visual-bell-config)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(defvar my/theme-toggle-list '(adwaita-dark doom-ayu-light)
  "Themes `my/toggle-theme' alternates between.")

(defun my/toggle-theme ()
  "Switch between the two themes in `my/theme-toggle-list'.
Disables whatever theme is currently active first, so themes
never stack."
  (interactive)
  (let* ((current (car custom-enabled-themes))
         (next (if (eq current (car my/theme-toggle-list))
                   (cadr my/theme-toggle-list)
                 (car my/theme-toggle-list))))
    (mapc #'disable-theme custom-enabled-themes)
    (load-theme next t)
    (message "Theme: %s" next)))

(global-set-key (kbd "C-c t") #'my/toggle-theme)
;; Themes:1 ends here

;; [[file:config.org::*Mode Line][Mode Line:1]]
(use-package mood-line
  :config
  (defun mood-line-segment-prose ()
    "Mode-line indicator shown only while `prose-mode' is active."
    (when (bound-and-true-p prose-mode)
      (propertize "✍ Prose" 'face 'mood-line-status-info)))

  (setq mood-line-format
        (mood-line-defformat
         :left
         (((mood-line-segment-modal)                  . " ")
          ((or (mood-line-segment-buffer-status) " ") . " ")
          ((mood-line-segment-buffer-name)            . "  ")
          ((mood-line-segment-anzu)                   . "  ")
          ((mood-line-segment-multiple-cursors)       . "  ")
          ((mood-line-segment-cursor-position)        . " ")
          (mood-line-segment-scroll))
         :right
         (((mood-line-segment-prose)      . "  ")
          ((mood-line-segment-vc)         . "  ")
          ((mood-line-segment-major-mode) . "  ")
          ((mood-line-segment-misc-info)  . "  ")
          ((mood-line-segment-checker)    . "  ")
          ((mood-line-segment-process)    . "  "))))

  (mood-line-mode))
;; Mode Line:1 ends here
