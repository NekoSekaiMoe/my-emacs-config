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

(defconst nano-makefile-keywords
  '("CC" "CXX" "CFLAGS" "CXXFLAGS" "LDFLAGS" "LDLIBS"
    "AR" "AS" "NM" "OBJCOPY" "OBJDUMP" "RANLIB" "READELF" "SIZE" "STRINGS" "STRIP"
    "CPP" "FC" "MAKE" "MAKEFLAGS" "SHELL"
    "VPATH" "vpath"
    "PREFIX" "prefix" "EXEC_PREFIX" "exec_prefix"
    "BINDIR" "bindir" "SBINDIR" "sbindir" "LIBEXECDIR" "libexecdir"
    "DATADIR" "datadir" "SYSCONFDIR" "sysconfdir" "SHAREDSTATEDIR" "sharedstatedir"
    "LOCALSTATEDIR" "localstatedir" "INCLUDEDIR" "includedir"
    "OLDINCLUDEDIR" "oldincludedir" "DOCDIR" "docdir" "INFODIR" "infodir"
    "LIBDIR" "libdir" "LOCALEDIR" "localedir" "MANDIR" "mandir"
    "DESTDIR"
    ".PHONY" ".SUFFIXES" ".DEFAULT" ".PRECIOUS" ".INTERMEDIATE" ".SECONDARY"
    ".SECONDEXPANSION" ".DELETE_ON_ERROR" ".IGNORE" ".LOW_RESOLUTION_TIME"
    ".SILENT" ".EXPORT_ALL_VARIABLES"
    "all" "clean" "install" "dist" "check" "test"
    "distclean" "mostlyclean" "maintainer-clean"
    "TAGS" "info" "dvi" "pdf" "ps" "html"
    "ifeq" "ifneq" "ifdef" "ifndef" "else" "endif"
    "define" "endef" "override" "export" "unexport" "private"
    "include" "sinclude" "-include"
    "subst" "patsubst" "strip" "findstring" "filter" "filter-out"
    "sort" "word" "wordlist" "words" "firstword" "lastword"
    "dir" "notdir" "suffix" "basename" "addsuffix" "addprefix"
    "join" "wildcard" "realpath" "abspath"
    "error" "warning" "info"
    "shell" "origin" "flavor" "foreach" "if" "or" "and"
    "eval" "value" "call"
    "MAKELEVEL" "MAKECMDGOALS" "MAKEFILES"
    "CURDIR" "MAKE_HOST" "MAKE_VERSION"
    ".DEFAULT_GOAL"
    "AWK" "BISON" "FLEX" "GPERF" "GREP"
    "MAKEINFO" "MAKEHTML" "SED" "TEX" "TEXI2DVI" "TEXI2PDF"
    "YACC"
    "ACLOCAL_AMFLAGS" "AUTOMAKE_OPTIONS"
    "SUBDIRS" "DIST_SUBDIRS"
    "bin_PROGRAMS" "sbin_PROGRAMS" "lib_LIBRARIES" "lib_LTLIBRARIES"
    "noinst_LIBRARIES" "check_PROGRAMS"
    "EXTRA_DIST"
    "BUILT_SOURCES" "CLEANFILES" "DISTCLEANFILES" "MAINTAINERCLEANFILES"
    "AC_CONFIG_FILES" "AC_CONFIG_HEADERS" "AC_CONFIG_LINKS"
    "AC_CONFIG_COMMANDS" "AC_CONFIG_SUBDIRS"
    "AM_INIT_AUTOMAKE" "AC_INIT"
    "AC_PROG_CC" "AC_PROG_CXX" "AC_PROG_F77" "AC_PROG_GCJ"
    "AC_PROG_LEX" "AC_PROG_YACC" "AC_PROG_RANLIB"
    "AC_PROG_LIBTOOL" "AC_PROG_LN_S" "AC_PROG_MAKE_SET"
    "AC_PROG_INSTALL" "AC_PROG_AWK"
    "AC_CHECK_HEADERS" "AC_CHECK_LIB" "AC_CHECK_FUNCS"
    "AC_CHECK_PROGS" "AC_CHECK_PROG"
    "AC_MSG_CHECKING" "AC_MSG_RESULT" "AC_MSG_ERROR" "AC_MSG_WARN"
    "AC_ARG_ENABLE" "AC_ARG_WITH"
    "AC_SUBST" "AC_DEFINE" "AC_DEFINE_UNQUOTED"
    "AC_OUTPUT" "AC_REQUIRE"
    "AM_CONDITIONAL"
    "AM_PROG_CC_C_O" "AM_PROG_LEX" "AM_PROG_YACC"
    "AM_MAINTAINER_MODE" "AM_SILENT_RULES"
    "PKG_CHECK_MODULES" "PKG_CHECK_EXISTS"
    "LT_PREREQ" "LT_INIT"
    "m4_include" "m4_sinclude"
    "AS_IF" "AS_CASE" "AS_TR_SH" "AS_TR_CPP"
    "AH_TEMPLATE" "AH_BOTTOM"
    "AC_LIBOBJ" "AC_LIBSOURCE" "AC_LIBSOURCES"
    "AC_FUNC_MALLOC" "AC_FUNC_REALLOC"
    "AC_HEADER_STDC" "AC_TYPE_PID_T" "AC_TYPE_SIZE_T"
    "AC_C_CONST" "AC_C_INLINE" "AC_C_BIGENDIAN"
    "AC_SYS_LARGEFILE"
    "yes" "no")
  "Makefile / Autoconf / Automake 关键字列表。")

