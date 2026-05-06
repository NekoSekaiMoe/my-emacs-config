;;; nano-keys.el --- Nano-style keybindings, theme & status bar -*- lexical-binding: t; -*-

;; Copyright (C) 2024
;; Author: nano-keys contributors
;; Version: 0.3.0
;; Package-Requires: ((emacs "27.1"))
;; Keywords: convenience, nano, faces
;; URL: https://github.com/nano-keys/nano-keys

;;; Commentary:
;;
;; Three independent minor modes that faithfully replicate the nano editor:
;;
;;   nano-keys-mode          — nano keyboard shortcuts
;;   nano-keys-theme-mode    — nano default syntax highlighting colours
;;   nano-keys-statusbar-mode — nano two-line bottom title bar
;;
;; For per-language nano-style syntax highlighting (20+ languages), load
;; the separate module:
;;   nano-keys-lang-mode     — nano nanorc rules for each language
;;   nano-keys-lsp-mode      — LSP integration with nano keybindings
;;
;; Usage:
;;   (require 'nano-keys)
;;   (require 'nano-keys-lang)   ; optional: per-language highlighting
;;   (nano-keys-mode 1)
;;   (nano-keys-theme-mode 1)
;;   (nano-keys-statusbar-mode 1)
;;   (nano-keys-lang-mode 1)     ; optional

;;; Code:

;; ============================================================
;; Customization
;; ============================================================
(defgroup nano-keys nil
  "Nano-style keybindings, theme, and UI for Emacs."
  :group 'convenience
  :prefix "nano-keys-")

(defcustom nano-keys-enable-on-load nil
  "When non-nil, automatically enable `nano-keys-mode' when the package is loaded."
  :type 'boolean
  :group 'nano-keys)


;; ============================================================
;; 1. Nano keybindings
;; ============================================================

(defvar nano-keys--bindings
  '(("C-g"  "Help"             . nano-keys-help)
    ("C-o"  "Write Out"        . save-buffer)
    ("C-r"  "Read File"        . find-file)
    ("C-y"  "Page Up"          . scroll-down-command)
    ("C-v"  "Page Down"        . scroll-up-command)
    ("C-k"  "Cut Line"         . nano-keys-cut-line)
    ("C-u"  "Uncut"            . nano-keys-uncut)
    ("C-w"  "Where Is"         . isearch-forward)
    ("C-q"  "Replace"          . query-replace)
    ("C-t"  "To Spell"         . ispell-buffer)
    ("C-c"  "Cur Pos"          . nano-keys-show-cursor-pos)
    ("C-j"  "Justify"          . fill-paragraph)
    ("C-\\" "Replace (again)"  . query-replace)
    ("C-s"  "Save"             . save-buffer)
    ("C-x"  "Exit"             . nano-keys-exit)
    ("C-h"  "Backspace"        . backward-delete-char-untabify)
    ("C-d"  "Delete"           . delete-char)
    ("C-a"  "Line Start"        . move-beginning-of-line)
    ("C-e"  "Line End"          . move-end-of-line)
    ("C-l"  "Refresh"          . recenter-top-bottom)
    ("C-z"  "Suspend"          . suspend-frame)
    ("C-b"  "Back Char"        . backward-char)
    ("C-f"  "Forward Char"     . forward-char)
    ("C-p"  "Prev Line"        . previous-line)
    ("C-n"  "Next Line"        . next-line)
    ("M-w"  "Where Is Next"    . isearch-forward)
    ("M-u"  "Undo"             . undo)
    ("M-e"  "Redo"             . repeat-complex-command)
    ("M-a"  "Mark Text"        . set-mark-command)
    ("M-6"  "Copy"             . kill-ring-save)
    ("M-}" "Indent"            . indent-for-tab-command)
    ("M-{" "Unindent"          . nano-keys-unindent)
    ("C-_" "Go To Line"        . goto-line)
    ("C-|" "Go To Line (alt)"  . goto-line))
  "List of nano-style keybindings: (KEY DESCRIPTION . COMMAND).")

(defvar nano-keys--cut-stack nil
  "Stack of killed text for nano-style cut-line / uncut.")

(defun nano-keys-cut-line ()
  "Cut the entire line (like nano's Ctrl+K)."
  (interactive)
  (let ((beg (point))
        (end (line-end-position)))
    (if (and (= beg end) (< (point) (point-max)))
        (progn
          (push (buffer-substring-no-properties beg (1+ end)) nano-keys--cut-stack)
          (delete-region beg (min (1+ end) (point-max))))
      (when (> end beg)
        (push (buffer-substring-no-properties beg end) nano-keys--cut-stack)
        (delete-region beg end))))
  (message "Cut line"))

(defun nano-keys-uncut ()
  "Insert the last cut line at point (like nano's Ctrl+U)."
  (interactive)
  (if nano-keys--cut-stack
      (let ((text (pop nano-keys--cut-stack)))
        (insert text)
        (message "Uncut: inserted text"))
    (message "Nothing to uncut")))

(defun nano-keys-unindent ()
  "Remove one level of indentation from the current line."
  (interactive)
  (save-excursion
    (back-to-indentation)
    (let ((col (current-column)))
      (when (> col 0)
        (beginning-of-line)
        (delete-region (point) (min (+ (point) tab-width) (line-end-position)))))))

(defun nano-keys-show-cursor-pos ()
  "Show current line and column (like nano's Ctrl+C)."
  (interactive)
  (let ((line (line-number-at-pos))
        (col  (current-column))
        (total (count-lines (point-min) (point-max)))
        (pos  (point))
        (size (buffer-size)))
    (message "Line %d/%d, Column %d, Char %d/%d"
             line total col pos size)))

(defun nano-keys-exit ()
  "Save modified buffers and kill Emacs (like nano's Ctrl+X)."
  (interactive)
  (if (frame-parameter nil 'client)
      (save-buffers-kill-emacs)
    (if (buffer-modified-p)
        (when (y-or-n-p (format "Save buffer %s? " (buffer-name)))
          (save-buffer)
          (kill-emacs))
      (if (one-window-p)
          (kill-emacs)
        (delete-window)))))

(defun nano-keys-help ()
  "Show nano-style help overlay."
  (interactive)
  (with-output-to-temp-buffer "*nano-keys-help*"
    (princ "╔══════════════════════════════════════════════════════════╗\n")
    (princ "║               Nano-Keys Help (Emacs)                    ║\n")
    (princ "╠══════════════════════════════════════════════════════════╣\n")
    (dolist (entry nano-keys--bindings)
      (let ((key  (nth 0 entry))
            (desc (nth 1 entry)))
        (princ (format "║  %-6s  %-45s ║\n" key desc))))
    (princ "╚══════════════════════════════════════════════════════════╝\n"))
  (fit-window-to-buffer (get-buffer-window "*nano-keys-help*")))

(defvar nano-keys-mode-map
  (let ((map (make-sparse-keymap)))
    (dolist (entry nano-keys--bindings)
      (let ((key (kbd (nth 0 entry)))
            (cmd (nth 2 entry)))
        (when cmd
          (define-key map key cmd))))
    map)
  "Keymap for `nano-keys-mode'.")

;;;###autoload
(define-minor-mode nano-keys-mode
  "Toggle Nano-Keys keybindings."
  :global t
  :lighter " Nano"
  :keymap nano-keys-mode-map
  (if nano-keys-mode
      (message "Nano-Keys mode enabled. Press C-g for help.")
    (message "Nano-Keys mode disabled.")))


;; ============================================================
;; 2. Nano syntax highlighting theme
;; ============================================================
;;
;; Colours extracted from nano's default nanorc syntax files:
;;   brightred     — types / built-in types
;;   green         — control-flow keywords (for, if, while, else…)
;;   brightmagenta — flow control (return, break, continue, goto)
;;   brightcyan    — preprocessor directives (#include, #define…)
;;   yellow        — strings & characters
;;   brightblue    — comments
;;   cyan          — built-in functions / constants (None, True, self)
;;   brightyellow  — numbers
;;   magenta       — operators & parentheses
;;   brightgreen   — decorators / special (TODO, FIXME)
;;   white         — foreground
;;   black         ─ background
;;
;; Nano uses a white-on-black terminal palette.  The default
;; "bright" colours in nano's terminal palette map to:
;;   brightred     = #ff0000
;;   brightgreen   = #00ff00
;;   brightyellow  = #ffff00
;;   brightblue    = #5c5cff
;;   brightmagenta = #ff00ff
;;   brightcyan    = #00ffff
;;   brightwhite   = #ffffff
;; Non-bright:
;;   red     = #aa0000
;;   green   = #00aa00
;;   yellow  = #aa5500
;;   blue    = #0000aa
;;   magenta = #aa00aa
;;   cyan    = #00aaaa
;;   white   = #aaaaaa
;;   black   = #000000
;; ============================================================

(deftheme nano-keys-nano
  "Syntax highlighting theme replicating nano's default colours.

Based on the actual colour rules from nano's nanorc syntax files.
Terminal-style bright colours on a dark background:

  Types       — bright red       (#ff0000)
  Keywords    — green            (#00aa00)
  Flow ctrl   — bright magenta  (#ff00ff)
  Preprocessor— bright cyan      (#00ffff)
  Strings     — yellow           (#aa5500)
  Comments    — bright blue      (#5c5cff)
  Builtins    — cyan             (#00aaaa)
  Numbers     — bright yellow    (#ffff00)
  Operators   — magenta          (#aa00aa)
  Decorators  — bright green     (#00ff00)")

(let ((n-bg         "#000000")
      (n-fg         "#aaaaaa")
      (n-fg-bright  "#ffffff")
      (n-cursor     "#00ff00")
      (n-black      "#000000")
      (n-red        "#aa0000")
      (n-green      "#00aa00")
      (n-yellow     "#aa5500")
      (n-blue       "#0000aa")
      (n-magenta    "#aa00aa")
      (n-cyan       "#00aaaa")
      (n-white      "#aaaaaa")
      (n-brightred     "#ff0000")
      (n-brightgreen   "#00ff00")
      (n-brightyellow  "#ffff00")
      (n-brightblue    "#5c5cff")
      (n-brightmagenta "#ff00ff")
      (n-brightcyan    "#00ffff")
      (n-brightwhite   "#ffffff")
      ;; nano title bar: white on blue
      (n-title-fg   "#ffffff")
      (n-title-bg   "#0000aa")
      ;; nano status bar / shortcut bar: white on blue
      (n-bar-fg     "#ffffff")
      (n-bar-bg     "#0000aa")
      ;; nano selected text
      (n-sel-fg     "#000000")
      (n-sel-bg     "#5c5cff")
      ;; nano error colour
      (n-error-fg   "#ffffff")
      (n-error-bg   "#ff0000"))

  (custom-theme-set-faces
   'nano-keys-nano

   ;; ── Base ──────────────────────────────────────────────
   `(default                    ((t (:background ,n-bg :foreground ,n-fg))))
   `(cursor                     ((t (:background ,n-cursor))))
   `(region                     ((t (:background ,n-sel-bg :foreground ,n-sel-fg))))
   `(hl-line                    ((t (:background "#0a0a0a"))))
   `(fringe                     ((t (:background ,n-bg :foreground ,n-white))))
   `(vertical-border            ((t (:foreground ,n-blue))))
   `(minibuffer-prompt          ((t (:foreground ,n-brightcyan :bold t))))
   `(link                       ((t (:foreground ,n-brightcyan :underline t))))
   `(escape-glyph               ((t (:foreground ,n-blue))))
   `(shadow                     ((t (:foreground ,n-white))))
   `(success                    ((t (:foreground ,n-green :bold t))))
   `(warning                    ((t (:foreground ,n-yellow :bold t))))
   `(error                      ((t (:foreground ,n-brightred :bold t))))

   ;; ── Font-lock (syntax) ───────────────────────────────
   ;; Types → brightred
   `(font-lock-type-face               ((t (:foreground ,n-brightred :bold t))))
   ;; Keywords (for, if, while, else, switch, case…) → green
   `(font-lock-keyword-face            ((t (:foreground ,n-green :bold t))))
   ;; Flow control (return, break, continue, goto) → brightmagenta
   `(font-lock-builtin-face            ((t (:foreground ,n-brightmagenta :bold t))))
   ;; Preprocessor (#include, #define…) → brightcyan
   `(font-lock-preprocessor-face       ((t (:foreground ,n-brightcyan :bold t))))
   ;; Strings → yellow
   `(font-lock-string-face             ((t (:foreground ,n-yellow))))
   ;; Comments → brightblue
   `(font-lock-comment-face            ((t (:foreground ,n-brightblue))))
   `(font-lock-comment-delimiter-face  ((t (:foreground ,n-brightblue))))
   ;; Built-in functions / constants (None, True, self…) → cyan
   `(font-lock-constant-face           ((t (:foreground ,n-cyan :bold t))))
   ;; Numbers → brightyellow
   `(font-lock-number-face             ((t (:foreground ,n-brightyellow))))
   `(font-lock-warning-face            ((t (:foreground ,n-yellow :bold t))))
   ;; Function names → magenta (nano uses magenta for functions)
   `(font-lock-function-name-face      ((t (:foreground ,n-magenta :bold t))))
   ;; Variable names → default foreground
   `(font-lock-variable-name-face      ((t (:foreground ,n-fg))))
   ;; Doc comments → brightblue (same as comments)
   `(font-lock-doc-face                ((t (:foreground ,n-brightblue))))
   `(font-lock-doc-markup-face         ((t (:foreground ,n-brightblue :bold t))))
   ;; Operators → magenta
   `(font-lock-negation-char-face      ((t (:foreground ,n-magenta))))
   `(font-lock-regexp-grouping-backslash ((t (:foreground ,n-brightyellow :bold t))))
   `(font-lock-regexp-grouping-construct ((t (:foreground ,n-brightcyan :bold t))))
   `(font-lock-operator-face           ((t (:foreground ,n-magenta))))
   `(font-lock-property-face           ((t (:foreground ,n-cyan))))
   `(font-lock-punctuation-face        ((t (:foreground ,n-fg))))

   ;; ── Mode-line ─────────────────────────────────────────
   `(mode-line           ((t (:background ,n-title-bg :foreground ,n-title-fg :box nil))))
   `(mode-line-inactive  ((t (:background "#0a0a0a" :foreground ,n-white :box nil))))
   `(mode-line-buffer-id ((t (:bold t :foreground ,n-brightwhite))))
   `(mode-line-emphasis  ((t (:foreground ,n-brightcyan :bold t))))

   ;; ── Search / match ────────────────────────────────────
   `(isearch             ((t (:background ,n-brightred :foreground ,n-bg :bold t))))
   `(isearch-group-1     ((t (:background ,n-brightred :foreground ,n-bg))))
   `(isearch-group-2     ((t (:background ,n-brightcyan :foreground ,n-bg))))
   `(lazy-highlight      ((t (:background ,n-blue :foreground ,n-fg-bright))))
   `(match               ((t (:background ,n-brightred :foreground ,n-bg))))

   ;; ── Parenthesis matching ──────────────────────────────
   `(show-paren-match    ((t (:background ,n-brightcyan :foreground ,n-bg :bold t))))
   `(show-paren-mismatch ((t (:background ,n-brightred :foreground ,n-bg :bold t))))

   ;; ── Line numbers ──────────────────────────────────────
   `(line-number              ((t (:foreground ,n-white :background ,n-bg))))
   `(line-number-current-line ((t (:foreground ,n-brightwhite :background "#0a0a0a" :bold t))))

   ;; ── Completions (company / corfu / ivy / vertico) ────
   `(company-tooltip            ((t (:background "#0a0a0a" :foreground ,n-fg))))
   `(company-tooltip-selection  ((t (:background ,n-sel-bg :foreground ,n-sel-fg))))
   `(company-tooltip-common     ((t (:foreground ,n-brightcyan :bold t))))
   `(company-tooltip-annotation ((t (:foreground ,n-blue))))
   `(company-scrollbar-bg       ((t (:background "#111111"))))
   `(company-scrollbar-fg       ((t (:foreground ,n-white))))
   `(corfu-default              ((t (:background "#0a0a0a" :foreground ,n-fg))))
   `(corfu-current              ((t (:background ,n-sel-bg :foreground ,n-sel-fg))))
   `(ivy-current-match          ((t (:background ,n-sel-bg :foreground ,n-sel-fg))))
   `(ivy-minibuffer-match-face-1 ((t (:foreground ,n-blue))))
   `(ivy-minibuffer-match-face-2 ((t (:foreground ,n-green :bold t))))
   `(vertico-current            ((t (:background ,n-sel-bg :foreground ,n-sel-fg))))

   ;; ── which-key ─────────────────────────────────────────
   `(which-key-key-face          ((t (:foreground ,n-brightcyan :bold t))))
   `(which-key-group-name-face   ((t (:foreground ,n-brightred))))
   `(which-key-separator-face    ((t (:foreground ,n-white))))

   ;; ── dired ─────────────────────────────────────────────
   `(dired-directory    ((t (:foreground ,n-brightcyan :bold t))))
   `(dired-symlink      ((t (:foreground ,n-magenta))))
   `(dired-flagged      ((t (:foreground ,n-brightred :bold t))))
   `(dired-marked       ((t (:foreground ,n-green :bold t))))
   `(dired-header       ((t (:foreground ,n-brightyellow :bold t))))
   `(dired-ignored      ((t (:foreground ,n-white))))

   ;; ── diff / magit ──────────────────────────────────────
   `(diff-added         ((t (:foreground ,n-green :background "#001a00"))))
   `(diff-removed       ((t (:foreground ,n-red :background "#1a0000"))))
   `(diff-context       ((t (:foreground ,n-fg))))
   `(diff-header        ((t (:foreground ,n-brightyellow :bold t))))
   `(diff-hunk-header   ((t (:foreground ,n-brightcyan :bold t))))
   `(diff-file-header   ((t (:foreground ,n-magenta :bold t))))
   `(diff-function      ((t (:foreground ,n-cyan))))
   `(diff-refine-added  ((t (:background "#003300"))))
   `(diff-refine-removed ((t (:background "#330000"))))

   ;; ── org ───────────────────────────────────────────────
   `(org-level-1        ((t (:foreground ,n-brightred :bold t :height 1.3))))
   `(org-level-2        ((t (:foreground ,n-brightcyan :bold t :height 1.15))))
   `(org-level-3        ((t (:foreground ,n-brightyellow :bold t))))
   `(org-level-4        ((t (:foreground ,n-magenta :bold t))))
   `(org-level-5        ((t (:foreground ,n-cyan :bold t))))
   `(org-level-6        ((t (:foreground ,n-green :bold t))))
   `(org-level-7        ((t (:foreground ,n-blue :bold t))))
   `(org-level-8        ((t (:foreground ,n-fg :bold t))))
   `(org-todo           ((t (:foreground ,n-brightred :bold t))))
   `(org-done           ((t (:foreground ,n-green :bold t))))
   `(org-block          ((t (:background "#0a0a0a" :extend t))))
   `(org-block-begin-line ((t (:foreground ,n-blue :background "#050505" :extend t))))
   `(org-block-end-line ((t (:foreground ,n-blue :background "#050505" :extend t))))
   `(org-code           ((t (:foreground ,n-cyan :background "#0a0a0a"))))
   `(org-verbatim       ((t (:foreground ,n-yellow :background "#0a0a0a"))))
   `(org-link           ((t (:foreground ,n-brightcyan :underline t))))
   `(org-date           ((t (:foreground ,n-magenta :underline t))))
   `(org-special-keyword ((t (:foreground ,n-blue))))
   `(org-meta-line      ((t (:foreground ,n-blue))))
   `(org-checkbox       ((t (:foreground ,n-brightyellow :bold t))))
   `(org-table          ((t (:foreground ,n-cyan))))
   `(org-headline-done  ((t (:foreground ,n-white :strike-through t))))

   ;; ── flycheck / flymake ────────────────────────────────
   `(flycheck-error     ((t (:underline (:style wave :color ,n-brightred)))))
   `(flycheck-warning   ((t (:underline (:style wave :color ,n-yellow)))))
   `(flycheck-info      ((t (:underline (:style wave :color ,n-brightcyan)))))
   `(flymake-error      ((t (:underline (:style wave :color ,n-brightred)))))
   `(flymake-warning    ((t (:underline (:style wave :color ,n-yellow)))))
   `(flymake-note       ((t (:underline (:style wave :color ,n-brightcyan)))))

   ;; ── rainbow-delimiters ────────────────────────────────
   `(rainbow-delimiters-depth-1-face    ((t (:foreground ,n-brightred))))
   `(rainbow-delimiters-depth-2-face    ((t (:foreground ,n-green))))
   `(rainbow-delimiters-depth-3-face    ((t (:foreground ,n-brightcyan))))
   `(rainbow-delimiters-depth-4-face    ((t (:foreground ,n-magenta))))
   `(rainbow-delimiters-depth-5-face    ((t (:foreground ,n-brightyellow))))
   `(rainbow-delimiters-depth-6-face    ((t (:foreground ,n-blue))))
   `(rainbow-delimiters-depth-7-face    ((t (:foreground ,n-cyan))))
   `(rainbow-delimiters-unmatched-face  ((t (:foreground ,n-brightred :bold t :inverse-video t))))

   ;; ── nano status bar faces ─────────────────────────────
   `(nano-keys-statusbar       ((t (:background ,n-bar-bg :foreground ,n-bar-fg :box nil))))
   `(nano-keys-statusbar-title ((t (:foreground ,n-brightwhite :bold t))))
   `(nano-keys-statusbar-key   ((t (:foreground ,n-brightcyan :bold t))))
   `(nano-keys-statusbar-desc  ((t (:foreground ,n-bar-fg))))
   `(nano-keys-statusbar-mod   ((t (:foreground ,n-brightyellow :bold t))))))

;;;###autoload
(define-minor-mode nano-keys-theme-mode
  "Toggle the nano-keys syntax highlighting theme.

Faithfully replicates nano's default syntax highlighting colours
as defined in nano's nanorc syntax files."
  :global t
  :lighter " NanoTheme"
  (if nano-keys-theme-mode
      (progn
        (load-theme 'nano-keys-nano t)
        (message "Nano-Keys theme enabled."))
    (disable-theme 'nano-keys-nano)
    (message "Nano-Keys theme disabled.")))


;; ============================================================
;; 3. Nano-style bottom title / status bar
;; ============================================================
;;
;; Nano's UI has two bars:
;;   1. Title bar (top)  — file name, version, modified flag
;;   2. Status bar (bottom) — shortcut hints, position info
;;
;; In Emacs we replicate this with a dedicated bottom window
;; showing the same information nano would show.
;; ============================================================

(defcustom nano-keys-statusbar-show t
  "When non-nil, show the nano-style bottom status bar."
  :type 'boolean
  :group 'nano-keys)

(defcustom nano-keys-statusbar-height 2
  "Height in lines of the bottom status bar window."
  :type 'integer
  :group 'nano-keys)

(defvar nano-keys--statusbar-window nil
  "Window dedicated to the nano status bar.")

(defvar nano-keys--statusbar-buffer nil
  "Buffer used for the nano status bar.")

(defvar nano-keys--statusbar-timer nil
  "Idle timer for updating the status bar.")

(defvar nano-keys--statusbar-keymap
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-x") #'nano-keys-exit)
    (define-key map (kbd "C-o") #'save-buffer)
    (define-key map (kbd "C-w") #'isearch-forward)
    (define-key map (kbd "C-g") #'nano-keys-help)
    map)
  "Keymap active in the nano status bar buffer.")

(defun nano-keys--statusbar-format ()
  "Build the nano-style two-line status bar content.

Line 1 (title):  'File: <filename>'  with modification marker
Line 2 (shortcuts): nano shortcut hints"
  (let* ((fname (or (buffer-file-name) (buffer-name)))
         (line  (line-number-at-pos))
         (col   (1+ (current-column)))
         (modif (if (buffer-modified-p) " **" ""))
         (ro    (if buffer-read-only " [Read Only]" ""))
         ;; Title line — nano style: 'File: name' with mod flag
         (title (concat
                 (propertize (format "  File: %s%s%s" fname modif ro)
                             'face 'nano-keys-statusbar-title)))
         ;; Shortcut line — nano style bottom bar
         (shortcuts
          (concat
           " "
           (propertize "C-x" 'face 'nano-keys-statusbar-key) " Exit   "
           (propertize "C-o" 'face 'nano-keys-statusbar-key) " WriteOut   "
           (propertize "C-w" 'face 'nano-keys-statusbar-key) " WhereIs   "
           (propertize "C-k" 'face 'nano-keys-statusbar-key) " Cut   "
           (propertize "C-u" 'face 'nano-keys-statusbar-key) " Uncut   "
           (propertize "C-g" 'face 'nano-keys-statusbar-key) " Help"))
         ;; Position line
         (posinfo (propertize (format "  Ln %d, Col %d" line col)
                              'face 'nano-keys-statusbar-desc)))
    (concat title "\n" shortcuts "\n" posinfo)))

(defun nano-keys--statusbar-update ()
  "Update the nano status bar buffer content."
  (when (and nano-keys-statusbar-show
             nano-keys--statusbar-buffer
             (buffer-live-p nano-keys--statusbar-buffer))
    (let ((content (nano-keys--statusbar-format)))
      (when content
        (with-current-buffer nano-keys--statusbar-buffer
          (let ((inhibit-read-only t))
            (erase-buffer)
            (insert content)))))))

(defun nano-keys--statusbar-create ()
  "Create the bottom status bar window."
  (let ((buf (get-buffer-create " *nano-statusbar*")))
    (setq nano-keys--statusbar-buffer buf)
    (with-current-buffer buf
      (setq-local mode-line-format nil)
      (setq-local header-line-format nil)
      (setq-local cursor-type nil)
      (face-remap-add-relative 'default 'nano-keys-statusbar)
      (use-local-map nano-keys--statusbar-keymap)
      (read-only-mode 1))
    (let ((win (split-window (frame-root-window)
                             (- nano-keys-statusbar-height)
                             'below)))
      (set-window-buffer win buf)
      (set-window-dedicated-p win t)
      (setq nano-keys--statusbar-window win))))

(defun nano-keys--statusbar-destroy ()
  "Remove the bottom status bar window."
  (when (and nano-keys--statusbar-window
             (window-live-p nano-keys--statusbar-window))
    (delete-window nano-keys--statusbar-window)
    (setq nano-keys--statusbar-window nil))
  (when nano-keys--statusbar-timer
    (cancel-timer nano-keys--statusbar-timer)
    (setq nano-keys--statusbar-timer nil)))

;;;###autoload
(define-minor-mode nano-keys-statusbar-mode
  "Toggle the nano-style bottom status bar.

Replicates nano's two-line bottom bar:
  Line 1: File name with modification marker
  Line 2: Shortcut hints (C-x Exit, C-o WriteOut, …)
  Line 3: Line and column position"
  :global t
  :lighter " NanoBar"
  (if nano-keys-statusbar-mode
      (progn
        (nano-keys--statusbar-create)
        (nano-keys--statusbar-update)
        (setq nano-keys--statusbar-timer
              (run-with-idle-timer 0.3 t #'nano-keys--statusbar-update))
        (add-hook 'post-command-hook #'nano-keys--statusbar-update)
        (message "Nano-Keys status bar enabled."))
    (nano-keys--statusbar-destroy)
    (remove-hook 'post-command-hook #'nano-keys--statusbar-update)
    (message "Nano-Keys status bar disabled.")))


;; ============================================================
;; Provide
;; ============================================================
(when nano-keys-enable-on-load
  (nano-keys-mode 1))

(provide 'nano-keys)

;;; nano-keys.el ends here
