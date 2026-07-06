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
(add-to-list 'default-frame-alist '(height . 45))
;; Basic UI and Startup Behavior:1 ends here

;; [[file:config.org::*Fonts][Fonts:1]]
(when (member "SF Mono" (font-family-list))
  (set-face-attribute 'default nil :family "SF Mono" :height 140))
;; Fonts:1 ends here

;; [[file:config.org::*Networking][Networking:1]]
(with-eval-after-load 'gnutls
  (add-to-list 'gnutls-trustfiles "/usr/local/etc/openssl/cert.pem"))
;; Networking:1 ends here

;; [[file:config.org::*Custom Keybindings][Custom Keybindings:1]]
(global-set-key (kbd "C-c r") (lambda () (interactive) (load-file user-init-file)))
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

;; [[file:config.org::*Themes][Themes:1]]
(setq custom-safe-themes t)
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (optional).
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)

  ;; Load the theme (choose your favorite).
  (load-theme 'doom-molokai t)

  ;; Enable flashing mode-line on errors.
  (doom-themes-visual-bell-config)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))
;; Themes:1 ends here