(defconst nano-meson-keywords
  '("project" "executable" "library" "static_library" "shared_library"
    "shared_module" "build_target" "custom_target" "run_target"
    "dependency" "declare_dependency" "find_library"
    "add_project_arguments" "add_project_link_arguments"
    "add_global_arguments" "add_global_link_arguments"
    "add_languages" "has_language"
    "import" "files" "include_directories"
    "subdir" "subdir_done"
    "foreach" "endforeach"
    "if" "elif" "else" "endif"
    "and" "or" "not" "true" "false"
    "error" "warning" "message" "assert"
    "disabler"
    "configuration_data" "configure_file"
    "option" "get_option"
    "set_variable" "get_variable" "is_variable"
    "run_command" "vcs_tag" "generator"
    "install_headers" "install_man" "install_data"
    "install_subdir" "install_symlink"
    "jar" "test" "benchmark"
    "add_test_setup"
    "override_find_program" "override_dependency"
    "both_libraries" "range"
    "structured_sources"
    "summary"
    "alias_target"
    "machine"
    "build_machine" "host_machine" "target_machine"
    "meson"
    "current_source_dir" "current_build_dir"
    "source_root" "build_root"
    "is_cross" "has_exe_wrapper"
    "sizeof" "has_header" "has_function" "has_member"
    "has_type" "has_members" "has_header_symbol"
    "alignment" "compute_int" "has_multi_arguments"
    "check_header"
    "prefix" "bindir" "datadir" "includedir" "infodir"
    "libdir" "libexecdir" "localedir" "localstatedir"
    "mandir" "sbindir" "sharedstatedir" "sysconfdir"
    "global" "section"
    "c_std" "cpp_std" "c_args" "cpp_args"
    "c_link_args" "cpp_link_args"
    "name" "sources" "dependencies"
    "link_with" "link_whole" "link_args"
    "install" "install_dir" "install_mode"
    "override_options" "d_import_dirs"
    "d_unittest" "d_module_versions" "d_debug"
    "rust_args" "fortran_args" "objc_args"
    "vala_args" "cs_args" "swift_args"
    "cython_args" "java_args"
    "c_pch" "cpp_pch"
    "gnu_symbol_visibility"
    "native"
    "command" "capture" "build_by_default"
    "depends" "depfile" "env"
    "feed" "input" "output"
    "install_tag" "workdir"
    "check" "is_parallel"
    "priority" "suite" "timeout"
    "protocol"
    "encoding"
    "allow_fallback" "fallback" "required"
    "modules" "cmake_module_path"
    "auto_features" "default_options"
    "warning_level" "werror"
    "version" "license" "description"
    "meson_version"
    "yes" "no")
  "Meson 关键字列表。")

