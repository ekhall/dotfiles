;;; logic-dark-theme.el --- Dark theme after Apple pro-tool UIs -*- lexical-binding: t; -*-

;;; Commentary:

;; A dark theme whose neutral palette is sampled from Apple's
;; professional creative tools (Logic Pro X in particular): layered
;; dark and light grays for structure, near-white text, and a small
;; set of saturated accents used only where meaning warrants it --
;; the same restraint those apps show, where color marks tracks,
;; meters, and controls rather than coating the whole chrome.
;;
;; The accent hues (blue, teal, green, gold, magenta, cyan, red) are
;; taken directly from Logic's track colors and transport, then nudged
;; a little brighter so they stay legible as syntax on gray.
;;
;; This theme sets COLORS ONLY. It never touches font family, height,
;; or weight, so the per-machine font choices in your config carry
;; through unchanged.

;;; Code:

(deftheme logic-dark
  "Dark gray theme with Logic-Pro-style accent colors, font-agnostic.")

(let ((class '((class color) (min-colors 89)))
      ;; --- Neutral ramp (dark -> light) ------------------------------
      (bg0   "#262626")   ; darkest: fringe, inactive mode-line
      (bg1   "#2f2f2f")   ; default background (main editing surface)
      (bg2   "#383838")   ; hl-line / current line / subtle panels
      (bg3   "#454545")   ; secondary panels, inactive selection
      (bg4   "#5a5a5a")   ; mode-line, borders, chrome
      (bg5   "#6e6e6e")   ; lightest gray chrome / raised controls
      (sel   "#2e4c6b")   ; region — desaturated Logic selection blue
      (sel-d "#24506e")   ; secondary selection
      ;; --- Foreground ramp -------------------------------------------
      (fg-hi "#ffffff")   ; emphasized text
      (fg    "#e8e8e8")   ; default text
      (fg-d  "#9a9a9a")   ; secondary text, line numbers
      (fg-m  "#6f6f6f")   ; comments, muted chrome
      ;; --- Accents (from Logic track colors + transport) -------------
      (blue    "#5e8fd9")
      (teal    "#3fb0b4")
      (green   "#82b944")
      (gold    "#d0a63c")
      (orange  "#e0913a")
      (magenta "#c264be")
      (cyan    "#6fc4e8")
      (red     "#e05561")   ; error text (softer than the record red)
      (rec-red "#d01c2b"))  ; transport-record red: urgent accents

  (custom-theme-set-faces
   'logic-dark

   ;; ---- Baseline ------------------------------------------------------
   `(default             ((,class (:background ,bg1 :foreground ,fg))))
   `(cursor              ((,class (:background ,cyan))))
   `(fringe              ((,class (:background ,bg1 :foreground ,fg-m))))
   `(border              ((,class (:background ,bg0))))
   `(vertical-border     ((,class (:foreground ,bg0))))
   `(window-divider      ((,class (:foreground ,bg0))))
   `(window-divider-first-pixel ((,class (:foreground ,bg0))))
   `(window-divider-last-pixel  ((,class (:foreground ,bg0))))
   `(shadow              ((,class (:foreground ,fg-m))))
   `(link                ((,class (:foreground ,cyan :underline t))))
   `(link-visited        ((,class (:foreground ,magenta :underline t))))
   `(success             ((,class (:foreground ,green))))
   `(warning             ((,class (:foreground ,gold))))
   `(error               ((,class (:foreground ,red :weight bold))))
   `(escape-glyph        ((,class (:foreground ,orange))))
   `(minibuffer-prompt   ((,class (:foreground ,teal :weight bold))))
   `(highlight           ((,class (:background ,bg3 :foreground ,fg-hi))))
   `(region              ((,class (:background ,sel :extend t))))
   `(secondary-selection ((,class (:background ,sel-d :extend t))))
   `(hl-line             ((,class (:background ,bg2 :extend t))))
   `(fill-column-indicator ((,class (:foreground ,bg2))))
   `(match               ((,class (:background ,gold :foreground ,bg0))))
   `(trailing-whitespace ((,class (:background ,rec-red))))
   `(lazy-highlight      ((,class (:background ,bg4 :foreground ,fg-hi))))

   ;; ---- Line numbers --------------------------------------------------
   `(line-number              ((,class (:background ,bg1 :foreground ,fg-m))))
   `(line-number-current-line ((,class (:background ,bg2 :foreground ,fg :weight bold))))

   ;; ---- Font lock (syntax = Logic track hues) -------------------------
   `(font-lock-comment-face              ((,class (:foreground ,fg-m :slant italic))))
   `(font-lock-comment-delimiter-face    ((,class (:foreground ,fg-m))))
   `(font-lock-doc-face                  ((,class (:foreground ,fg-d :slant italic))))
   `(font-lock-string-face               ((,class (:foreground ,green))))
   `(font-lock-keyword-face              ((,class (:foreground ,blue :weight bold))))
   `(font-lock-builtin-face              ((,class (:foreground ,cyan))))
   `(font-lock-function-name-face        ((,class (:foreground ,teal))))
   `(font-lock-variable-name-face        ((,class (:foreground ,fg))))
   `(font-lock-type-face                 ((,class (:foreground ,gold))))
   `(font-lock-constant-face             ((,class (:foreground ,magenta))))
   `(font-lock-number-face               ((,class (:foreground ,magenta))))
   `(font-lock-preprocessor-face         ((,class (:foreground ,orange))))
   `(font-lock-negation-char-face        ((,class (:foreground ,orange))))
   `(font-lock-warning-face              ((,class (:foreground ,gold :weight bold))))
   `(font-lock-regexp-grouping-backslash ((,class (:foreground ,orange))))
   `(font-lock-regexp-grouping-construct ((,class (:foreground ,gold))))

   ;; ---- Mode line (light-gray Logic chrome) --------------------------
   `(mode-line           ((,class (:background ,bg4 :foreground ,fg-hi
                                   :box (:line-width 1 :color ,bg5)))))
   `(mode-line-active    ((,class (:background ,bg4 :foreground ,fg-hi
                                   :box (:line-width 1 :color ,bg5)))))
   `(mode-line-inactive  ((,class (:background ,bg0 :foreground ,fg-m
                                   :box (:line-width 1 :color ,bg0)))))
   `(mode-line-highlight ((,class (:background ,bg5 :foreground ,fg-hi))))
   `(mode-line-buffer-id ((,class (:foreground ,fg-hi :weight bold))))

   ;; mood-line (your mode line) status segments
   `(mood-line-status-info    ((,class (:foreground ,cyan))))
   `(mood-line-status-success ((,class (:foreground ,green))))
   `(mood-line-status-warning ((,class (:foreground ,gold))))
   `(mood-line-status-error   ((,class (:foreground ,red))))
   `(mood-line-status-neutral ((,class (:foreground ,fg-d))))
   `(mood-line-unimportant    ((,class (:foreground ,fg-m))))
   `(mood-line-modified       ((,class (:foreground ,gold))))

   ;; ---- Search --------------------------------------------------------
   `(isearch            ((,class (:background ,gold :foreground ,bg0 :weight bold))))
   `(isearch-fail       ((,class (:background ,rec-red :foreground ,fg-hi))))

   ;; ---- Parens / delimiters ------------------------------------------
   `(show-paren-match          ((,class (:background ,teal :foreground ,bg0 :weight bold))))
   `(show-paren-mismatch       ((,class (:background ,rec-red :foreground ,fg-hi :weight bold))))
   `(rainbow-delimiters-depth-1-face ((,class (:foreground ,blue))))
   `(rainbow-delimiters-depth-2-face ((,class (:foreground ,teal))))
   `(rainbow-delimiters-depth-3-face ((,class (:foreground ,gold))))
   `(rainbow-delimiters-depth-4-face ((,class (:foreground ,magenta))))
   `(rainbow-delimiters-depth-5-face ((,class (:foreground ,green))))
   `(rainbow-delimiters-depth-6-face ((,class (:foreground ,cyan))))
   `(rainbow-delimiters-depth-7-face ((,class (:foreground ,orange))))
   `(rainbow-delimiters-unmatched-face ((,class (:foreground ,rec-red :weight bold))))

   ;; ---- Completion: vertico / marginalia / orderless / corfu ---------
   `(vertico-current      ((,class (:background ,sel :extend t))))
   `(completions-common-part      ((,class (:foreground ,cyan :weight bold))))
   `(completions-first-difference ((,class (:foreground ,gold))))
   `(completions-annotations      ((,class (:foreground ,fg-d :slant italic))))
   `(marginalia-key       ((,class (:foreground ,teal))))
   `(marginalia-documentation ((,class (:foreground ,fg-d :slant italic))))
   `(orderless-match-face-0 ((,class (:foreground ,blue :weight bold))))
   `(orderless-match-face-1 ((,class (:foreground ,magenta :weight bold))))
   `(orderless-match-face-2 ((,class (:foreground ,green :weight bold))))
   `(orderless-match-face-3 ((,class (:foreground ,gold :weight bold))))
   `(corfu-default        ((,class (:background ,bg2 :foreground ,fg))))
   `(corfu-current        ((,class (:background ,sel :foreground ,fg-hi))))
   `(corfu-border         ((,class (:background ,bg4))))
   `(corfu-bar            ((,class (:background ,bg5))))
   `(company-tooltip            ((,class (:background ,bg2 :foreground ,fg))))
   `(company-tooltip-selection  ((,class (:background ,sel :foreground ,fg-hi))))
   `(company-tooltip-common     ((,class (:foreground ,cyan :weight bold))))
   `(company-scrollbar-bg       ((,class (:background ,bg3))))
   `(company-scrollbar-fg       ((,class (:background ,bg5))))

   ;; ---- Tabs / headers ------------------------------------------------
   `(tab-bar              ((,class (:background ,bg0 :foreground ,fg-d))))
   `(tab-bar-tab          ((,class (:background ,bg2 :foreground ,fg-hi
                                    :box (:line-width 2 :color ,bg2)))))
   `(tab-bar-tab-inactive ((,class (:background ,bg0 :foreground ,fg-m
                                    :box (:line-width 2 :color ,bg0)))))
   `(header-line          ((,class (:background ,bg3 :foreground ,fg))))
   `(tab-line             ((,class (:background ,bg0 :foreground ,fg-d))))

   ;; ---- Org -----------------------------------------------------------
   `(org-document-title  ((,class (:foreground ,fg-hi :weight bold))))
   `(org-document-info   ((,class (:foreground ,fg-d))))
   `(org-level-1         ((,class (:foreground ,blue :weight bold))))
   `(org-level-2         ((,class (:foreground ,teal :weight bold))))
   `(org-level-3         ((,class (:foreground ,green))))
   `(org-level-4         ((,class (:foreground ,gold))))
   `(org-level-5         ((,class (:foreground ,magenta))))
   `(org-level-6         ((,class (:foreground ,cyan))))
   `(org-level-7         ((,class (:foreground ,orange))))
   `(org-level-8         ((,class (:foreground ,fg-d))))
   `(org-link            ((,class (:foreground ,cyan :underline t))))
   `(org-block           ((,class (:background ,bg2 :extend t))))
   `(org-block-begin-line ((,class (:background ,bg2 :foreground ,fg-m :extend t))))
   `(org-block-end-line  ((,class (:background ,bg2 :foreground ,fg-m :extend t))))
   `(org-code            ((,class (:foreground ,gold :background ,bg2))))
   `(org-verbatim        ((,class (:foreground ,green :background ,bg2))))
   `(org-table           ((,class (:foreground ,fg-d :background ,bg2))))
   `(org-quote           ((,class (:foreground ,fg-d :slant italic :extend t))))
   `(org-todo            ((,class (:foreground ,rec-red :weight bold))))
   `(org-done            ((,class (:foreground ,green :weight bold))))
   `(org-headline-done   ((,class (:foreground ,fg-m))))
   `(org-date            ((,class (:foreground ,teal :underline t))))
   `(org-special-keyword ((,class (:foreground ,fg-m))))
   `(org-drawer          ((,class (:foreground ,fg-m))))
   `(org-agenda-structure ((,class (:foreground ,blue :weight bold))))
   `(org-agenda-date-today ((,class (:foreground ,gold :weight bold))))
   `(org-scheduled       ((,class (:foreground ,green))))
   `(org-scheduled-today ((,class (:foreground ,green :weight bold))))
   `(org-warning         ((,class (:foreground ,gold :weight bold))))

   ;; ---- Diff / magit / VC --------------------------------------------
   `(diff-added          ((,class (:background "#28351f" :foreground ,green :extend t))))
   `(diff-removed        ((,class (:background "#3a2124" :foreground ,red :extend t))))
   `(diff-changed        ((,class (:background "#332f1f" :foreground ,gold :extend t))))
   `(diff-header         ((,class (:background ,bg2 :foreground ,fg))))
   `(diff-file-header    ((,class (:foreground ,fg-hi :weight bold))))
   `(diff-hunk-header    ((,class (:background ,bg2 :foreground ,teal))))
   `(magit-section-heading   ((,class (:foreground ,gold :weight bold))))
   `(magit-section-highlight ((,class (:background ,bg2 :extend t))))
   `(magit-branch-local  ((,class (:foreground ,cyan))))
   `(magit-branch-remote ((,class (:foreground ,green))))
   `(magit-diff-added         ((,class (:background "#28351f" :foreground ,green :extend t))))
   `(magit-diff-added-highlight ((,class (:background "#31411f" :foreground ,green :extend t))))
   `(magit-diff-removed       ((,class (:background "#3a2124" :foreground ,red :extend t))))
   `(magit-diff-removed-highlight ((,class (:background "#48282c" :foreground ,red :extend t))))
   `(magit-diff-context-highlight ((,class (:background ,bg2 :foreground ,fg-d :extend t))))
   `(magit-diff-hunk-heading  ((,class (:background ,bg3 :foreground ,fg-d :extend t))))
   `(magit-diff-hunk-heading-highlight ((,class (:background ,bg4 :foreground ,fg-hi :extend t))))
   `(magit-hash          ((,class (:foreground ,fg-m))))
   `(magit-log-author    ((,class (:foreground ,teal))))

   ;; ---- Flymake / flycheck -------------------------------------------
   `(flymake-error    ((,class (:underline (:style wave :color ,red)))))
   `(flymake-warning  ((,class (:underline (:style wave :color ,gold)))))
   `(flymake-note     ((,class (:underline (:style wave :color ,teal)))))
   `(flycheck-error   ((,class (:underline (:style wave :color ,red)))))
   `(flycheck-warning ((,class (:underline (:style wave :color ,gold)))))
   `(flycheck-info    ((,class (:underline (:style wave :color ,teal)))))

   ;; ---- Dired ---------------------------------------------------------
   `(dired-directory ((,class (:foreground ,blue :weight bold))))
   `(dired-symlink   ((,class (:foreground ,cyan))))
   `(dired-header    ((,class (:foreground ,gold :weight bold))))
   `(dired-flagged   ((,class (:foreground ,rec-red :weight bold))))
   `(dired-marked    ((,class (:foreground ,gold :weight bold))))

   ;; ---- Notmuch (your mail) ------------------------------------------
   `(notmuch-search-unread-face      ((,class (:foreground ,fg-hi :weight bold))))
   `(notmuch-search-flagged-face     ((,class (:foreground ,gold))))
   `(notmuch-search-date             ((,class (:foreground ,teal))))
   `(notmuch-search-count            ((,class (:foreground ,fg-m))))
   `(notmuch-search-subject          ((,class (:foreground ,fg))))
   `(notmuch-search-matching-authors ((,class (:foreground ,cyan))))
   `(notmuch-tag-face                ((,class (:foreground ,green))))
   `(notmuch-tag-unread              ((,class (:foreground ,gold))))
   `(notmuch-tag-flagged             ((,class (:foreground ,rec-red))))
   `(notmuch-message-summary-face    ((,class (:background ,bg2 :foreground ,fg-hi :extend t))))
   `(notmuch-wash-cited-text         ((,class (:foreground ,fg-d))))
   `(notmuch-crypto-signature-good   ((,class (:foreground ,green))))

   ;; ---- Elfeed (your reader) -----------------------------------------
   `(elfeed-search-date-face        ((,class (:foreground ,teal))))
   `(elfeed-search-title-face       ((,class (:foreground ,fg-m))))
   `(elfeed-search-unread-title-face ((,class (:foreground ,fg-hi :weight bold))))
   `(elfeed-search-feed-face        ((,class (:foreground ,gold))))
   `(elfeed-search-tag-face         ((,class (:foreground ,green))))

   ;; ---- Misc UI -------------------------------------------------------
   `(widget-field       ((,class (:background ,bg3 :foreground ,fg))))
   `(button             ((,class (:foreground ,cyan :underline t))))
   `(custom-button      ((,class (:background ,bg3 :foreground ,fg :box (:line-width 1 :color ,bg5)))))
   `(help-key-binding   ((,class (:background ,bg2 :foreground ,gold))))
   `(tooltip            ((,class (:background ,bg3 :foreground ,fg))))
   `(compilation-mode-line-fail ((,class (:foreground ,red :weight bold))))
   `(compilation-mode-line-run  ((,class (:foreground ,gold))))
   `(compilation-mode-line-exit ((,class (:foreground ,green :weight bold))))
   `(ansi-color-black   ((,class (:foreground ,bg0 :background ,bg0))))
   `(ansi-color-red     ((,class (:foreground ,red :background ,red))))
   `(ansi-color-green   ((,class (:foreground ,green :background ,green))))
   `(ansi-color-yellow  ((,class (:foreground ,gold :background ,gold))))
   `(ansi-color-blue    ((,class (:foreground ,blue :background ,blue))))
   `(ansi-color-magenta ((,class (:foreground ,magenta :background ,magenta))))
   `(ansi-color-cyan    ((,class (:foreground ,cyan :background ,cyan))))
   `(ansi-color-white   ((,class (:foreground ,fg :background ,fg)))))

  ;; Non-face variables Emacs reads for frame chrome and hl palettes.
  (custom-theme-set-variables
   'logic-dark
   `(ansi-color-names-vector [,bg0 ,red ,green ,gold ,blue ,magenta ,cyan ,fg])))

;;;###autoload
(when (and (boundp 'custom-theme-load-path) load-file-name)
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'logic-dark)

;;; logic-dark-theme.el ends here
