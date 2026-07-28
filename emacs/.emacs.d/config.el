;;; config.el --- generated from config.org -*- lexical-binding: t; -*-

;; [[file:config.org::*Package Management][Package Management:1]]
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(setq use-package-always-ensure t)
;; Package Management:1 ends here

;; [[file:config.org::*Inherit the shell PATH (macOS)][Inherit the shell PATH (macOS):1]]
(when (eq system-type 'darwin)
  (use-package exec-path-from-shell
    :config
    (exec-path-from-shell-initialize)))
;; Inherit the shell PATH (macOS):1 ends here

;; [[file:config.org::*Basic UI and Startup Behavior][Basic UI and Startup Behavior:1]]
(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(setq visible-bell t)
(setq use-short-answers t)
(cond ((string-prefix-p "KevinsMacStudio" (system-name))
       (add-to-list 'default-frame-alist '(width . 100))
       (add-to-list 'default-frame-alist '(height . 60)))
      ((string-prefix-p "MWC9JXJTGDXD" (system-name))
       (add-to-list 'default-frame-alist '(width . 115))
       (add-to-list 'default-frame-alist '(height . 52)))
      (t
       (add-to-list 'default-frame-alist '(height . 45))))
;; Basic UI and Startup Behavior:1 ends here

;; [[file:config.org::*Quiet async native-compilation warnings][Quiet async native-compilation warnings:1]]
(setq native-comp-async-report-warnings-errors 'silent)
;; Quiet async native-compilation warnings:1 ends here

;; [[file:config.org::*Smooth scrolling through tall images][Smooth scrolling through tall images:1]]
(pixel-scroll-precision-mode 1)
;; Smooth scrolling through tall images:1 ends here

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
     ;; Per-machine default height (variable-pitch inherits this).
     :height (cond ((string-prefix-p "KevinsMacStudio" (system-name)) 180)
                   ((string-prefix-p "MWC9JXJTGDXD" (system-name)) 180)
                   (t 130)))
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

;; [[file:config.org::*Themes][Themes:1]]
(setq custom-safe-themes t)

;; Local themes (e.g. logic-dark) live here, next to the packaged ones.
(add-to-list 'custom-theme-load-path
             (expand-file-name "themes" user-emacs-directory))

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (optional).
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)

  ;; Enable flashing mode-line on errors.
  (doom-themes-visual-bell-config)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;; Load the default theme after doom-themes so its org fontification
;; is in place.
(load-theme 'doom-tomorrow-night t)

(defvar my/theme-toggle-list '(doom-tomorrow-night doom-tomorrow-day)
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

;; [[file:config.org::*doom-modeline (active)][doom-modeline (active):1]]
(use-package doom-modeline
  :hook (emacs-startup . doom-modeline-mode))
;; doom-modeline (active):1 ends here

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

;; [[file:config.org::*Folding a Section From Its Body][Folding a Section From Its Body:1]]
(defun my/org-fold-current-subtree ()
  "Fold the subtree containing point and move to its heading.
Works from inside an entry's body text, not just on the heading
line the way plain `TAB' / `org-cycle' require."
  (interactive)
  (org-back-to-heading t)
  (org-fold-hide-subtree))

(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c f") #'my/org-fold-current-subtree))
;; Folding a Section From Its Body:1 ends here

;; [[file:config.org::*Spell Checking][Spell Checking:1]]
(use-package jinx
  :hook (emacs-startup . global-jinx-mode)
  :bind (("M-$"   . jinx-correct)
         ("C-M-$" . jinx-languages)))
;; Spell Checking:1 ends here

;; [[file:config.org::*Lisp jargon dictionary (Clojure + Elisp comments)][Lisp jargon dictionary (Clojure + Elisp comments):1]]
(defun my/jinx-add-lisp-jargon ()
  (setq-local jinx-local-words
              (concat jinx-local-words
                      " nrepl nREPL repl REPL sexp sexps"
                      " defn defns defun defuns docstring docstrings"
                      " eval evals evaluatable evaluatably"
                      " cider CIDER clj clojure Clojure ClojureScript"
                      " deps edn babashka bb"
                      " kondo eglot flymake lsp LSP"
                      " paren parens parenthesis parenthesized"
                      " slurp slurping barf barfing splice raise"
                      " kbd elisp Elisp defvar defcustom")))
(add-hook 'clojure-ts-mode-hook #'my/jinx-add-lisp-jargon)
(add-hook 'emacs-lisp-mode-hook #'my/jinx-add-lisp-jargon)
;; Lisp jargon dictionary (Clojure + Elisp comments):1 ends here

;; [[file:config.org::*Turn off ispell word-completion in text buffers][Turn off ispell word-completion in text buffers:1]]
(setq text-mode-ispell-word-completion nil)
;; Turn off ispell word-completion in text buffers:1 ends here

;; [[file:config.org::*Magit][Magit:1]]
(use-package magit
  :bind
  ("C-x g" . magit-status))
;; Magit:1 ends here

;; [[file:config.org::*Projects (project.el)][Projects (project.el):1]]
(use-package project
  :ensure nil
  :bind-keymap ("C-c p" . project-prefix-map)
  :config
  ;; Switching to a project opens Magit for it, rather than the default
  ;; dispatch menu; individual C-c p keys still cover find-file/grep/dired.
  (setq project-switch-commands #'magit-project-status))
;; Projects (project.el):1 ends here

;; [[file:config.org::*Rust][Rust:1]]
;; Tell `treesit-install-language-grammar' where to fetch the Rust grammar's
;; source from.  This alist entry is only a recipe; it does not itself
;; download or build anything.
(add-to-list 'treesit-language-source-alist
             '(rust "https://github.com/tree-sitter/tree-sitter-rust"))

;; Build the grammar now if it isn't already installed (first machine setup
;; only -- subsequent loads see it's present and skip straight past this).
(unless (treesit-language-available-p 'rust)
  (treesit-install-language-grammar 'rust))

;; Emacs ships an older, non-tree-sitter `rust-mode' entry in its defaults;
;; this remaps any reference to it over to our tree-sitter `rust-ts-mode'
;; instead, so other packages/commands that ask for "the Rust mode" get the
;; modern one.
(add-to-list 'major-mode-remap-alist '(rust-mode . rust-ts-mode))
;; Belt-and-suspenders: make *.rs files open in rust-ts-mode directly, in case
;; something looks up auto-mode-alist without going through the remap above.
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))
;; The actual LSP wire-up: every time a buffer enters rust-ts-mode, start (or
;; attach to) rust-analyzer for it.  `eglot-ensure' is idempotent -- safe to
;; run again on an already-connected buffer.
(add-hook 'rust-ts-mode-hook #'eglot-ensure)
;; Rust:1 ends here

;; [[file:config.org::*Clojure][Clojure:1]]
;; Major mode.  Unlike Rust, no grammar recipe/build stanza is needed --
;; clojure-ts-mode fetches and compiles its own tree-sitter grammar on
;; first use (same Git + C compiler requirements as the Rust one; also
;; lands in the gitignored ~/.emacs.d/tree-sitter/).
(use-package clojure-ts-mode
  :custom
  ;; Treat each form inside (comment ...) as its own top-level form, so
  ;; C-c C-c works form-by-form in rich-comment scratchpads.
  (clojure-ts-toplevel-inside-comment-form t))

;; The REPL client.  `cider-jack-in-clj' (C-c C-x j j) shells out to the
;; Clojure CLI (`clojure' on PATH -- external install, see setup-notes),
;; so nothing here runs at startup; CIDER only acts when invoked.
(use-package cider
  :custom
  (cider-repl-display-help-banner nil)          ; skip the REPL banner
  (cider-use-overlays t)                        ; results inline at point
  (cider-eval-result-duration 'change)          ; overlay stays until an edit
  (cider-save-file-on-load t)                   ; C-c C-k saves silently
  (cider-repl-pop-to-buffer-on-connect 'display-only)) ; show REPL, keep focus

;; Structural editing, Clojure buffers only (source + REPL prompt).
;; smartparens-mode-map is only consulted where the mode is on, so these
;; bindings shadow nothing outside Clojure.
(use-package smartparens
  :hook ((clojure-ts-mode . smartparens-strict-mode)
         (cider-repl-mode . smartparens-strict-mode))
  :config
  ;; Load the default pair definitions (what makes strings/chars behave).
  (require 'smartparens-config)
  :bind (:map smartparens-mode-map
              ("C-<right>" . sp-forward-slurp-sexp)
              ("C-<left>"  . sp-forward-barf-sexp)
              ("M-D"       . sp-splice-sexp)
              ("M-R"       . sp-raise-sexp)))

;; LSP wire-up, same pattern as Rust: start (or attach to) clojure-lsp
;; whenever a buffer enters clojure-ts-mode (derived modes -- ClojureScript,
;; .cljc -- run this parent hook too).
(add-hook 'clojure-ts-mode-hook #'eglot-ensure)
;; Clojure:1 ends here

;; [[file:config.org::*Encrypted Files (EasyPG)][Encrypted Files (EasyPG):1]]
(setq epa-file-encrypt-to '("hall@absinthe.org")
      epa-file-select-keys nil)
;; Encrypted Files (EasyPG):1 ends here

;; [[file:config.org::*Encrypted Files (EasyPG)][Encrypted Files (EasyPG):2]]
(when (eq system-type 'darwin)
  (setq epa-pinentry-mode 'loopback))
;; Encrypted Files (EasyPG):2 ends here

;; [[file:config.org::*Configuration][Configuration:1]]
(use-package notmuch
  :commands (notmuch notmuch-search notmuch-mua-new-mail)
  :bind ("C-c m" . notmuch)
  :config
  (setq notmuch-show-logo nil
        notmuch-search-oldest-first nil
        ;; :sort-order newest-first is pinned per-search so it overrides the
        ;; global `notmuch-search-oldest-first' unconditionally.
        notmuch-saved-searches
        ;; Unified inbox (both accounts) plus per-account inboxes: `j i' for
        ;; everything, `j F' for Fastmail only, `j Y' for Yale only.
        '((:name "inbox"    :query "tag:inbox"                  :key "i" :sort-order newest-first)
          (:name "fastmail" :query "tag:inbox and tag:fastmail" :key "F" :sort-order newest-first)
          (:name "yale"     :query "tag:inbox and tag:yale"     :key "Y" :sort-order newest-first)
          (:name "unread"   :query "tag:unread"                 :key "u" :sort-order newest-first)
          (:name "flagged"  :query "tag:flagged"                :key "f" :sort-order newest-first)
          (:name "sent"     :query "tag:sent"                   :key "s" :sort-order newest-first)
          (:name "drafts"   :query "tag:draft"                  :key "d" :sort-order newest-first)
          (:name "all"      :query "*"                          :key "a" :sort-order newest-first)))
  ;; Thread-view readability (see the reply-tree note above): step each reply
  ;; 4 columns right of its parent so tree depth is obvious, and fully fold
  ;; `>'-style quoted citations to a clickable button (prefix/suffix 0) so a
  ;; reply's new text isn't buried under its quoted copy.  NB Outlook-style
  ;; header quoting has no `>' prefix, so it is not caught by this.
  (setq notmuch-show-indent-messages-width 4
        notmuch-wash-citation-lines-prefix 0
        notmuch-wash-citation-lines-suffix 0)
  ;; Fcc a local Sent copy only for Fastmail, which does NOT save SMTP-sent
  ;; mail server-side.  Yale is Office 365, which auto-saves sent mail into its
  ;; Exchange Sent Items (mbsync then pulls that copy down), so its Fcc is
  ;; skipped (nil folder = no Fcc): a local Fcc there would only duplicate the
  ;; server copy and trip the `notmuch insert' database lock ("Insert failed"
  ;; when it races the background `notmuch new').
  (setq notmuch-fcc-dirs
        '(("kevin\\.hall@yale\\.edu" . nil)
          (".*"                      . "fastmail/Sent"))))

;; Compose/send with notmuch's message-mode.  Emacs's built-in `smtpmail'
;; can't speak XOAUTH2, which Yale (Microsoft 365) requires, so sending is
;; handed to `msmtp' (see ~/.msmtprc): Fastmail authenticates with the app
;; password from ~/.authinfo.gpg, Yale with an OAuth2 token from
;; mutt_oauth2.py.  `my/choose-msmtp-account' picks the msmtp account per
;; message from the From header, so a reply as Yale goes out via Office 365
;; and everything else via Fastmail.
(setq mail-user-agent                'notmuch-user-agent
      message-send-mail-function     #'message-send-mail-with-sendmail
      send-mail-function             #'sendmail-send-it
      sendmail-program               (or (executable-find "msmtp") "msmtp")
      message-sendmail-f-is-evil     nil
      message-sendmail-envelope-from 'header
      user-mail-address              "hall@absinthe.org"
      user-full-name                 "E. Kevin Hall"
      message-kill-buffer-on-exit    t)

(defun my/choose-msmtp-account ()
  "Select the msmtp account (Yale vs Fastmail) from the From header.
Run from `message-send-mail-hook' (very late, in the outgoing message
buffer), it sets the buffer-local `-a ACCOUNT' argument that
`message-send-mail-with-sendmail' passes to msmtp."
  (when (message-mail-p)
    (let ((from (or (message-fetch-field "from") "")))
      (setq-local message-sendmail-extra-arguments
                  (list "-a" (if (string-match-p "@yale\\.edu" from)
                                 "yale" "fastmail"))))))
(add-hook 'message-send-mail-hook #'my/choose-msmtp-account)
;; Configuration:1 ends here

;; [[file:config.org::*Deleting mail (move to Fastmail Trash)][Deleting mail (move to Fastmail Trash):1]]
(with-eval-after-load 'notmuch
  (defun my/notmuch-search-delete ()
    "Tag thread(s) `deleted' and advance; synced to Fastmail Trash on next poll."
    (interactive)
    (notmuch-search-tag '("+deleted" "-inbox" "-unread"))
    (notmuch-search-next-thread))

  (defun my/notmuch-show-delete ()
    "Tag the current message `deleted' and move to the next thread."
    (interactive)
    (notmuch-show-tag '("+deleted" "-inbox" "-unread"))
    (notmuch-show-next-thread t))

  (define-key notmuch-search-mode-map (kbd "d") #'my/notmuch-search-delete)
  (define-key notmuch-show-mode-map   (kbd "d") #'my/notmuch-show-delete))
;; Deleting mail (move to Fastmail Trash):1 ends here

;; [[file:config.org::*Auto-fetch every 5 minutes][Auto-fetch every 5 minutes:1]]
(with-eval-after-load 'notmuch
  (defvar my/notmuch-poll-process nil
    "The most recent background `notmuch new' process, or nil.")

  (defun my/notmuch-poll-async ()
    "Run `notmuch new' in the background, then refresh notmuch buffers."
    (when (or (null my/notmuch-poll-process)
              (not (process-live-p my/notmuch-poll-process)))
      (setq my/notmuch-poll-process
            (make-process
             :name "notmuch-poll" :buffer nil :noquery t
             :command (list notmuch-command "new")
             :sentinel (lambda (_proc event)
                         (when (string-prefix-p "finished" event)
                           (notmuch-refresh-all-buffers)))))))

  (defun my/notmuch-poll-refresh ()
    "Non-blocking replacement for `G' (`notmuch-poll-and-refresh-this-buffer').
Kick off the background `notmuch new' (see `my/notmuch-poll-async')
instead of the built-in synchronous poll, so a manual sync never freezes
the UI.  Open buffers refresh when the fetch finishes; if a poll is
already running, just say so rather than starting a second one."
    (interactive)
    (if (and my/notmuch-poll-process (process-live-p my/notmuch-poll-process))
        (message "notmuch: a background sync is already running…")
      (my/notmuch-poll-async)
      (message "notmuch: syncing mail in the background…")))

  (define-key notmuch-search-mode-map (kbd "G") #'my/notmuch-poll-refresh)
  (define-key notmuch-hello-mode-map  (kbd "G") #'my/notmuch-poll-refresh)
  (define-key notmuch-show-mode-map   (kbd "G") #'my/notmuch-poll-refresh)

  (defvar my/notmuch-poll-timer nil
    "Repeating timer that drives `my/notmuch-poll-async'.")
  (when (timerp my/notmuch-poll-timer) (cancel-timer my/notmuch-poll-timer))
  (setq my/notmuch-poll-timer
        (run-with-timer 300 300 #'my/notmuch-poll-async)))
;; Auto-fetch every 5 minutes:1 ends here

;; [[file:config.org::*Configuration][Configuration:1]]
;; defconst, not defvar: these are edited in this file and must update
;; on `C-c r'.  `defvar' only assigns when the symbol is unbound, so once
;; the daemon has a value it ignores later edits until a full restart;
;; `defconst' reassigns on every load.
(defconst my/freshrss-host "freshrss.penrhynhalls.net"
  "Hostname of the FreshRSS instance, reverse-proxied by Caddy.
Resolves to the Caddy host on the LAN, and over Tailscale when away.")

(defconst my/freshrss-user "hall"
  "FreshRSS account name, used for the Fever URL and auth-source lookup.")

(defvar my/elfeed-known-categories (make-hash-table :test 'eq)
  "FreshRSS category tags (interned symbols) currently known.
Populated by `my/elfeed-freshrss-refresh-categories'.
`my/elfeed-search-print-entry' consults this to decide which tags get a
category color -- `unread' and any other non-category tag are left with
the default face.  A plain `defvar' (not `defconst'): this is accumulated
state refreshed by a sync, not a config value that should reset on `C-c
r' -- the categories fetched by the last sync should survive a reload.")

(defun my/elfeed-category-color (name)
  "Return a stable hex color for category NAME (a string or symbol).
Hashes NAME to a hue (0-359 degrees) with `sxhash-equal' -- deterministic,
so the same category name always gets the same color across restarts and
machines, with nothing to store or hand-pick as categories are added.
Saturation and lightness are fixed so every generated color stays legible
against both light and dark themes; only the hue varies."
  (require 'color)
  (let* ((name (if (symbolp name) (symbol-name name) name))
         (hue (/ (mod (abs (sxhash-equal name)) 360) 360.0)))
    (apply #'color-rgb-to-hex (append (color-hsl-to-rgb hue 0.55 0.65) '(2)))))

(defun my/elfeed-freshrss-clear-read ()
  "Mirror FreshRSS read/unread state onto already-downloaded Elfeed entries.
elfeed-protocol's Fever sync only applies read-state to entries it
*fetches*, and `G' fetches only new ids -- so articles read on
another device keep a stale `unread' tag here, and
`elfeed-protocol-fever-reinit' does not fix it either.

This fetches the Fever `unread_item_ids' set directly and, for
every local entry carrying a Fever id, adds or removes the
`unread' tag to match the server -- locally only, so nothing is
pushed back.  The Fever api_key is md5(user:password); the
password comes from auth-source, never from this file.

Local-only is enforced by binding `elfeed-tag-hook' and
`elfeed-untag-hook' to nil around the walk, NOT by the choice of
tagging function: `elfeed-tag-1'/`elfeed-untag-1' were the
hook-free primitives when this was written, but elfeed 4.0.0 made
them obsolete aliases for `elfeed-tag'/`elfeed-untag', which do
run the hooks."
  (interactive)
  (let* ((host my/freshrss-host) (user my/freshrss-user)
         (pw (auth-source-pick-first-password :host host :user user))
         (key (md5 (concat user ":" pw)))
         (url (format "https://%s/api/fever.php?api&unread_item_ids" host))
         (url-request-method "POST")
         (url-request-extra-headers
          '(("Content-Type" . "application/x-www-form-urlencoded")))
         (url-request-data (concat "api_key=" key))
         (unread-set (make-hash-table :test 'eql)))
    (with-current-buffer (url-retrieve-synchronously url t t 30)
      (goto-char (point-min))
      (re-search-forward "\n\n" nil t)
      (let* ((json (json-parse-buffer :object-type 'alist))
             (ids (alist-get 'unread_item_ids json)))
        (unless (eql 1 (alist-get 'auth json))
          (user-error "FreshRSS Fever auth failed"))
        (dolist (id (split-string (or ids "") "," t))
          (puthash (string-to-number id) t unread-set))))
    (let ((cleared 0) (marked 0)
          ;; Keep the walk local.  elfeed-protocol hangs
          ;; `elfeed-protocol-on-tag-remove' on `elfeed-untag-hook', so
          ;; each untag here would POST "mark as read" back to FreshRSS --
          ;; pointless (we are mirroring the server's own state) and
          ;; actively fatal: entries whose proto-id is no longer in
          ;; `elfeed-feeds' (e.g. left over from an earlier feed URL)
          ;; resolve to a nil host-url, and `elfeed-protocol-meta-user'
          ;; then dies in `split-string' with "stringp nil".
          (elfeed-tag-hook nil)
          (elfeed-untag-hook nil))
      (with-elfeed-db-visit (entry _feed)
        (let ((id (elfeed-meta entry :id)))
          (when id
            (if (gethash id unread-set)
                (unless (elfeed-tagged-p 'unread entry)
                  (elfeed-tag entry 'unread) (setq marked (1+ marked)))
              (when (elfeed-tagged-p 'unread entry)
                (elfeed-untag entry 'unread) (setq cleared (1+ cleared)))))))
      (elfeed-db-save)
      (when (get-buffer "*elfeed-search*")
        (with-current-buffer "*elfeed-search*" (elfeed-search-update :force)))
      (message "FreshRSS reconcile: cleared %d read, marked %d unread; %d unread on server"
               cleared marked (hash-table-count unread-set)))))

;; Run the read-state reconcile automatically after every sync.  A plain
;; `G' (unread-only Fever sync) only *imports* the server's currently-unread
;; ids; it never clears the `unread' tag from entries read on another device
;; -- those just drop out of the fetched set and elfeed never revisits them.
;; So without this, reading on the phone never propagates here.
;; `elfeed-update-hook' fires from inside elfeed-curl's process sentinel and
;; can fire several times per `G' (once per id chunk), so debounce onto a
;; short timer: the fires collapse into a single reconcile that runs just
;; after the sync's own DB writes settle, off the sentinel.  Manual `C-c E'
;; still works for the rare case where the server's unread set is empty (then
;; `G' fetches nothing and this hook never fires).
(defvar my/elfeed-reconcile-timer nil
  "Debounce timer coalescing post-sync `my/elfeed-freshrss-clear-read' runs.")

(defun my/elfeed-freshrss-reconcile-after-sync (&rest _)
  "Schedule one read-state reconcile shortly after a sync settles.
Added to `elfeed-update-hook'; debounced via `my/elfeed-reconcile-timer'
so the several per-sync hook fires trigger only a single reconcile."
  (when (timerp my/elfeed-reconcile-timer)
    (cancel-timer my/elfeed-reconcile-timer))
  (setq my/elfeed-reconcile-timer
        (run-at-time 2 nil #'my/elfeed-freshrss-clear-read)))

(add-hook 'elfeed-update-hook #'my/elfeed-freshrss-reconcile-after-sync)

(defun my/elfeed-purge-dead-protocol-entries ()
  "Delete Elfeed entries and feeds orphaned by a changed protocol URL.
elfeed-protocol stamps every entry with a `:protocol-id' naming the
server it came from (e.g. `fever+https://user@host').  Change that URL
-- a new hostname, or http->https -- and the entries and feed objects
fetched under the *old* proto-id linger in the database forever: they
render as duplicate rows, and opening one dies in
`elfeed-protocol-meta-user' because the stale proto-id no longer maps
to a configured host.  (This database once held ~123 entries under an
old `fever+http://hall@100.121.73.82' Tailscale-IP address.)

This removes every entry and every feed whose proto-id is not among the
currently-configured `elfeed-feeds'.  It reports the counts and asks
before deleting.  Run it after changing the FreshRSS URL; it is a
harmless no-op when nothing is stale.  Only protocol feeds (a `scheme+'
url) are ever considered, so a plain-RSS feed is never touched."
  (interactive)
  (elfeed-db-ensure)
  (let* ((proto-of (lambda (url) (car (split-string url "::"))))
         (live (delete-dups
                (mapcar (lambda (f) (funcall proto-of (if (listp f) (car f) f)))
                        elfeed-feeds)))
         (dead-entries '()) (dead-unread 0) (dead-feeds '()))
    (maphash (lambda (_id e)
               (let ((pid (elfeed-meta e :protocol-id)))
                 (when (and pid (not (member pid live)))
                   (push e dead-entries)
                   (when (memq 'unread (elfeed-entry-tags e))
                     (setq dead-unread (1+ dead-unread))))))
             elfeed-db-entries)
    (maphash (lambda (url _f)
               (when (and (string-match-p "\\`[a-z]+\\+" url)
                          (not (member (funcall proto-of url) live)))
                 (push url dead-feeds)))
             elfeed-db-feeds)
    (if (and (null dead-entries) (null dead-feeds))
        (message "Elfeed: no dead-protocol entries or feeds; nothing to purge")
      (when (yes-or-no-p
             (format "Delete %d dead entries (%d unread) and %d dead feeds? "
                     (length dead-entries) dead-unread (length dead-feeds)))
        (elfeed-db-delete dead-entries)
        (dolist (url dead-feeds) (remhash url elfeed-db-feeds))
        (elfeed-db-save)
        (when (get-buffer "*elfeed-search*")
          (with-current-buffer "*elfeed-search*" (elfeed-search-update :force)))
        (message "Elfeed: purged %d entries and %d dead feeds"
                 (length dead-entries) (length dead-feeds))))))

(defun my/elfeed-freshrss-refresh-categories ()
  "Retag already-downloaded entries with their *current* FreshRSS category.
elfeed-protocol computes an entry's category tag only once, at the moment
it is first inserted into the database (see
`elfeed-protocol-fever--parse-entries' in elfeed-protocol-fever.el): unlike
the `unread'/starred tags, which it force-overrides on every sync, it never
revisits an existing entry's category. So re-categorizing a feed in
FreshRSS has no effect on articles already synced here -- only new articles
fetched afterward would get it right -- and there is no
`elfeed-protocol-fever-reinit'-style command that fixes it either, since
matching entries are still treated as already-existing, not new.

This fetches FreshRSS's live feed -> category mapping directly (the same
`?api&groups' endpoint elfeed-protocol-fever itself uses) and, for every
local entry, swaps out whichever known category tag it currently carries
for the correct one -- locally only, same pattern as
`my/elfeed-freshrss-clear-read'. Runs automatically after every sync via
`elfeed-update-hook' (after `my/elfeed-dedupe-by-title', so it also cleans
up any category drift that merge step can reintroduce -- see the comment
on its `add-hook' call), and can still be run by hand with `C-c c'. Forces
a fresh auth-source decrypt first
(see the `:password' lambda above) rather than risking a stale cached
password in a long-running session.

Runs automatically and unsupervised (no human watching for a failure to
retry), so any error here -- a network hiccup, a timed-out request, an
unexpected response -- is caught and logged to `*elfeed-log*'
(`M-x elfeed-log-show') instead of propagating as an unhandled error.  An
unhandled error inside a timer callback (which is what runs this after a
deferred hook fire) is exactly what produces an auto-popping, easy-to-miss
`*Backtrace*' window -- this replaces that with the same quiet failure
handling elfeed itself uses for its own Fever errors."
  (interactive)
  (condition-case err
      (let* ((host my/freshrss-host) (user my/freshrss-user)
             (pw (progn (auth-source-forget-all-cached)
                        (auth-source-pick-first-password :host host :user user)))
             (key (md5 (concat user ":" pw)))
             (url (format "https://%s/api/fever.php?api&groups" host))
             (url-request-method "POST")
             (url-request-extra-headers
              '(("Content-Type" . "application/x-www-form-urlencoded")))
             (url-request-data (concat "api_key=" key))
             ;; Fever feed-id -> category name.
             (feed-category (make-hash-table :test 'eql))
             (response-buffer (url-retrieve-synchronously url t t 30)))
        (unless response-buffer
          (error "No response from %s (network failure or timeout)" host))
        ;; Every category name currently in use, as interned tag symbols --
        ;; anything in this set on an entry is a category tag eligible for
        ;; replacement (and for a color, see `my/elfeed-category-color');
        ;; anything else (unread, starred, user tags) is left alone.  This is
        ;; the persistent, shared table (not a local one) so
        ;; `my/elfeed-search-print-entry' can also consult it; clear it first
        ;; so a category removed server-side stops being treated as one.
        (clrhash my/elfeed-known-categories)
        (with-current-buffer response-buffer
          (goto-char (point-min))
          (unless (re-search-forward "\n\n" nil t)
            (error "Malformed HTTP response from %s" host))
          (let* ((json (json-parse-buffer :object-type 'alist :array-type 'list))
                 (groups (alist-get 'groups json))
                 (feeds_groups (alist-get 'feeds_groups json))
                 (group-title (make-hash-table :test 'eql)))
            (unless (eql 1 (alist-get 'auth json))
              (error "FreshRSS Fever auth failed"))
            (dolist (g groups)
              (let ((title (alist-get 'title g)))
                (puthash (alist-get 'id g) title group-title)
                (puthash (intern title) t my/elfeed-known-categories)))
            (dolist (fg feeds_groups)
              (let ((title (gethash (alist-get 'group_id fg) group-title)))
                (when title
                  (dolist (fid (split-string (alist-get 'feed_ids fg) "," t))
                    (puthash (string-to-number fid) title feed-category)))))))
        (let ((changed 0)
              ;; Local-only, same reasoning as `my/elfeed-freshrss-clear-read':
              ;; category tags aren't unread/star, so the pre-tag/pre-untag
              ;; hooks would no-op regardless, but binding nil skips the
              ;; dispatch entirely for this bulk walk.
              (elfeed-tag-hook nil)
              (elfeed-untag-hook nil))
          (with-elfeed-db-visit (entry _feed)
            (let* ((feed-id (elfeed-meta entry :feed-id))
                   (correct (and feed-id (gethash feed-id feed-category)))
                   (correct-tag (and correct (intern correct)))
                   touched)
              (when correct-tag
                ;; Always strip any *other* known-category tag, even if
                ;; correct-tag is already present -- e.g. after
                ;; `my/elfeed-dedupe-by-title' merges a stale-tagged duplicate
                ;; into a survivor that already has the right tag, both can
                ;; end up set at once.  Skipping this loop just because the
                ;; correct tag is already there (the first version of this
                ;; function did) left that combination un-healed forever.
                (dolist (tag (elfeed-entry-tags entry))
                  (when (and (not (eq tag correct-tag)) (gethash tag my/elfeed-known-categories))
                    (elfeed-untag entry tag)
                    (setq touched t)))
                (unless (elfeed-tagged-p correct-tag entry)
                  (elfeed-tag entry correct-tag)
                  (setq touched t))
                (when touched (setq changed (1+ changed))))))
          (elfeed-db-save)
          (when (get-buffer "*elfeed-search*")
            (with-current-buffer "*elfeed-search*" (elfeed-search-update :force)))
          (message "FreshRSS categories: retagged %d entries" changed)))
    (error
     (elfeed-log 'error "my/elfeed-freshrss-refresh-categories: %s" (error-message-string err))
     (when (called-interactively-p 'any)
       (message "FreshRSS categories: failed (%s) -- see *elfeed-log*"
                (error-message-string err))))))

;; Run after `my/elfeed-dedupe-by-title' on every sync (depth 90, so it always
;; lands after that hook regardless of load order), cleaning up any category
;; drift the merge step reintroduces, and picking up FreshRSS re-categorizing
;; on its own without a manual `C-c c'.
;;
;; `elfeed-update-hook' fires from inside elfeed-curl's process sentinel --
;; an async callback.  Unlike `my/elfeed-dedupe-by-title' (pure local
;; database work), this function makes a *blocking* network call
;; (`url-retrieve-synchronously'), and nesting that directly inside a
;; process-sentinel callback is a known-bad pattern: an error there
;; doesn't just print a message, it pops a `*Backtrace*' window (Emacs's
;; standard handling for unhandled errors in timers/sentinels) that stays
;; open until closed by hand.  `run-at-time 0 nil ...' defers the actual
;; call to the next event-loop tick, off the sentinel's call stack
;; entirely, while still running immediately after the sync completes.
(add-hook 'elfeed-update-hook
          (lambda (&rest _) (run-at-time 0 nil #'my/elfeed-freshrss-refresh-categories))
          90)

(use-package elfeed
  :bind ("C-c e" . elfeed)
  :config
  (define-key elfeed-search-mode-map (kbd "C-c c") #'my/elfeed-freshrss-refresh-categories)
  (defun my/elfeed-search-print-entry (entry)
    "Print ENTRY like the elfeed default, but right-align feed+tags.
The date and title stay on the left; the feed name and tag list are
pinned to the window's right edge, and the title column expands to
fill the gap between them.  Widening the frame widens the title.

Category tags (per `my/elfeed-known-categories') get their own stable
color from `my/elfeed-category-color'; any other tag (`unread', ...)
keeps the plain `elfeed-search-tag-face'."
    (let* ((date  (elfeed-search-format-date (elfeed-entry-date entry)))
           (title (or (elfeed-meta entry :title) (elfeed-entry-title entry) ""))
           (title-faces (elfeed-search--faces (elfeed-entry-tags entry)))
           (feed  (elfeed-entry-feed entry))
           (feed-title (when feed (or (elfeed-meta feed :title)
                                      (elfeed-feed-title feed))))
           (tags  (elfeed-entry-tags entry))
           (tags-str (concat "(" (mapconcat
                                  (lambda (tag)
                                    (if (gethash tag my/elfeed-known-categories)
                                        (propertize (symbol-name tag)
                                                    'face (list :foreground
                                                                (my/elfeed-category-color tag)))
                                      (propertize (symbol-name tag)
                                                  'face 'elfeed-search-tag-face)))
                                  tags ",")
                             ")"))
           (right (concat (when feed-title
                            (propertize feed-title 'face 'elfeed-search-feed-face))
                          " " tags-str))
           ;; Leave room for the date, its trailing space, the right-hand
           ;; block, and a one-column gap; floor at 16 so a narrow window
           ;; still shows something.
           (title-width (max 16 (- (window-width)
                                   (string-width date)
                                   (string-width right)
                                   3)))
           (title-column (elfeed-format-column title title-width :left)))
      (insert (propertize date 'face 'elfeed-search-date-face) " ")
      (insert (propertize title-column 'face title-faces 'kbd-help title) " ")
      (insert right)))
  (setq elfeed-search-print-entry-function #'my/elfeed-search-print-entry)
  ;; `elfeed-show' renders articles with shr; an image taller than the
  ;; window makes the default SPC/DEL (`scroll-up/down-command') jump
  ;; clear past it, so entries with big images are hard to read (see
  ;; `pixel-scroll-precision-mode' in Basic UI).  Remap paging to pixel
  ;; interpolation so SPC/DEL glide smoothly through tall images.
  (with-eval-after-load 'elfeed-show
    (define-key elfeed-show-mode-map (kbd "SPC")   #'pixel-scroll-interpolate-down)
    (define-key elfeed-show-mode-map (kbd "S-SPC") #'pixel-scroll-interpolate-up)
    (define-key elfeed-show-mode-map (kbd "DEL")   #'pixel-scroll-interpolate-up)))

(use-package elfeed-protocol
  :after elfeed
  :config
  (setq elfeed-use-curl t)
  (setq elfeed-protocol-enabled-protocols '(fever))
  ;; FreshRSS's Fever API returns microsecond-timestamp item ids, not small
  ;; sequential integers.  elfeed-protocol's default incremental `update' path
  ;; requests the next 50 *consecutive* ids after the last seen one, so that
  ;; window never matches a real item and `G' silently fetches nothing.  The
  ;; unread-only path fetches by `unread_item_ids' instead, which works with any
  ;; id format -- so keep this on for FreshRSS.
  (setq elfeed-protocol-fever-update-unread-only t)
  ;; Bring FreshRSS categories in as Elfeed tags.
  (setq elfeed-protocol-fever-fetch-category-as-tag t)
  (setq elfeed-feeds
        (list (list (format "fever+https://%s@%s" my/freshrss-user my/freshrss-host)
                    :api-url (format "https://%s/api/fever.php" my/freshrss-host)
                    ;; A function here is called fresh on every fetch
                    ;; (`elfeed-protocol-meta-password' funcalls it) rather
                    ;; than once at config-load time.  `auth-source' caches a
                    ;; decrypted ~/.authinfo.gpg indefinitely within a running
                    ;; Emacs session -- it never expires on its own -- so a
                    ;; long-lived session (days) kept authenticating with
                    ;; whatever password was cached at startup, failing with
                    ;; "wrong username or password" once the stored password
                    ;; changed, until a full restart.  Nothing else in this
                    ;; config uses auth-source, so forcing a fresh decrypt
                    ;; before every fetch (infrequent: manual `G' or the timer
                    ;; above) is free of side effects and closes that gap for
                    ;; good.
                    :password (lambda ()
                                (auth-source-forget-all-cached)
                                (auth-source-pick-first-password
                                 :host my/freshrss-host
                                 :user my/freshrss-user)))))
  ;; Reconcile read-state from the server, in the Elfeed search buffer
  ;; (see `G' for the normal incremental fetch of new entries).
  (define-key elfeed-search-mode-map (kbd "C-c E") #'my/elfeed-freshrss-clear-read)
  (elfeed-protocol-enable))
;; Configuration:1 ends here

;; [[file:config.org::*Duplicate entries from unstable guids (e.g. Stratechery)][Duplicate entries from unstable guids (e.g. Stratechery):1]]
(defun my/elfeed-dedupe-by-title (&optional _url)
  "Merge duplicate Elfeed entries sharing a feed and title, keeping the newest.
Also runs from `elfeed-update-hook', which passes the just-synced feed URL
as _URL; unused here since the whole database is rescanned regardless."
  (interactive)
  (let ((groups (make-hash-table :test 'equal))
        (removed 0))
    ;; Bucket every entry by (feed . title) -- these are the "same article,
    ;; different guid" groups we're hunting for.
    (with-elfeed-db-visit (entry feed)
      (push entry (gethash (cons (elfeed-feed-id feed) (elfeed-entry-title entry))
                            groups)))
    (maphash
     (lambda (_key entries)
       (when (> (length entries) 1)
         (let* ((newest-first (sort entries
                                    (lambda (a b) (> (elfeed-entry-date a)
                                                      (elfeed-entry-date b)))))
                (keep (car newest-first))
                (dupes (cdr newest-first)))
           ;; Carry over tags (e.g. `unread'/`starred') from the copies being
           ;; removed, so deleting them can't silently lose read-state.
           (dolist (dupe dupes)
             (apply #'elfeed-tag keep (elfeed-entry-tags dupe)))
           (elfeed-db-delete dupes)
           (setq removed (+ removed (length dupes))))))
     groups)
    (elfeed-db-save)
    (when (get-buffer "*elfeed-search*")
      (with-current-buffer "*elfeed-search*" (elfeed-search-update :force)))
    (when (called-interactively-p 'any)
      (message "Elfeed: merged %d duplicate entr%s" removed (if (= removed 1) "y" "ies")))
    removed))

(add-hook 'elfeed-update-hook #'my/elfeed-dedupe-by-title)
;; Duplicate entries from unstable guids (e.g. Stratechery):1 ends here

;; [[file:config.org::*Web Browsing (eww)][Web Browsing (eww):1]]
(use-package shr
  :ensure nil
  :config
  (setq shr-use-colors nil
        shr-max-width 90
        shr-max-image-proportion 0.6))

(use-package eww
  :ensure nil
  :config
  ;; Add URL regexps here to auto-apply `eww-readable' on sites read often,
  ;; e.g. '("nytimes\\.com/" "apnews\\.com/").
  (setq eww-readable-urls nil))
;; Web Browsing (eww):1 ends here

;; [[file:config.org::*Nicer rendering, readable Org, and a real browser][Nicer rendering, readable Org, and a real browser:1]]
(use-package shrface
  :after shr
  :config
  (shrface-basic)
  (shrface-trial)
  (setq shrface-href-versatile t)
  (add-hook 'eww-after-render-hook #'shrface-mode))

(use-package org-web-tools
  :commands (org-web-tools-read-url-as-org org-web-tools-insert-link-for-url))

;; `org-web-tools-read-url-as-org' takes the URL silently from the
;; clipboard/kill-ring and never prompts.  This wrapper always asks, with any
;; copied URL pre-filled as the default -- so `C-c u' works whether or not I
;; copied a link first.
(defun my/read-url-as-org (url)
  "Read URL as a clean Org buffer, prompting (default: clipboard/kill-ring URL)."
  (interactive (progn (require 'org-web-tools)
                      (list (read-string "URL: " (org-web-tools--get-first-url)))))
  (org-web-tools-read-url-as-org url))
(global-set-key (kbd "C-c u") #'my/read-url-as-org)

;; A real WebKit view for pages eww can't handle (needs --with-xwidgets).
(defun my/eww-open-in-xwidget ()
  "Reopen the current eww page in an embedded WebKit (xwidget) view."
  (interactive)
  (let ((url (eww-current-url)))
    (unless url (user-error "No current eww URL"))
    (xwidget-webkit-browse-url url)))
(with-eval-after-load 'eww
  (define-key eww-mode-map (kbd "W") #'my/eww-open-in-xwidget))
;; Nicer rendering, readable Org, and a real browser:1 ends here

;; [[file:config.org::*Org & Agenda][Org & Agenda:1]]
(use-package org
  :ensure nil
  :bind ("C-c a" . org-agenda)
  :config
  (setq org-directory "~/org")
  (setq org-agenda-files
        (list org-directory
              (expand-file-name "calendars" org-directory)))
  ;; Open the agenda on a 2-day view (today + tomorrow); `w'/`d'/etc. in the
  ;; agenda still switch spans on the fly.
  (setq org-agenda-span 2))
;; Org & Agenda:1 ends here

;; [[file:config.org::*External calendars (read-only: Outlook + iCloud)][External calendars (read-only: Outlook + iCloud):1]]
(defvar my/calendar-sync-script "~/.config/vdirsyncer/sync-calendars.sh"
  "Script that syncs external calendars and regenerates ~/org/calendars/*.org.")

(defun my/calendar-sync ()
  "Refresh the external-calendar mirrors in the background, then rebuild an
open agenda so new events appear.  The sync script runs detached, so Emacs
never blocks on the network."
  (interactive)
  (let ((script (expand-file-name my/calendar-sync-script)))
    (when (file-exists-p script)
      (make-process
       :name "calendar-sync" :buffer nil :noquery t
       :command (list script)
       :sentinel
       (lambda (_proc event)
         (when (string-prefix-p "finished" event)
           ;; Revert any (unmodified) calendar buffers, then redo an open agenda.
           (dolist (b (buffer-list))
             (when (and (buffer-file-name b)
                        (string-prefix-p (expand-file-name "~/org/calendars/")
                                         (buffer-file-name b))
                        (not (buffer-modified-p b)))
               (with-current-buffer b (revert-buffer t t t))))
           (let ((buf (get-buffer "*Org Agenda*")))
             (when (buffer-live-p buf)
               (with-current-buffer buf
                 (when (derived-mode-p 'org-agenda-mode)
                   (org-agenda-redo t)))))))))))

(defvar my/calendar-sync-timer nil
  "Repeating timer that drives `my/calendar-sync'.")
(when (timerp my/calendar-sync-timer) (cancel-timer my/calendar-sync-timer))
(setq my/calendar-sync-timer (run-with-timer 30 1800 #'my/calendar-sync))
;; External calendars (read-only: Outlook + iCloud):1 ends here