(defconst nano-lex-yacc-keywords
  '("yyparse" "yylex" "yyerror" "yywrap" "yytext" "yyleng" "yylval"
    "yychar" "yydebug" "yynerrs"
    "YYSTYPE" "YYLTYPE" "YYCTYPE"
    "yy_create_buffer" "yy_delete_buffer" "yy_scan_buffer"
    "yy_scan_string" "yy_scan_bytes" "yy_flush_buffer"
    "yy_switch_to_buffer" "yy_load_buffer_state"
    "yypush_buffer_state" "yypop_buffer_state"
    "yyensure_buffer_stack"
    "yyrestart" "yy_flex_debug"
    "YY_USER_ACTION" "YY_BREAK" "YY_END_OF_BUFFER"
    "YY_END_OF_BUFFER_CHAR"
    "ECHO" "YY_INPUT" "YY_DECL"
    "YY_RULE_SETUP"
    "YY_NUM_RULES"
    "YY_MORE_ADJ" "YY_DO_BEFORE_ACTION"
    "YY_STATE_EOF" "YY_FLUSH_BUFFER"
    "YY_READ_BUF_SIZE" "YY_BUF_SIZE"
    "YY_USER_INIT"
    "YY_SKIP_YYWRAP"
    "YY_NO_UNPUT"
    "YY_NO_INPUT"
    "YY_STACK_USED"
    "YY_NEVER_INTERACTIVE"
    "YY_MAIN"
    "always-interactive"
    "array" "pointer" "full" "fast"
    "8bit" "align" "backup" "batch"
    "c++" "caseful" "caseless" "debug"
    "default" "ecs" "graph" "interactive"
    "lex-compat" "meta-ecs"
    "perf-report" "read" "stack"
    "stdinit" "stdout"
    "unicode" "verbose"
    "warn" "yylineno" "yymore"
    "yyterminate" "unput"
    "input" "output"
    "REJECT"
    "BEGIN"
    "option" "require"
    "definitions" "rules" "epilogue"
    "%%" "%{" "%}"
    "%union" "%token" "%type" "%left" "%right" "%nonassoc"
    "%prec" "%pure_parser" "%lex-param" "%parse-param"
    "%error-verbose" "expect"
    "define" "defines" "header"
    "output" "outfile"
    "verbose" "error-verbose"
    "name-prefix" "file-prefix"
    "graph" "xml"
    "report" "skeleton"
    "token-table"
    "yyerrok" "yyclearin" "YYACCEPT" "YYABORT" "YYERROR"
    "YYRECOVERING" "YYBACKUP"
    "YYEMPTY" "YYEOF" "YYINITDEPTH" "YYMAXDEPTH"
    "YYLAST" "YYNSTATES" "YYNTOKENS" "YYNRULES"
    "YYTRANSLATE" "YYUNDEF"
    "YYPARSE_PARAM" "YYLEX_PARAM"
    "YYENABLE_NLS" "YYLTYPE_IS_DECLARED"
    "YYSTYPE_IS_DECLARED"
    "YYSIZE_T"
    "YYFREE" "YYSTACK_ALLOC_MAXIMUM"
    "YYDPRINTF" "YY_SYMBOL_PRINT"
    "YY_STACK_PRINT" "YY_REDUCE_PRINT"
    "yypact" "yydefact" "yypgoto" "yydefgoto"
    "yyr1" "yyr2" "yytable" "yycheck"
    "yystos" "yyrline"
    "yytranslate"
    "yyvsp" "yyssp" "yyss" "yyvs"
    "yystacksize"
    "parse" "parse-param"
    "lex-param"
    "pure" "pure-parser"
    "require" "version"
    "locations" "glr"
    "initial-action"
    "destructor"
    "printer"
    "api.namespace" "api.parser.class"
    "api.token.constructor"
    "api.token.raw"
    "api.token.prefix"
    "api.token.type"
    "api.value.automove"
    "api.value.type"
    "code"
    "code-prologue"
    "prologue"
    "requires"
    "start"
    "token"
    "type"
    "union"
    "language"
    "output-file"
    "yes" "no")
  "Lex / Yacc 关键字列表。")

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
  (nano-eglot-ensure))

(add-hook 'c-mode-hook #'nano-c-mode-setup)
(add-hook 'c++-mode-hook #'nano-c-mode-setup)

;; Go — gopls
(use-package go-mode
  :defer t
  :mode "\\.go\\'"
  :config (add-hook 'go-mode-hook #'nano-eglot-ensure))

;; Java — jdtls
(add-to-list 'auto-mode-alist '("\\.java\\'" . java-mode))
(with-eval-after-load 'java-mode
  (add-hook 'java-mode-hook
            (lambda () (setq-local company-keywords nano-java-keywords)))
  (add-hook 'java-mode-hook #'nano-eglot-ensure))

