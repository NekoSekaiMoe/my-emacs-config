;;; nano-keys-lsp.el --- LSP integration for nano-keys -*- lexical-binding: t; -*-

;; Copyright (C) 2024
;; Author: nano-keys contributors
;; Version: 0.4.0
;; Package-Requires: ((emacs "27.1") (lsp-mode "8.0.0"))
;; Keywords: convenience, nano, lsp
;; URL: https://github.com/nano-keys/nano-keys

;;; Commentary:
;;
;; LSP server configuration for nano-keys.
;; Provides nano-style keybindings for LSP operations and
;; recommended LSP server settings for each supported language.
;;
;; Usage:
;;   (require 'nano-keys-lsp)
;;   (nano-keys-lsp-mode 1)

;;; Code:

(require 'nano-keys)

(defgroup nano-keys-lsp nil
  "LSP integration for nano-keys."
  :group 'nano-keys
  :prefix "nano-keys-lsp-")

(defcustom nano-keys-lsp-enable-diagnostics t
  "When non-nil, enable LSP diagnostics (errors, warnings, info)."
  :type 'boolean
  :group 'nano-keys-lsp)

(defcustom nano-keys-lsp-enable-completion t
  "When non-nil, enable LSP completion."
  :type 'boolean
  :group 'nano-keys-lsp)

(defcustom nano-keys-lsp-enable-hover t
  "When non-nil, enable LSP hover documentation."
  :type 'boolean
  :group 'nano-keys-lsp)

;; ============================================================
;; LSP server configurations
;; ============================================================

(defcustom nano-keys-lsp-server-alist
  '((c-mode        . ("clangd"))
    (c++-mode      . ("clangd"))
    (python-mode   . ("pylsp" "pyright"))
    (python-ts-mode . ("pylsp" "pyright"))
    (js-mode       . ("typescript-language-server" "--stdio"))
    (js2-mode      . ("typescript-language-server" "--stdio"))
    (typescript-mode . ("typescript-language-server" "--stdio"))
    (typescript-ts-mode . ("typescript-language-server" "--stdio"))
    (tsx-ts-mode   . ("typescript-language-server" "--stdio"))
    (go-mode       . ("gopls"))
    (go-ts-mode    . ("gopls"))
    (java-mode     . ("jdtls"))
    (java-ts-mode  . ("jdtls"))
    (lua-mode      . ("lua-language-server"))
    (ruby-mode     . ("solargraph"))
    (ruby-ts-mode  . ("solargraph"))
    (rust-mode     . ("rust-analyzer"))
    (rust-ts-mode  . ("rust-analyzer"))
    (php-mode      . ("intelephense" "--stdio"))
    (perl-mode     . ("perlnavigator"))
    (cperl-mode    . ("perlnavigator"))
    (sh-mode       . ("bash-language-server" "start"))
    (bash-ts-mode  . ("bash-language-server" "start"))
    (html-mode     . ("vscode-html-language-server" "--stdio"))
    (mhtml-mode    . ("vscode-html-language-server" "--stdio"))
    (html-ts-mode  . ("vscode-html-language-server" "--stdio"))
    (css-mode      . ("vscode-css-language-server" "--stdio"))
    (scss-mode     . ("vscode-css-language-server" "--stdio"))
    (css-ts-mode   . ("vscode-css-language-server" "--stdio"))
    (json-mode     . ("vscode-json-language-server" "--stdio"))
    (json-ts-mode  . ("vscode-json-language-server" "--stdio"))
    (yaml-mode     . ("yaml-language-server" "--stdio"))
    (yaml-ts-mode  . ("yaml-language-server" "--stdio"))
    (markdown-mode . ("marksman"))
    (gfm-mode      . ("marksman"))
    (cmake-mode    . ("cmake-language-server"))
    (cmake-ts-mode . ("cmake-language-server"))
    (latex-mode    . ("texlab"))
    (LaTeX-mode    . ("texlab"))
    (swift-mode    . ("sourcekit-lsp"))
    (kotlin-mode   . ("kotlin-language-server"))
    (kotlin-ts-mode . ("kotlin-language-server"))
    (scala-mode    . ("metals"))
    (scala-ts-mode . ("metals"))
    (haskell-mode  . ("haskell-language-server-wrapper" "--lsp"))
    (haskell-literate-mode . ("haskell-language-server-wrapper" "--lsp"))
    (elixir-mode   . ("elixir-ls"))
    (elixir-ts-mode . ("elixir-ls"))
    (csharp-mode   . ("omnisharp" "-lsp"))
    (csharp-ts-mode . ("omnisharp" "-lsp"))
    (fsharp-mode   . ("fsautocomplete"))
    (ocaml-mode    . ("ocamllsp"))
    (tuareg-mode   . ("ocamllsp"))
    (dockerfile-mode . ("docker-langserver" "--stdio"))
    (dockerfile-ts-mode . ("docker-langserver" "--stdio"))
    (nginx-mode    . ("nginx-language-server"))
    (puppet-mode   . ("puppet-languageserver" "--stdio"))
    (tcl-mode      . ("tcl-language-server"))
    (awk-mode      . ("awk-language-server"))
    (verilog-mode  . ("svls"))
    (verilog-ts-mode . ("svls"))
    (glsl-mode     . ("glsl_analyzer"))
    (sql-mode      . ("sqls"))
    (toml-mode     . ("taplo" "lsp" "stdio"))
    (toml-ts-mode  . ("taplo" "lsp" "stdio"))
    (clojure-mode  . ("clojure-lsp"))
    (clojurescript-mode . ("clojure-lsp"))
    (fortran-mode  . ("fortls"))
    (f90-mode      . ("fortls"))
    (zig-mode      . ("zls"))
    (nim-mode      . ("nimlsp"))
    (dart-mode     . ("dart" "language-server" "--protocol=lsp"))
    (elm-mode      . ("elm-language-server"))
    (erlang-mode   . ("erlang-ls"))
    (crystal-mode  . ("crystalline"))
    (v-mode        . ("v-analyzer"))
    (ada-mode      . ("ada_language_server"))
    (riscv-mode    . ("riscv-ls")))
  "Alist mapping major modes to LSP server command names.
Each entry is (MODE . (SERVER-COMMAND...))."
  :type '(alist :key-type symbol :value-type (repeat string))
  :group 'nano-keys-lsp)

;; ============================================================
;; LSP keybindings (nano-style)
;; ============================================================

(defvar nano-keys-lsp-map
  (let ((map (make-sparse-keymap)))
    ;; M-s: nano's "Where Is" → LSP find references
    (define-key map (kbd "M-s") #'lsp-find-references)
    ;; M-d: nano's "To Spell" → LSP diagnostics
    (define-key map (kbd "M-d") #'lsp-ui-flycheck-list)
    ;; M-g: nano's "Go To Line" → LSP goto definition
    (define-key map (kbd "M-g") #'lsp-find-definition)
    ;; M-r: nano's "Read File" → LSP rename
    (define-key map (kbd "M-r") #'lsp-rename)
    ;; M-t: nano's "To Spell" → LSP hover
    (define-key map (kbd "M-t") #'lsp-ui-doc-show)
    ;; M-f: find file → LSP workspace symbol
    (define-key map (kbd "M-f") #'lsp-ui-sideline-mode)
    ;; M-a: mark → LSP execute code action
    (define-key map (kbd "M-a") #'lsp-execute-code-action)
    ;; M-i: LSP info/hover
    (define-key map (kbd "M-i") #'lsp-describe-thing-at-point)
    ;; M-c: LSP completion at point
    (define-key map (kbd "M-c") #'lsp-signature-activate)
    ;; C-M-g: LSP goto implementation
    (define-key map (kbd "C-M-g") #'lsp-find-implementation)
    ;; C-M-t: LSP find type definition
    (define-key map (kbd "C-M-t") #'lsp-find-type-definition)
    ;; C-M-d: LSP peek definition
    (define-key map (kbd "C-M-d") #'lsp-ui-peek-find-definitions)
    ;; C-M-r: LSP peek references
    (define-key map (kbd "C-M-r") #'lsp-ui-peek-find-references)
    ;; C-M-s: LSP workspace symbol
    (define-key map (kbd "C-M-s") #'lsp-ui-sideline-toggle-symbols-info)
    ;; C-M-f: LSP format
    (define-key map (kbd "C-M-f") #'lsp-format-buffer)
    ;; C-M-l: LSP lens mode
    (define-key map (kbd "C-M-l") #'lsp-lens-mode)
    map)
  "Keymap for nano-keys LSP commands.")

;; ============================================================
;; LSP mode setup
;; ============================================================

(defun nano-keys-lsp--configure-lsp ()
  "Configure lsp-mode with nano-keys settings."
  (when (featurep 'lsp-mode)
    ;; Diagnostics
    (setq-local lsp-diagnostics-provider
                (if nano-keys-lsp-enable-diagnostics :flycheck :none))
    ;; Completion
    (setq-local lsp-completion-provider
                (if nano-keys-lsp-enable-completion :capf :none))
    ;; Hover
    (setq-local lsp-hover-enabled nano-keys-lsp-enable-hover)
    ;; UI
    (setq-local lsp-ui-doc-enable t)
    (setq-local lsp-ui-doc-position 'at-point)
    (setq-local lsp-ui-sideline-enable t)
    (setq-local lsp-ui-sideline-show-diagnostics t)
    (setq-local lsp-ui-sideline-show-hover t)
    ;; Modeline
    (setq-local lsp-modeline-diagnostics-enable t)
    (setq-local lsp-modeline-code-actions-enable t)
    ;; Headerline
    (setq-local lsp-headerline-breadcrumb-enable t)
    ;; Signature
    (setq-local lsp-signature-auto-activate t)
    (setq-local lsp-signature-render-documentation t)
    ;; Lens
    (setq-local lsp-lens-enable t)
    ;; Semantic tokens
    (setq-local lsp-semantic-tokens-enable t)
    ;; Idle delay
    (setq-local lsp-idle-delay 0.5)))

(defun nano-keys-lsp--setup-eglot ()
  "Configure eglot with nano-keys settings."
  (when (featurep 'eglot)
    ;; Ensure eglot uses nano-keys theme faces for flymake diagnostics
    (setq-local elogot-stay-out-of '(flymake))
    (setq-local eldoc-echo-area-use-multiline-p t)))

;; ============================================================
;; Global mode
;; ============================================================

;;;###autoload
(define-minor-mode nano-keys-lsp-mode
  "Toggle nano-keys LSP integration.

Provides:
  - LSP server auto-detection for 40+ languages
  - Nano-style keybindings for LSP operations
  - Recommended LSP settings matching nano aesthetics

Keybindings (available when LSP is active):
  M-s   Find references (nano: Where Is)
  M-d   Show diagnostics (nano: To Spell)
  M-g   Go to definition (nano: Go To Line)
  M-r   Rename symbol (nano: Read File)
  M-t   Show hover doc (nano: To Spell)
  M-a   Execute code action (nano: Mark Text)
  M-i   Describe thing at point
  M-c   Signature help
  C-M-g  Go to implementation
  C-M-t  Find type definition
  C-M-d  Peek definitions
  C-M-r  Peek references
  C-M-f  Format buffer"
  :global t
  :lighter " NanoLSP"
  :keymap nano-keys-lsp-map
  (if nano-keys-lsp-mode
      (progn
        ;; Configure lsp-mode if available
        (with-eval-after-load 'lsp-mode
          (add-hook 'lsp-mode-hook #'nano-keys-lsp--configure-lsp)
          ;; Set up server install preferences
          (setq lsp-server-install-dir
                (expand-file-name "lsp-servers" user-emacs-directory))
          ;; Enable which-key integration
          (when (featurep 'which-key)
            (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)))
        ;; Configure eglot if available
        (with-eval-after-load 'eglot
          (add-hook 'eglot-managed-mode-hook #'nano-keys-lsp--setup-eglot))
        (message "Nano-Keys LSP mode enabled."))
    (message "Nano-Keys LSP mode disabled.")))


(provide 'nano-keys-lsp)

;;; nano-keys-lsp.el ends here
