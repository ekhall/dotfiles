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
;; is in place; logic-dark is a plain deftheme, not a doom theme.
(load-theme 'logic-dark t)

(defvar my/theme-toggle-list '(logic-dark doom-tomorrow-day)
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
(defconst my/freshrss-host "100.121.73.82"
  "Host/IP of the FreshRSS instance, as reached over Tailscale.")

(defconst my/freshrss-user "hall"
  "FreshRSS account name, used for the Fever URL and auth-source lookup.")

(defun my/elfeed-freshrss-clear-read ()
  "Mirror FreshRSS read/unread state onto already-downloaded Elfeed entries.
elfeed-protocol's Fever sync only applies read-state to entries it
*fetches*, and `G' fetches only new ids -- so articles read on
another device keep a stale `unread' tag here, and
`elfeed-protocol-fever-reinit' does not fix it either.

This fetches the Fever `unread_item_ids' set directly and, for
every local entry carrying a Fever id, adds or removes the
`unread' tag to match the server -- locally only, via
`elfeed-tag-1'/`elfeed-untag-1', so nothing is pushed back.  The
Fever api_key is md5(user:password); the password comes from
auth-source, never from this file."
  (interactive)
  (let* ((host my/freshrss-host) (user my/freshrss-user)
         (pw (auth-source-pick-first-password :host host :user user))
         (key (md5 (concat user ":" pw)))
         (url (format "http://%s/api/fever.php?api&unread_item_ids" host))
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
    (let ((cleared 0) (marked 0))
      (with-elfeed-db-visit (entry _feed)
        (let ((id (elfeed-meta entry :id)))
          (when id
            (if (gethash id unread-set)
                (unless (elfeed-tagged-p 'unread entry)
                  (elfeed-tag-1 entry 'unread) (setq marked (1+ marked)))
              (when (elfeed-tagged-p 'unread entry)
                (elfeed-untag-1 entry 'unread) (setq cleared (1+ cleared)))))))
      (elfeed-db-save)
      (when (get-buffer "*elfeed-search*")
        (with-current-buffer "*elfeed-search*" (elfeed-search-update :force)))
      (message "FreshRSS reconcile: cleared %d read, marked %d unread; %d unread on server"
               cleared marked (hash-table-count unread-set)))))

(use-package elfeed
  :bind ("C-c e" . elfeed)
  :config
  (defun my/elfeed-search-print-entry (entry)
    "Print ENTRY like the elfeed default, but right-align feed+tags.
The date and title stay on the left; the feed name and tag list are
pinned to the window's right edge, and the title column expands to
fill the gap between them.  Widening the frame widens the title."
    (let* ((date  (elfeed-search-format-date (elfeed-entry-date entry)))
           (title (or (elfeed-meta entry :title) (elfeed-entry-title entry) ""))
           (title-faces (elfeed-search--faces (elfeed-entry-tags entry)))
           (feed  (elfeed-entry-feed entry))
           (feed-title (when feed (or (elfeed-meta feed :title)
                                      (elfeed-feed-title feed))))
           (tags  (mapcar #'symbol-name (elfeed-entry-tags entry)))
           (tags-str (concat "(" (mapconcat
                                  (lambda (s) (propertize s 'face 'elfeed-search-tag-face))
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
        (list (list (format "fever+http://%s@%s" my/freshrss-user my/freshrss-host)
                    :api-url (format "http://%s/api/fever.php" my/freshrss-host)
                    :password (auth-source-pick-first-password
                               :host my/freshrss-host
                               :user my/freshrss-user))))
  ;; Reconcile read-state from the server, in the Elfeed search buffer
  ;; (see `G' for the normal incremental fetch of new entries).
  (define-key elfeed-search-mode-map (kbd "C-c E") #'my/elfeed-freshrss-clear-read)
  (elfeed-protocol-enable))
;; Configuration:1 ends here

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
