;;; nano-lsp.el --- LSP 集成与语言模式 -*- lexical-binding: t; -*-

;;; Commentary:
;; company 补全、eglot LSP、语言模式配置、关键字补全

;;; Code:

;; ========== Company 自动补全 ==========

(with-eval-after-load 'company
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.1
        company-tooltip-align-annotations t
        company-tooltip-limit 14
        company-require-match nil
        company-dabbrev-other-buffers t
        company-dabbrev-ignore-case t
        company-dabbrev-downcase nil
        company-tooltip-flip-when-above t)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous)
  (define-key company-active-map (kbd "C-j") #'company-complete-selection)
  (define-key company-active-map (kbd "TAB") #'company-complete-common-or-cycle)
  (define-key company-active-map (kbd "RET") #'company-complete-selection)
  (define-key company-active-map (kbd "<down>") #'company-select-next)
  (define-key company-active-map (kbd "<up>") #'company-select-previous)
  (define-key company-active-map (kbd "<right>") #'company-complete-common-or-cycle)
  (define-key company-mode-map (kbd "TAB") (lambda () (interactive) (insert "\t")))
  (setq company-backends
        '((company-capf company-keywords :with company-yasnippet)
          (company-files)
          company-dabbrev-code
          company-dabbrev)))

;; ========== Flycheck 语法检查 ==========

(with-eval-after-load 'flycheck
  (setq flycheck-check-syntax-automatically '(save mode-enabled)
        flycheck-display-errors-delay 0.3))

;; ========== Yasnippet ==========

(with-eval-after-load 'yasnippet
  (setq yas-snippet-dirs '("~/.emacs.d/snippets")))

;; ========== 延迟启用全局模式 ==========

(add-hook 'after-init-hook #'global-company-mode)
(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook 'after-init-hook #'yas-global-mode)

;; ========== LSP (eglot) ==========

(with-eval-after-load 'eglot
  (setq eglot-events-buffer-size 0))

(defun nano-eglot-ensure ()
  "仅在 LSP 服务器已安装时才启动 eglot。"
  (condition-case nil
      (when (nano--lsp-server-p major-mode)
        (eglot-ensure))
    (error nil)))

(defun nano--lsp-server-p (mode)
  "检查 MODE 对应的 LSP 服务器是否已安装。"
  (let ((servers (cdr (assoc mode nano--lsp-servers))))
    (and servers (cl-some #'executable-find servers))))

(defconst nano--lsp-servers
  '((c-mode              . ("clangd"))
    (c++-mode            . ("clangd"))
    (java-mode           . ("jdtls"))
    (kotlin-mode         . ("kotlin-language-server"))
    (go-mode             . ("gopls"))
    (rustic-mode         . ("rust-analyzer"))
    (rust-mode           . ("rust-analyzer"))
    (python-mode         . ("pylsp"))
    (python-ts-mode      . ("pylsp"))
    (js2-mode            . ("vtsls"))
    (js-mode             . ("vtsls"))
    (typescript-mode     . ("vtsls"))
    (typescript-ts-mode  . ("vtsls"))
    (cmake-mode          . ("cmake-language-server"))
    (yaml-mode           . ("yaml-language-server"))
    (json-mode           . ("vscode-json-language-server" "json-languageserver"))
    (json-ts-mode        . ("vscode-json-language-server" "json-languageserver"))
    (markdown-mode       . ("marksman" "vscode-markdown-language-server"))
    (dockerfile-mode     . ("docker-langserver"))
    (lua-mode            . ("lua-language-server" "lua-lsp"))
    (perl-mode           . ("perl-language-server"))
    (cperl-mode          . ("perl-language-server")))
  "各 major-mode 对应的 LSP 服务器候选名。")

;; ========== 语言关键字补全（LSP 优先，关键字表作 fallback） ==========

(defconst nano-java-keywords
  '("abstract" "assert" "boolean" "break" "byte" "case" "catch" "char"
    "class" "const" "continue" "default" "do" "double" "else" "enum"
    "extends" "final" "finally" "float" "for" "goto" "if" "implements"
    "import" "instanceof" "int" "interface" "long" "native" "new"
    "package" "private" "protected" "public" "return" "short" "static"
    "strictfp" "super" "switch" "synchronized" "this" "throw" "throws"
    "transient" "try" "void" "volatile" "while"
    "var" "record" "sealed" "permits" "yield"
    "true" "false" "null"
    "System" "String" "Integer" "Double" "Boolean" "Long" "Float"
    "Byte" "Short" "Character" "Object" "Class" "Math"
    "ArrayList" "HashMap" "HashSet" "LinkedList" "TreeMap" "TreeSet"
    "List" "Map" "Set" "Queue" "Deque" "Collection" "Collections"
    "Arrays" "Objects" "Optional" "Stream"
    "println" "print" "printf" "format"
    "out" "err" "in"
    "Override" "Deprecated" "SuppressWarnings" "FunctionalInterface"
    "Retention" "Target" "Documented" "Inherited")
  "Java 关键字列表。")

(defconst nano-kotlin-keywords
  '("abstract" "actual" "annotation" "as" "break" "by" "catch" "class"
    "companion" "const" "constructor" "continue" "crossinline" "data"
    "delegate" "do" "dynamic" "else" "enum" "expect" "external" "false"
    "field" "file" "final" "finally" "for" "fun" "get" "if" "import"
    "in" "infix" "init" "inline" "inner" "interface" "internal" "is"
    "lateinit" "noinline" "null" "object" "open" "operator" "out"
    "override" "package" "param" "private" "property" "protected"
    "public" "reified" "return" "sealed" "set" "super" "suspend"
    "tailrec" "this" "throw" "true" "try" "typealias" "typeof"
    "val" "var" "vararg" "when" "where" "while"
    "println" "print" "readLine" "listOf" "mutableListOf" "setOf"
    "mutableSetOf" "mapOf" "mutableMapOf" "arrayOf"
    "Int" "Long" "Float" "Double" "Boolean" "Char" "Byte" "Short"
    "String" "Unit" "Nothing" "Any"
    "run" "let" "also" "apply" "with"
    "lazy" "lateinit")
  "Kotlin 关键字列表。")

(defconst nano-lua-keywords
  '("and" "break" "do" "else" "elseif" "end" "false" "for" "function"
    "goto" "if" "in" "local" "nil" "not" "or" "repeat" "return"
    "then" "true" "until" "while"
    "print" "tostring" "tonumber" "type" "unpack" "require"
    "pairs" "ipairs" "next" "select" "pcall" "xpcall" "error"
    "assert" "collectgarbage" "dofile" "getmetatable" "setmetatable"
    "rawget" "rawset" "rawequal"
    "string" "table" "math" "io" "os" "debug" "package" "coroutine"
    "self")
  "Lua 关键字列表。")

(defconst nano-dockerfile-keywords
  '("FROM" "RUN" "CMD" "LABEL" "MAINTAINER" "EXPOSE" "ENV" "ADD" "COPY"
    "ENTRYPOINT" "VOLUME" "USER" "WORKDIR" "ARG" "ONBUILD" "STOPSIGNAL"
    "HEALTHCHECK" "SHELL" "AS")
  "Dockerfile 关键字列表。")

(defconst nano-cmake-keywords
  '("cmake_minimum_required" "project" "add_executable" "add_library"
    "target_link_libraries" "target_include_directories"
    "target_compile_definitions" "target_compile_options" "target_sources"
    "set" "unset" "option"
    "if" "elseif" "else" "endif"
    "foreach" "endforeach" "while" "endwhile"
    "function" "endfunction" "macro" "endmacro"
    "return" "break" "continue"
    "include" "find_package" "find_library" "find_path" "find_file"
    "find_program"
    "message" "configure_file" "file" "string" "list"
    "add_subdirectory" "add_test" "enable_testing"
    "install" "export"
    "CMAKE_C_COMPILER" "CMAKE_CXX_COMPILER"
    "CMAKE_BUILD_TYPE" "CMAKE_INSTALL_PREFIX"
    "CMAKE_SOURCE_DIR" "CMAKE_BINARY_DIR"
    "CMAKE_CURRENT_SOURCE_DIR" "CMAKE_CURRENT_BINARY_DIR"
    "include_directories" "link_directories" "add_definitions"
    "PRIVATE" "PUBLIC" "INTERFACE"
    "STATIC" "SHARED" "MODULE"
    "ON" "OFF" "TRUE" "FALSE"
    "AND" "OR" "NOT"
    "EXISTS" "IS_DIRECTORY" "IS_ABSOLUTE"
    "GREATER" "LESS" "EQUAL"
    "VERSION_GREATER" "VERSION_LESS" "VERSION_EQUAL"
    "MATCHES" "IN_LIST")
  "CMake 关键字列表。")

;; ========== 语言模式配置 ==========

;; C / C++ — clangd
(add-to-list 'auto-mode-alist '("\\.c\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cc\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cxx\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.hpp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.hxx\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.inl\\'" . c++-mode))

(defun nano-c-mode-setup ()
  "C/C++ 模式初始化：LSP + 快捷键。"
  (nano-eglot-ensure)
  (define-key (current-local-map) (kbd "C-x") 'nano-exit))

(add-hook 'c-mode-hook #'nano-c-mode-setup)
(add-hook 'c++-mode-hook #'nano-c-mode-setup)

;; Go — gopls
(autoload 'go-mode "go-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
(with-eval-after-load 'go-mode
  (define-key go-mode-map (kbd "C-x") 'nano-exit)
  (add-hook 'go-mode-hook #'nano-eglot-ensure))

;; Java — jdtls
(add-to-list 'auto-mode-alist '("\\.java\\'" . java-mode))
(with-eval-after-load 'java-mode
  (setq-local company-keywords nano-java-keywords)
  (add-hook 'java-mode-hook #'nano-eglot-ensure))

;; Kotlin — kotlin-language-server
(autoload 'kotlin-mode "kotlin-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.kt\\'" . kotlin-mode))
(add-to-list 'auto-mode-alist '("\\.kts\\'" . kotlin-mode))
(with-eval-after-load 'kotlin-mode
  (setq-local company-keywords nano-kotlin-keywords)
  (add-hook 'kotlin-mode-hook #'nano-eglot-ensure))

;; Rust — rust-analyzer
(autoload 'rust-mode "rust-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))
(with-eval-after-load 'rust-mode
  (define-key rust-mode-map (kbd "C-x") 'nano-exit)
  (add-hook 'rust-mode-hook #'nano-eglot-ensure))

;; Python — pylsp/pyright
(autoload 'python-mode "python-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(with-eval-after-load 'python-mode
  (define-key python-mode-map (kbd "C-x") 'nano-exit)
  (add-hook 'python-mode-hook #'nano-eglot-ensure))

;; JavaScript — typescript-language-server
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.mjs\\'" . js2-mode))
(with-eval-after-load 'js2-mode
  (define-key js2-mode-map (kbd "C-x") 'nano-exit)
  (add-hook 'js2-mode-hook #'nano-eglot-ensure))

;; TypeScript — vtsls
(autoload 'typescript-mode "typescript-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-mode))
(with-eval-after-load 'typescript-mode
  (define-key typescript-mode-map (kbd "C-x") 'nano-exit)
  (add-hook 'typescript-mode-hook #'nano-eglot-ensure))

;; CMake — cmake-language-server
(autoload 'cmake-mode "cmake-mode" nil t)
(add-to-list 'auto-mode-alist '("CMakeLists\\.txt\\'" . cmake-mode))
(add-to-list 'auto-mode-alist '("\\.cmake\\'" . cmake-mode))
(with-eval-after-load 'cmake-mode
  (setq-local company-keywords nano-cmake-keywords)
  (add-hook 'cmake-mode-hook #'nano-eglot-ensure))

;; YAML
(autoload 'yaml-mode "yaml-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))
(with-eval-after-load 'yaml-mode
  (define-key yaml-mode-map (kbd "C-x") 'nano-exit))

;; TOML
(autoload 'toml-mode "toml-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.toml\\'" . toml-mode))
(with-eval-after-load 'toml-mode
  (define-key toml-mode-map (kbd "C-x") 'nano-exit))

;; JSON
(autoload 'json-mode "json-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.json\\'" . json-mode))
(with-eval-after-load 'json-mode
  (define-key json-mode-map (kbd "C-x") 'nano-exit))

;; Markdown
(autoload 'markdown-mode "markdown-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(with-eval-after-load 'markdown-mode
  (define-key markdown-mode-map (kbd "C-x") 'nano-exit))

;; Dockerfile
(autoload 'dockerfile-mode "dockerfile-mode" nil t)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))
(with-eval-after-load 'dockerfile-mode
  (setq-local company-keywords nano-dockerfile-keywords)
  (define-key dockerfile-mode-map (kbd "C-x") 'nano-exit))

;; Lua
(autoload 'lua-mode "lua-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.lua\\'" . lua-mode))
(with-eval-after-load 'lua-mode
  (setq-local company-keywords nano-lua-keywords)
  (define-key lua-mode-map (kbd "C-x") 'nano-exit))

;; Meson
(autoload 'meson-mode "meson-mode" nil t)
(add-to-list 'auto-mode-alist '("meson\\.build\\'" . meson-mode))
(add-to-list 'auto-mode-alist '("meson_options\\.txt\\'" . meson-mode))
(with-eval-after-load 'meson-mode
  (define-key meson-mode-map (kbd "C-x") 'nano-exit))

;; Makefile
(add-to-list 'auto-mode-alist '("Makefile\\'" . makefile-mode))
(add-to-list 'auto-mode-alist '("GNUmakefile\\'" . makefile-mode))
(add-to-list 'auto-mode-alist '("\\.mak\\'" . makefile-mode))
(add-to-list 'auto-mode-alist '("\\.mk\\'" . makefile-mode))

;; Autoconf
(add-to-list 'auto-mode-alist '("configure\\.ac\\'" . autoconf-mode))
(add-to-list 'auto-mode-alist '("Makefile\\.am\\'" . autoconf-mode))
(add-to-list 'auto-mode-alist '("\\.ac\\'" . autoconf-mode))
(add-to-list 'auto-mode-alist '("\\.in\\'" . autoconf-mode))

;; Lex / Yacc
(add-to-list 'auto-mode-alist '("\\.l\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.y\\'" . c-mode))

(provide 'nano-lsp)
;;; nano-lsp.el ends here