;; Kotlin — kotlin-language-server
(use-package kotlin-mode
  :defer t
  :mode ("\\.kt\\'" "\\.kts\\'")
  :config
  (add-hook 'kotlin-mode-hook
            (lambda () (setq-local company-keywords nano-kotlin-keywords)))
  (add-hook 'kotlin-mode-hook #'nano-eglot-ensure))

;; Rust — rust-analyzer
(use-package rust-mode
  :defer t
  :mode "\\.rs\\'"
  :config (add-hook 'rust-mode-hook #'nano-eglot-ensure))

;; Python — pylsp/pyright
(use-package python-mode
  :defer t
  :mode "\\.py\\'"
  :config (add-hook 'python-mode-hook #'nano-eglot-ensure))

;; JavaScript — typescript-language-server
(use-package js2-mode
  :defer t
  :mode ("\\.js\\'" "\\.jsx\\'" "\\.mjs\\'")
  :config (add-hook 'js2-mode-hook #'nano-eglot-ensure))

;; TypeScript — vtsls
(use-package typescript-mode
  :defer t
  :mode ("\\.ts\\'" "\\.tsx\\'")
  :config (add-hook 'typescript-mode-hook #'nano-eglot-ensure))

;; CMake — cmake-language-server
(use-package cmake-mode
  :defer t
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'")
  :config
  (add-hook 'cmake-mode-hook
            (lambda () (setq-local company-keywords nano-cmake-keywords)))
  (add-hook 'cmake-mode-hook #'nano-eglot-ensure))

;; YAML
(use-package yaml-mode
  :defer t
  :mode ("\\.yml\\'" "\\.yaml\\'"))

;; TOML
(use-package toml-mode
  :defer t
  :mode "\\.toml\\'")

;; JSON
(use-package json-mode
  :defer t
  :mode "\\.json\\'")

;; Markdown
(use-package markdown-mode
  :defer t
  :mode ("\\.md\\'" "\\.markdown\\'"))

;; Dockerfile
(use-package dockerfile-mode
  :defer t
  :mode "Dockerfile\\'"
  :config
  (add-hook 'dockerfile-mode-hook
            (lambda () (setq-local company-keywords nano-dockerfile-keywords))))

;; Lua
(use-package lua-mode
  :defer t
  :mode "\\.lua\\'"
  :config
  (add-hook 'lua-mode-hook
            (lambda () (setq-local company-keywords nano-lua-keywords))))

;; Makefile
(add-to-list 'auto-mode-alist '("Makefile\\'" . makefile-mode))
(add-to-list 'auto-mode-alist '("GNUmakefile\\'" . makefile-mode))
(add-to-list 'auto-mode-alist '("\\.mak\\'" . makefile-mode))
(add-to-list 'auto-mode-alist '("\\.mk\\'" . makefile-mode))
(with-eval-after-load 'makefile-mode
  (add-hook 'makefile-mode-hook
            (lambda () (setq-local company-keywords nano-makefile-keywords))))

;; Autoconf
(add-to-list 'auto-mode-alist '("configure\\.ac\\'" . autoconf-mode))
(add-to-list 'auto-mode-alist '("Makefile\\.am\\'" . autoconf-mode))
(add-to-list 'auto-mode-alist '("\\.ac\\'" . autoconf-mode))
(add-to-list 'auto-mode-alist '("\\.in\\'" . autoconf-mode))
(with-eval-after-load 'autoconf-mode
  (add-hook 'autoconf-mode-hook
            (lambda () (setq-local company-keywords nano-makefile-keywords))))

;; Meson
(use-package meson-mode
  :defer t
  :mode ("meson\\.build\\'" "meson_options\\.txt\\'")
  :config
  (add-hook 'meson-mode-hook
            (lambda () (setq-local company-keywords nano-meson-keywords))))

;; Lex / Yacc
(add-to-list 'auto-mode-alist '("\\.l\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.y\\'" . c-mode))
(add-hook 'c-mode-hook
          (lambda ()
            (when (and buffer-file-name
                       (string-match "\\.[ly]\\'" buffer-file-name))
              (setq-local company-keywords nano-lex-yacc-keywords))))

(provide 'nano-lsp)
;;; nano-lsp.el ends here
