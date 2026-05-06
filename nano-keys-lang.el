;;; nano-keys-lang.el --- Nano syntax highlighting for 40+ languages -*- lexical-binding: t; -*-

;; Copyright (C) 2024
;; Author: nano-keys contributors
;; Version: 0.4.0
;; Package-Requires: ((emacs "27.1"))
;; Keywords: convenience, nano, faces
;; URL: https://github.com/nano-keys/nano-keys

;;; Commentary:
;;
;; Per-language font-lock keyword definitions replicating nano's
;; nanorc syntax highlighting rules for 40+ languages.
;;
;; Usage:
;;   (require 'nano-keys-lang)
;;   (nano-keys-lang-mode 1)

;;; Code:

(require 'nano-keys)

;; ============================================================
;; Helpers
;; ============================================================
(defsubst nano-keys-lang--face (face) `(0 ',face t))

;; ============================================================
;; C / C++
;; ============================================================
(defun nano-keys-lang--setup-c ()
  (font-lock-add-keywords
   nil
   `(;; brightred: ALL_CAPS constants
     (,(rx bow (group (+ (in "A_Z")) (+ (in "0-9A-Z_"))) (not (any "(")))
      (1 'font-lock-type-face t))
     ;; green: types, keywords, builtins
     (,(rx bow (or "float" "double" "bool" "char" "wchar_t" "int" "short" "long"
                   "sizeof" "enum" "void" "static" "const" "struct" "union"
                   "typedef" "extern" "signed" "unsigned" "inline"
                   "class" "namespace" "template" "public" "protected" "private"
                   "typename" "this" "friend" "virtual" "using" "mutable"
                   "volatile" "register" "explicit"
                   "for" "if" "while" "do" "else" "case" "default" "switch"
                   "try" "throw" "catch" "operator" "new" "delete"
                   "const_cast" "dynamic_cast" "reinterpret_cast" "static_cast"
                   "alignas" "alignof" "asm" "auto" "compl" "concept"
                   "constexpr" "decltype" "export" "noexcept" "nullptr"
                   "requires" "static_assert" "thread_local" "typeid"
                   "override" "final"
                   "and" "and_eq" "bitand" "bitor" "not" "not_eq" "or" "or_eq"
                   "xor" "xor_eq"
                   "__attribute__" "__aligned" "__asm" "__builtin" "__hidden"
                   "__inline" "__packed" "__restrict" "__section" "__typeof"
                   "__weak")
         (not (any "(")))
      (1 'font-lock-keyword-face t))
     ;; brightmagenta: flow control
     (,(rx bow (or "goto" "continue" "break" "return")) (not (any "(")))
      (1 'font-lock-builtin-face t))
     ;; brightcyan: preprocessor
     (,(rx bol (* space) "#" (* space)
           (group (or "define" "include" "undef" "ifndef" "endif" "elif"
                      "else" "if" "warning" "error")))
      (1 'font-lock-preprocessor-face t))
     ;; yellow: operators
     (,(rx (any ".:;,+*|=!%") (any "<>/-&"))
      (0 'font-lock-string-face t))
     ;; magenta: parentheses
     (,(rx (any "()[]{}"))
      (0 'font-lock-function-name-face t))
     ;; cyan: angle-bracket includes
     (,(rx "<" (+ (not (any "= 	"))) ">")
      (0 'font-lock-constant-face t))
     ;; yellow: printf format
     (,(rx "%" (optional (any "#0-+"))
           (optional (any "hh" "h" "l" "ll" "q" "L" "j" "z" "Z" "t"))
           (any "A-Za-z"))
      (0 'font-lock-string-face t))
     ;; brightblue: single-line comments
     (,(rx "//" (* nonl))
      (0 'font-lock-comment-face t))
     ;; brightblue: multi-line comments
     (,(rx "/*" (* (not "*")) "*" "/")
      (0 'font-lock-comment-face t))
     ;; magenta: javadoc tags
     (,(rx (or "@param" "@return" "@author") (* nonl))
      (0 'font-lock-function-name-face t))))
  'append)

(add-hook 'c-mode-hook #'nano-keys-lang--setup-c)
(add-hook 'c++-mode-hook #'nano-keys-lang--setup-c)


;; ============================================================
;; Python
;; ============================================================
(defun nano-keys-lang--setup-python ()
  (font-lock-add-keywords
   nil
   `(;; cyan: built-in objects
     (,(rx bow (or "None" "self" "True" "False"))
      (0 'font-lock-constant-face t))
     ;; cyan: dunder attributes
     (,(rx bow "__"
           (or "builtin__" "dict__" "methods__" "members__" "class__"
               "bases__" "import__" "name__" "doc__" "self__" "debug__")
           "__")
      (0 'font-lock-constant-face t))
     ;; cyan: built-in functions
     (,(rx bow
           (or "abs" "append" "apply" "buffer" "callable" "chr" "clear" "close"
               "closed" "cmp" "coerce" "compile" "complex" "conjugate" "copy"
               "count" "delattr" "dir" "divmod" "eval" "execfile" "exec"
               "extend" "fileno" "filter" "float" "flush" "get" "getattr"
               "globals" "has_key" "hasattr" "hash" "hex" "id" "index" "input"
               "insert" "int" "intern" "isatty" "isinstance" "issubclass"
               "items" "keys" "len" "list" "locals" "long" "map" "max" "min"
               "mode" "name" "oct" "open" "ord" "pop" "pow" "print" "range"
               "raw_input" "read" "readline" "readlines" "reduce" "reload"
               "remove" "repr" "reverse" "round" "seek" "setattr" "slice"
               "softspace" "sort" "str" "tell" "truncate" "tuple" "type"
               "unichr" "unicode" "update" "values" "vars" "write" "writelines"
               "xrange" "zip" "bool")
           eow)
      (0 'font-lock-constant-face t))
     ;; cyan: dunder methods
     (,(rx bow "__"
           (or "abs" "add" "and" "call" "cmp" "coerce" "complex" "concat"
               "contains" "del" "delattr" "delitem" "delslice" "div" "divmod"
               "float" "getattr" "getitem" "getslice" "hash" "hex" "init"
               "int" "inv" "invert" "len" "long" "lshift" "mod" "mul" "neg"
               "nonzero" "oct" "or" "pos" "pow" "radd" "rand" "rcmp" "rdiv"
               "rdivmod" "repeat" "repr" "rlshift" "rmod" "rmul" "ror" "rpow"
               "rrshift" "rshift" "rsub" "rxor" "setattr" "setitem" "setslice"
               "str" "sub" "xor" "bool")
           "__" eow)
      (0 'font-lock-constant-face t))
     ;; cyan: exception classes
     (,(rx bow
           (or "Exception" "StandardError" "ArithmeticError" "LookupError"
               "EnvironmentError" "AssertionError" "AttributeError" "EOFError"
               "FloatingPointError" "IOError" "ImportError" "IndexError"
               "KeyError" "KeyboardInterrupt" "MemoryError" "NameError"
               "NotImplementedError" "OSError" "OverflowError" "RuntimeError"
               "SyntaxError" "SystemError" "SystemExit" "TypeError"
               "UnboundLocalError" "UnicodeError" "ValueError" "WindowsError"
               "ZeroDivisionError")
           eow)
      (0 'font-lock-constant-face t))
     ;; brightcyan: type names
     (,(rx bow
           (or "NoneType" "TypeType" "IntType" "LongType" "FloatType"
               "ComplexType" "StringType" "UnicodeType" "BufferType"
               "TupleType" "ListType" "DictType" "FunctionType" "LambdaType"
               "CodeType" "ClassType" "UnboundMethodType" "InstanceType"
               "MethodType" "BuiltinFunctionType" "BuiltinMethodType"
               "ModuleType" "FileType" "XRangeType" "TracebackType"
               "FrameType" "SliceType" "EllipsisType")
           eow)
      (0 'font-lock-constant-face t))
     ;; brightcyan: function definitions
     (,(rx "def" (+ space) (group (+ (in "a-zA-Z0-9_"))))
      (1 'font-lock-constant-face t))
     ;; brightblue: keywords
     (,(rx bow
           (or "and" "as" "assert" "async" "await" "break" "class" "continue"
               "def" "del" "elif" "else" "except" "finally" "for" "from"
               "global" "if" "import" "in" "is" "lambda" "map" "not" "or"
               "pass" "raise" "return" "try" "with" "while" "yield")
           eow)
      (0 'font-lock-comment-face t))
     ;; brightgreen: decorators
     (,(rx "@" (+ nonl) "(")
      (0 'font-lock-doc-face t))
     ;; magenta: operators
     (,(rx (any ".:;,+*|=!%@")) (0 'font-lock-function-name-face t))
     (,(rx (any "<>/-&"))         (0 'font-lock-function-name-face t))
     ;; magenta: parentheses
     (,(rx (any "()[]{}"))         (0 'font-lock-function-name-face t))
     ;; brightyellow: numbers
     (,(rx bow
           (or (seq (+ digit) "." (+ digit) (? "j"))
               (+ digit) (any "Lj")
               "0" (? "o") (+ (in "0-7")) (? "L")
               "0x" (+ (in "0-9a-fA-F")) (? "L")
               "0b" (+ (in "01")))
           eow)
      (0 'font-lock-number-face t))
     ;; yellow: strings
     (,(rx "'"  (* (not (any "'\\"))) "'"  (? "'") (? "'"))  (0 'font-lock-string-face t))
     (,(rx "\"" (* (not (any "\"\\"))) "\"" (? "\"") (? "\"")) (0 'font-lock-string-face t))
     ;; green: comments
     (,(rx (or bol (* space)) "#" (* nonl)) (0 'font-lock-keyword-face t))
     ;; TODO
     (,(rx (or "FIXME" "TODO" "XXX")) (0 'font-lock-warning-face t)))
  'append)

(add-hook 'python-mode-hook #'nano-keys-lang--setup-python)
(add-hook 'python-ts-mode-hook #'nano-keys-lang--setup-python)


;; ============================================================
;; JavaScript / TypeScript
;; ============================================================
(defun nano-keys-lang--setup-javascript ()
  (font-lock-add-keywords
   nil
   `(;; blue/brightblue: numbers
     (,(rx bow (optional "-")
           (or (seq (+ digit) (? (seq "." (* digit)))
                    (? (seq (any "EePp") (optional "+-") (+ digit)))
                    (? (any "fFlL")))
               (seq "0" (in "0-7") (* (in "0-7")))
               (seq "0x" (+ (in "0-9a-fA-F"))))
           eow)
      (0 'font-lock-comment-face t))
     ;; brightblue: function calls
     (,(rx (in "a-zA-Z_") (* (in "a-zA-Z0-9_")) (* space) "(")
      (0 'font-lock-comment-face t))
     ;; cyan: control keywords
     (,(rx bow
           (or "break" "case" "catch" "continue" "default" "delete" "do" "else"
               "finally" "for" "function" "get" "if" "in" "instanceof" "new"
               "return" "set" "switch" "this" "throw" "try" "typeof" "var"
               "void" "while" "with" "null" "undefined" "NaN" "import" "as"
               "from" "export" "const" "let" "class" "extends" "get" "set"
               "of" "async" "await" "yield")
           eow)
      (0 'font-lock-constant-face t))
     ;; brightcyan: booleans
     (,(rx bow (or "true" "false"))
      (0 'font-lock-constant-face t))
     ;; green: built-in objects
     (,(rx bow
           (or "Array" "Boolean" "Date" "Enumerator" "Error" "Function"
               "Math" "Map" "WeakMap" "Set" "WeakSet" "Promise" "Symbol"
               "Number" "Object" "RegExp" "String")
           eow)
      (0 'font-lock-keyword-face t))
     ;; red: operators
     (,(rx (any "-+/*=<>!~%?:&|"))
      (0 'font-lock-type-face t))
     ;; magenta: regex
     (,(rx "/" (* (not (any "/\\"))) "/" (* (any "gim")))
      (0 'font-lock-function-name-face t))
     ;; yellow: strings
     (,(rx (or (seq "\"" (* (not (any "\"\\"))) "\"")
               (seq "'"  (* (not (any "'\\")))  "'")
               (seq "`"  (* (not (any "`$")))  "`"))
      (0 'font-lock-string-face t))
     ;; brightblack: comments
     (,(rx (or (seq "//" (* nonl))
               (seq "/*" (* nonl) "*/")))
      (0 'font-lock-comment-face t))
     ;; TODO
     (,(rx "TODO" (? ":"))
      (0 'font-lock-constant-face t)))
  'append)

(add-hook 'js-mode-hook #'nano-keys-lang--setup-javascript)
(add-hook 'js2-mode-hook #'nano-keys-lang--setup-javascript)
(add-hook 'typescript-mode-hook #'nano-keys-lang--setup-javascript)
(add-hook 'typescript-ts-mode-hook #'nano-keys-lang--setup-javascript)
(add-hook 'tsx-ts-mode-hook #'nano-keys-lang--setup-javascript)


;; ============================================================
;; Go
;; ============================================================
(defun nano-keys-lang--setup-go ()
  (font-lock-add-keywords
   nil
   `(;; brightblue: built-in functions
     (,(rx bow
           (or "append" "cap" "close" "complex" "copy" "delete" "imag" "len"
               "make" "new" "panic" "print" "println" "protect" "real" "recover")
           eow)
      (0 'font-lock-comment-face t))
     ;; green: types
     (,(rx bow
           (or "int" "int8" "int16" "int32" "int64"
               "uint" "uint8" "uint16" "uint32" "uint64"
               "float32" "float64" "complex64" "complex128"
               "uintptr" "byte" "rune" "string" "interface" "bool" "map" "chan" "error")
           eow)
      (0 'font-lock-keyword-face t))
     ;; cyan: keywords
     (,(rx bow
           (or "package" "import" "const" "var" "type" "struct" "func" "go"
               "defer" "nil" "iota" "for" "range" "if" "else" "case" "default"
               "switch" "return")
           eow)
      (0 'font-lock-constant-face t))
     ;; brightred: flow control
     (,(rx bow (or "go" "goto" "break" "continue"))
      (0 'font-lock-type-face t))
     ;; brightcyan: booleans
     (,(rx bow (or "true" "false"))
      (0 'font-lock-constant-face t))
     ;; red: operators
     (,(rx (any "-+/*=<>!~%&|^")) (0 'font-lock-type-face t))
     (,(rx ":=")                  (0 'font-lock-type-face t))
     ;; blue: numbers
     (,(rx bow (or (+ digit) "0x" (* (in "0-9a-fA-F")) "'" nonl "'") eow)
      (0 'font-lock-comment-face t))
     ;; yellow: strings & raw strings
     (,(rx (or (seq "\"" (* (not (any "\"\\"))) "\"")
               (seq "'"  (* (not (any "'\\")))  "'")
               "`" (* (not "`")) "`")
      (0 'font-lock-string-face t))
     ;; brightblack: comments
     (,(rx (or (seq (or bol (* space)) "//" (* nonl))
               (seq "/*" (* nonl) "*/")))
      (0 'font-lock-comment-face t))
     ;; TODO
     (,(rx "TODO" (? ":"))
      (0 'font-lock-constant-face t)))
  'append)

(add-hook 'go-mode-hook #'nano-keys-lang--setup-go)
(add-hook 'go-ts-mode-hook #'nano-keys-lang--setup-go)


;; ============================================================
;; Java
;; ============================================================
(defun nano-keys-lang--setup-java ()
  (font-lock-add-keywords
   nil
   `(;; green: types
     (,(rx bow
           (or "boolean" "byte" "char" "double" "float" "int" "long" "new"
               "short" "this" "transient" "void")
           eow)
      (0 'font-lock-keyword-face t))
     ;; red: keywords
     (,(rx bow
           (or "break" "case" "catch" "continue" "default" "do" "else" "finally"
               "for" "if" "return" "switch" "throw" "try" "while")
           eow)
      (0 'font-lock-type-face t))
     ;; cyan: modifiers
     (,(rx bow
           (or "abstract" "class" "extends" "final" "implements" "import"
               "instanceof" "interface" "native" "package" "private" "protected"
               "public" "static" "strictfp" "super" "synchronized" "throws"
               "volatile")
           eow)
      (0 'font-lock-constant-face t))
     ;; red: strings
     (,(rx "\"" (* (not (any "\"\\"))) "\"")
      (0 'font-lock-type-face t))
     ;; yellow: booleans/null
     (,(rx bow (or "true" "false" "null"))
      (0 'font-lock-string-face t))
     ;; brightyellow: numbers
     (,(rx bow
           (or (seq (+ digit) "." (+ digit))
               (+ digit)
               "0" (+ (in "0-7"))
               "0x" (+ (in "0-9a-f")))
           eow)
      (0 'font-lock-number-face t))
     ;; blue: comments
     (,(rx (or (seq "//" (* nonl))
               (seq "/*" (* nonl) "*/")))
      (0 'font-lock-comment-face t))
     ;; brightblue: javadoc
     (,(rx "/**" (* nonl) "*/")
      (0 'font-lock-comment-face t))
     ;; magenta: javadoc tags
     (,(rx (or "@param" "@return" "@author") (* nonl))
      (0 'font-lock-function-name-face t)))
  'append)

(add-hook 'java-mode-hook #'nano-keys-lang--setup-java)
(add-hook 'java-ts-mode-hook #'nano-keys-lang--setup-java)


;; ============================================================
;; Lua
;; ============================================================
(defun nano-keys-lang--setup-lua ()
  (font-lock-add-keywords
   nil
   `(;; brightyellow: operators & stdlib modules
     (,(rx (or ":" "**" "*" "/" "%" "+" "-" "^" ">" ">=" "<" "<=" "~=" "="
               ".." "not" "and" "or"))
      (0 'font-lock-number-face t))
     (,(rx bow (or "debug" "string" "math" "table" "io" "coroutine" "os" "utf8" "bit32") ".")
      (0 'font-lock-number-face t))
     ;; brightblue: statements
     (,(rx bow
           (or "do" "end" "while" "repeat" "until" "if" "elseif" "then" "else"
               "for" "in" "function" "local" "return")
           eow)
      (0 'font-lock-comment-face t))
     ;; brightyellow: standard library functions
     (,(rx bow
           (or "_ENV" "_G" "_VERSION" "assert" "collectgarbage" "dofile" "error"
               "getfenv" "getmetatable" "ipairs" "load" "loadfile" "module"
               "next" "pairs" "pcall" "print" "rawequal" "rawget" "rawlen"
               "rawset" "require" "select" "setfenv" "setmetatable" "tonumber"
               "tostring" "type" "unpack" "xpcall")
           (* space) "(")
      (0 'font-lock-number-face t))
     ;; brightyellow: io.* functions
     (,(rx bow "io."
           (or "close" "flush" "input" "lines" "open" "output" "popen" "read"
               "tmpfile" "type" "write")
           eow)
      (0 'font-lock-number-face t))
     ;; brightyellow: string.* functions
     (,(rx bow "string."
           (or "byte" "char" "dump" "find" "format" "gmatch" "gsub" "len"
               "lower" "match" "pack" "packsize" "rep" "reverse" "sub" "unpack"
               "upper")
           eow)
      (0 'font-lock-number-face t))
     ;; brightyellow: table.* functions
     (,(rx bow "table."
           (or "concat" "insert" "maxn" "move" "pack" "remove" "sort" "unpack")
           eow)
      (0 'font-lock-number-face t))
     ;; brightyellow: math.* functions (sample)
     (,(rx bow "math."
           (or "abs" "acos" "asin" "atan2" "atan" "ceil" "cosh" "cos" "deg"
               "exp" "floor" "fmod" "frexp" "huge" "ldexp" "log10" "log" "max"
               "maxinteger" "min" "mininteger" "modf" "pi" "pow" "rad" "random"
               "randomseed" "sinh" "sqrt" "tan" "tointeger" "type" "ult")
           eow)
      (0 'font-lock-number-face t))
     ;; brightmagenta: constants
     (,(rx bow (or "false" "nil" "true"))
      (0 'font-lock-function-name-face t))
     ;; brightgreen: external files
     (,(rx bow (or "dofile" "require" "include"))
      (0 'font-lock-doc-face t))
     ;; red: numbers
     (,(rx bow (+ digit))
      (0 'font-lock-type-face t))
     ;; brightmagenta: parentheses
     (,(rx (any "()[]{}"))
      (0 'font-lock-function-name-face t))
     ;; red: strings
     (,(rx (or (seq "\"" (* (not (any "\"\\"))) "\"")
               (seq "'"  (* (not (any "'\\")))  "'")))
      (0 'font-lock-type-face t))
     ;; brightcyan: shebang
     (,(rx bol "#!" (* nonl))
      (0 'font-lock-preprocessor-face t))
     ;; green: comments
     (,(rx "--" (* nonl))
      (0 'font-lock-keyword-face t)))
  'append)

(add-hook 'lua-mode-hook #'nano-keys-lang--setup-lua)


;; ============================================================
;; Ruby
;; ============================================================
(defun nano-keys-lang--setup-ruby ()
  (font-lock-add-keywords
   nil
   `(;; yellow: reserved words
     (,(rx bow
           (or "BEGIN" "END" "alias" "and" "begin" "break" "case" "class" "def"
               "defined?" "do" "else" "elsif" "end" "ensure" "false" "for" "if"
               "in" "module" "next" "nil" "not" "or" "redo" "rescue" "retry"
               "return" "self" "super" "then" "true" "undef" "unless" "until"
               "when" "while" "yield")
           eow)
      (0 'font-lock-string-face t))
     ;; brightblue: constants
     (,(rx (or "$" "@" "@@") ?\< (in "A-Z") (+ (in "0-9A-Z_a-z")) (? \>))
      (0 'font-lock-comment-face t))
     ;; brightyellow: __FILE__ / __LINE__
     (,(rx bow (or "__FILE__" "__LINE__"))
      (0 'font-lock-number-face t))
     ;; brightmagenta: regex
     (,(rx "/" (* (not (any "/\\"))) "/" (* (any "iomx")))
      (0 'font-lock-function-name-face t))
     ;; brightblue: backticks / %x
     (,(rx (or (seq "`" (* (not "`")) "`")
               (seq "%x{" (* (not "}")) "}"))
      (0 'font-lock-comment-face t))
     ;; green: double-quoted strings
     (,(rx "\"" (* (not (any "\"\\"))) "\"")
      (0 'font-lock-keyword-face t))
     ;; green: single-quoted strings
     (,(rx "'" (* (not (any "'\\"))) "'")
      (0 'font-lock-keyword-face t))
     ;; brightgreen: expression substitution
     (,(rx "#{" (* (nonl)) "}")
      (0 'font-lock-doc-face t))
     ;; cyan: comments
     (,(rx "#" (* nonl))
      (0 'font-lock-constant-face t))
     ;; brightcyan: TODO/FIXME
     (,(rx (or "XXX" "TODO" "FIXME" "???"))
      (0 'font-lock-constant-face t)))
  'append)

(add-hook 'ruby-mode-hook #'nano-keys-lang--setup-ruby)
(add-hook 'ruby-ts-mode-hook #'nano-keys-lang--setup-ruby)


;; ============================================================
;; Rust
;; ============================================================
(defun nano-keys-lang--setup-rust ()
  (font-lock-add-keywords
   nil
   `(;; magenta: function definitions
     (,(rx "fn" (+ space) (group (+ (in "a-z0-9_"))))
      (1 'font-lock-function-name-face t))
     ;; yellow: reserved words
     (,(rx bow
           (or "abstract" "alignof" "as" "become" "box" "break" "const" "continue"
               "crate" "do" "else" "enum" "extern" "false" "final" "fn" "for"
               "if" "impl" "in" "let" "loop" "macro" "match" "mod" "move" "mut"
               "offsetof" "override" "priv" "pub" "pure" "ref" "return" "sizeof"
               "static" "self" "struct" "super" "true" "trait" "type" "typeof"
               "unsafe" "unsized" "use" "virtual" "where" "while" "yield")
           eow)
      (0 'font-lock-string-face t))
     ;; red: macros
     (,(rx (+ (in "a-z_")) "!")
      (0 'font-lock-type-face t))
     ;; magenta: constants (SCREAMING_SNAKE_CASE)
     (,(rx bow (+ (in "A-Z")) (+ (in "A-Z_")) eow)
      (0 'font-lock-function-name-face t))
     ;; magenta: types (PascalCase)
     (,(rx bow (in "A-Z") (+ (in "a-z")) eow)
      (0 'font-lock-function-name-face t))
     ;; green: strings
     (,(rx "\"" (* (not (any "\"\\"))) "\"")
      (0 'font-lock-keyword-face t))
     ;; blue: comments
     (,(rx (or (seq "//" (* nonl))
               (seq "/*" (* nonl) "*/")))
      (0 'font-lock-comment-face t))
     ;; magenta: attributes
     (,(rx "#![" (* nonl) "]")
      (0 'font-lock-function-name-face t))
     ;; brightcyan: TODO/FIXME
     (,(rx (or "XXX" "TODO" "FIXME" "???"))
      (0 'font-lock-constant-face t)))
  'append)

(add-hook 'rust-mode-hook #'nano-keys-lang--setup-rust)
(add-hook 'rust-ts-mode-hook #'nano-keys-lang--setup-rust)


;; ============================================================
;; PHP
;; ============================================================
(defun nano-keys-lang--setup-php ()
  (font-lock-add-keywords
   nil
   `(;; brightblue: constructs & keywords
     (,(rx bow
           (or "class" "extends" "goto" "var" "function" "echo" "case" "break"
               "default" "exit" "switch" "if" "else" "elseif" "endif" "foreach"
               "endforeach" "while" "public" "private" "protected" "return"
               "true" "false" "null" "TRUE" "FALSE" "NULL" "const" "static"
               "extends" "as" "array" "require" "include" "require_once"
               "include_once" "define" "do" "continue" "declare" "goto" "print"
               "in" "namespace" "use")
           eow)
      (0 'font-lock-comment-face t))
     ;; green: variables
     (,(rx "$" (+ (in "a-zA-Z0-9_")))
      (0 'font-lock-keyword-face t))
     ;; brightblue: special variables
     (,(rx (or "$this" "parent::" "self::"))
      (0 'font-lock-comment-face t))
     ;; magenta: numbers
     (,(rx bow (optional (any "+-")) (+ digit) (? "." (* digit))
           (? (seq (any "eE") (optional (any "+-")) (+ digit))))
      (0 'font-lock-function-name-face t))
     (,(rx "0x" (+ (in "0-9a-zA-Z")))
      (0 'font-lock-function-name-face t))
     ;; red: strings
     (,(rx (or (seq "\"" (* (not (any "\"\\"))) "\"")
               (seq "'"  (* (not (any "'\\")))  "'")))
      (0 'font-lock-type-face t))
     ;; brightyellow: comments
     (,(rx (or "#" "//") (* nonl))
      (0 'font-lock-doc-face t))
     (,(rx "/*" (* nonl) "*/")
      (0 'font-lock-doc-face t))
     ;; red: PHP tags
     (,(rx (or "<?php" "<?php " "<?=" "?>"))
      (0 'font-lock-type-face t)))
  'append)

(add-hook 'php-mode-hook #'nano-keys-lang--setup-php)


;; ============================================================
;; Perl
;; ============================================================
(defun nano-keys-lang--setup-perl ()
  (font-lock-add-keywords
   nil
   `(;; red: built-in functions
     (,(rx bow
           (or "accept" "alarm" "atan2" "bind" "binmode" "caller" "chdir" "chmod"
               "chop" "chown" "chroot" "close" "closedir" "connect" "cos" "crypt"
               "dbmclose" "dbmopen" "defined" "delete" "die" "do" "dump" "each"
               "eof" "eval" "exec" "exists" "exit" "exp" "fcntl" "fileno" "flock"
               "fork" "getc" "getlogin" "getpeername" "getpgrp" "getppid"
               "getpriority" "getpwnam" "getgrnam" "gethostbyname" "getnetbyname"
               "getprotobyname" "getservbyname" "getpwuid" "getgrgid"
               "gethostbyaddr" "getnetbyaddr" "getprotobynumber" "getservbyport"
               "getsockname" "getsockopt" "gmtime" "goto" "grep" "hex" "index"
               "int" "ioctl" "join" "keys" "kill" "last" "length" "link" "listen"
               "local" "localtime" "log" "lstat" "mkdir" "msgctl" "msgget"
               "msgrcv" "msgsnd" "next" "oct" "open" "opendir" "ord" "pack"
               "pipe" "pop" "printf" "push" "rand" "read" "readdir" "readlink"
               "recv" "redo" "rename" "require" "reset" "return" "reverse"
               "rewinddir" "rmdir" "scalar" "seek" "seekdir" "select" "semctl"
               "semget" "semop" "send" "setpgrp" "setpriority" "setsockopt" "shift"
               "shmctl" "shmget" "shmread" "shmwrite" "shutdown" "sin" "sleep"
               "socket" "socketpair" "sort" "splice" "split" "sprintf" "sqrt"
               "srand" "stat" "study" "substr" "symlink" "syscall" "sysread"
               "sysseek" "system" "syswrite" "tell" "telldir" "time" "truncate"
               "umask" "undef" "unlink" "unpack" "unshift" "utime" "values" "vec"
               "wait" "waitpid" "wantarray" "warn" "write")
           eow)
      (0 'font-lock-type-face t))
     ;; magenta: control keywords
     (,(rx bow
           (or "continue" "else" "elsif" "do" "for" "foreach" "if" "unless"
               "until" "while" "eq" "ne" "lt" "gt" "le" "ge" "cmp" "x" "my"
               "sub" "use" "package" "can" "isa")
           eow)
      (0 'font-lock-function-name-face t))
     ;; yellow: strings
     (,(rx (or (seq "\"" (* (not (any "\"\\"))) "\"")
               (seq "'"  (* (not (any "'\\")))  "'")
               (seq "qq|" (* (not "|")) "|")))
      (0 'font-lock-string-face t))
     ;; green: comments
     (,(rx "#" (* nonl))
      (0 'font-lock-keyword-face t)))
  'append)

(add-hook 'perl-mode-hook #'nano-keys-lang--setup-perl)
(add-hook 'cperl-mode-hook #'nano-keys-lang--setup-perl)


;; ============================================================
;; Shell / Bash / Zsh
;; ============================================================
(defun nano-keys-lang--setup-sh ()
  (font-lock-add-keywords
   nil
   `(;; green: keywords
     (,(rx bow
           (or "case" "do" "done" "elif" "else" "esac" "fi" "for" "function"
               "if" "in" "select" "then" "time" "until" "while")
           eow)
      (0 'font-lock-keyword-face t))
     ;; green: syntax chars
     (,(rx (any "{}()[];`|\\$>=!&|"))
      (0 'font-lock-keyword-face t))
     ;; brightblue: builtins
     (,(rx bow
           (or "alias" "bg" "bind" "break" "builtin" "caller" "cd" "command"
               "compgen" "complete" "compopt" "continue" "declare" "dirs" "disown"
               "echo" "enable" "eval" "exec" "exit" "export" "false" "fc" "fg"
               "getopts" "hash" "help" "history" "jobs" "kill" "let" "local"
               "logout" "mapfile" "popd" "printf" "pushd" "pwd" "read" "readarray"
               "readonly" "return" "set" "shift" "shopt" "source" "suspend"
               "test" "times" "trap" "true" "type" "typeset" "ulimit" "umask"
               "unalias" "unset" "wait")
           eow)
      (0 'font-lock-comment-face t))
     ;; brightred: variables
     (,(rx (or "${" "$") (+ (in "0-9A-Z_!@#$*?-")) (? "}")
      (0 'font-lock-type-face t))
     ;; brightyellow: strings
     (,(rx (or (seq "\"" (* (not (any "\"\\"))) "\"")
               (seq "'"  (* (not (any "'\\")))  "'")))
      (0 'font-lock-string-face t))
     ;; cyan: comments
     (,(rx (or bol (* space)) "#" (* nonl))
      (0 'font-lock-constant-face t))
     ;; brightyellow: zsh numbers
     (,(rx bow (+ digit) eow)
      (0 'font-lock-string-face t))
     ;; brightgreen: zsh function defs
     (,(rx bol (+ space) "function" (+ space) (+ (in "0-9A-Z_")) (* space) "(")
      (0 'font-lock-doc-face t))
     ;; brightcyan: zsh double-hash comments
     (,(rx (or bol (* space)) "##" (* nonl))
      (0 'font-lock-constant-face t)))
  'append)

(add-hook 'sh-mode-hook #'nano-keys-lang--setup-sh)
(add-hook 'bash-ts-mode-hook #'nano-keys-lang--setup-sh)


;; ============================================================
;; HTML
;; ============================================================
(defun nano-keys-lang--setup-html ()
  (font-lock-add-keywords
   nil
   `(;; cyan: tags
     (,(rx "<" (? "/") (+ (not (any "> "))) (* (not ">")) ">")
      (0 'font-lock-constant-face t))
     ;; brightblue: attributes
     (,(rx (+ space)
           (group (or "abbr" "accept" "accept-charset" "accesskey" "action"
                      "alink" "alt" "archive" "axis" "background" "bgcolor"
                      "border" "cellpadding" "cellspacing" "char" "charoff"
                      "charset" "checked" "cite" "class" "classid" "clear"
                      "code" "codebase" "codetype" "color" "cols" "colspan"
                      "compact" "content" "contenteditable" "contextmenu"
                      "coords" "data" "datetime" "declare" "defer" "dir"
                      "disabled" "enctype" "for" "frame" "frameborder"
                      "headers" "height" "hidden" "href" "hreflang" "hspace"
                      "http-equiv" "id" "ismap" "label" "lang" "longdesc"
                      "marginheight" "marginwidth" "maxlength" "media"
                      "method" "multiple" "name" "nohref" "noresize"
                      "noshade" "object" "onclick" "onfocus" "onload"
                      "onmouseover" "onkeypress" "profile" "readonly" "rel"
                      "rev" "rows" "rowspan" "rules" "scheme" "scope"
                      "scrolling" "selected" "shape" "size" "span" "src"
                      "standby" "start" "style" "summary" "tabindex"
                      "target" "text" "title" "type" "usemap" "valign"
                      "value" "valuetype" "vlink" "vspace" "width" "xmlns"
                      "xml:space" "required" "disabled" "selected")
           "=")
      (1 'font-lock-comment-face t))
     ;; yellow: strings
     (,(rx "\"" (* (not (any "\"\\"))) "\"")
      (0 'font-lock-string-face t))
     ;; red: entities
     (,(rx "&" (+ (in "a-zA-Z0-9")) ";")
      (0 'font-lock-type-face t))
     ;; magenta: template strings
     (,(rx "{" (* (nonl)) "}")
      (0 'font-lock-function-name-face t))
     ;; green: comments
     (,(rx "<!--" (* nonl) "-->")
      (0 'font-lock-keyword-face t)))
  'append)

(add-hook 'html-mode-hook #'nano-keys-lang--setup-html)
(add-hook 'mhtml-mode-hook #'nano-keys-lang--setup-html)
(add-hook 'html-ts-mode-hook #'nano-keys-lang--setup-html)


;; ============================================================
;; CSS / SCSS / Less
;; ============================================================
(defun nano-keys-lang--setup-css ()
  (font-lock-add-keywords
   nil
   `(;; brightred: selectors
     (,(rx "." (+ (in "a-zA-Z0-9_-")))
      (0 'font-lock-type-face t))
     ;; brightyellow: property blocks
     (,(rx "{" (* nonl) "}")
      (0 'font-lock-number-face t))
     ;; brightblue: pseudo-classes
     (,(rx ":" (or "active" "focus" "hover" "link" "visited" "after" "before"))
      (0 'font-lock-comment-face t))
     ;; brightblue: comments
     (,(rx "/*" (* nonl) "*/")
      (0 'font-lock-comment-face t))
     ;; green: punctuation
     (,(rx (any ";:{}"))
      (0 'font-lock-keyword-face t)))
  'append)

(add-hook 'css-mode-hook #'nano-keys-lang--setup-css)
(add-hook 'scss-mode-hook #'nano-keys-lang--setup-css)
(add-hook 'less-css-mode-hook #'nano-keys-lang--setup-css)
(add-hook 'css-ts-mode-hook #'nano-keys-lang--setup-css)


;; ============================================================
;; JSON
;; ============================================================
(defun nano-keys-lang--setup-json ()
  (font-lock-add-keywords
   nil
   `(;; blue: numbers
     (,(rx bow (optional "-")
           (or (seq (+ digit) (? (seq "." (* digit)))
                    (? (seq (any "Ee") (optional "+-") (+ digit))))
               "0" (? "." (* digit)))
           eow)
      (0 'font-lock-comment-face t))
     ;; cyan: null
     (,(rx bow "null")
      (0 'font-lock-constant-face t))
     ;; brightcyan: booleans
     (,(rx bow (or "true" "false"))
      (0 'font-lock-constant-face t))
     ;; yellow: strings
     (,(rx "\"" (* (not (any "\"\\"))) "\"")
      (0 'font-lock-string-face t))
     ;; brightyellow: keys
     (,(rx "\"" (* (not (any "\"\\"))) "\"" (* space) ":")
      (0 'font-lock-number-face t))
     ;; magenta: escape sequences
     (,(rx "\\" (or (in "bfnrt'\"\\/") (seq "u" (= 4 (in "0-9a-fA-F")))))
      (0 'font-lock-function-name-face t)))
  'append)

(add-hook 'json-mode-hook #'nano-keys-lang--setup-json)
(add-hook 'json-ts-mode-hook #'nano-keys-lang--setup-json)


;; ============================================================
;; YAML
;; ============================================================
(defun nano-keys-lang--setup-yaml ()
  (font-lock-add-keywords
   nil
   `(;; green: values
     (,(rx (or ":" bol (* space)) (group (+ nonl)))
      (1 'font-lock-keyword-face t))
     ;; red: keys
     (,(rx (or bol (* space)) (group (+ nonl)) (* space) ":" (* space) eol)
      (1 'font-lock-type-face t))
     ;; yellow: special values
     (,(rx (or ":-" ":") (+ space) (or "true" "false" "null") eol)
      (0 'font-lock-string-face t))
     (,(rx (or ":-" ":") (+ space) (+ digit) "." (* digit) (or eol " " "#"))
      (0 'font-lock-string-face t))
     ;; brightblue: comments
     (,(rx (or bol (* space)) "#" (* nonl))
      (0 'font-lock-comment-face t)))
  'append)

(add-hook 'yaml-mode-hook #'nano-keys-lang--setup-yaml)
(add-hook 'yaml-ts-mode-hook #'nano-keys-lang--setup-yaml)


;; ============================================================
;; XML
;; ============================================================
(defun nano-keys-lang--setup-xml ()
  (font-lock-add-keywords
   nil
   `(;; green: tags
     (,(rx "<" (? "/") (* (not (any "> "))) (* (not ">")) ">")
      (0 'font-lock-keyword-face t))
     ;; cyan: tag names
     (,(rx "<" (? "/") (group (+ (not (any "> ")))) (* (not ">")) ">")
      (1 'font-lock-constant-face t))
     ;; yellow: DOCTYPE / comments
     (,(rx "<!DOCTYPE" (* nonl) (or "/" ">"))
      (0 'font-lock-string-face t))
     (,(rx "<!--" (* nonl) "-->")
      (0 'font-lock-string-face t))
     ;; red: entities
     (,(rx "&" (+ (in "a-zA-Z0-9")) ";")
      (0 'font-lock-type-face t)))
  'append)

(add-hook 'nxml-mode-hook #'nano-keys-lang--setup-xml)
(add-hook 'xml-mode-hook #'nano-keys-lang--setup-xml)


;; ============================================================
;; Markdown
;; ============================================================
(defun nano-keys-lang--setup-markdown ()
  (font-lock-add-keywords
   nil
   `(;; brightmagenta: headlines
     (,(rx bol "#" (+ "#") (* nonl))
      (0 'font-lock-function-name-face t))
     ;; green: emphasis
     (,(rx (or bol (* space)) (group (or "_" "*" "_")) (* nonl) (group (or "_" "*" "_")))
      (0 'font-lock-keyword-face t))
     ;; brightgreen: strong emphasis
     (,(rx (or bol (* space)) (group "__" "**") (* nonl) (group "__" "**"))
      (0 'font-lock-doc-face t))
     ;; red: strikethrough
     (,(rx (or bol (* space)) "~~" (* nonl) "~~")
      (0 'font-lock-type-face t))
     ;; brightmagenta: horizontal rules
     (,(rx bol (or "---+" "===+" "___+" "***+") eol)
      (0 'font-lock-function-name-face t))
     ;; blue: lists
     (,(rx bol (* space) (or (any "*-+") "." (+ digit) ".") " ")
      (0 'font-lock-comment-face t))
     ;; brightblue: links
     (,(rx "[" (* nonl) "](" (* nonl) ")")
      (0 'font-lock-comment-face t))
     ;; magenta: images
     (,(rx "![" (* nonl) "](" (* nonl) ")")
      (0 'font-lock-function-name-face t))
     ;; brightyellow: URLs
     (,(rx "https?://[^ )>]+")
      (0 'font-lock-number-face t))
     ;; yellow: code
     (,(rx "`" (* (nonl)) "`")
      (0 'font-lock-string-face t))
     (,(rx bol "```" (* nonl))
      (0 'font-lock-string-face t)))
  'append)

(add-hook 'markdown-mode-hook #'nano-keys-lang--setup-markdown)
(add-hook 'gfm-mode-hook #'nano-keys-lang--setup-markdown)


;; ============================================================
;; CMake
;; ============================================================
(defun nano-keys-lang--setup-cmake ()
  (font-lock-add-keywords
   nil
   `(;; green: commands
     (,(rx bol (* space) (+ (in "A-Z0-9_")))
      (0 'font-lock-keyword-face t))
     ;; brightgreen: control flow
     (,(rx bow
           (or "if" "else" "elseif" "endif" "while" "endwhile" "foreach"
               "endforeach" "break")
           eow)
      (0 'font-lock-doc-face t))
     ;; brightred: function/macro
     (,(rx bow
           (or "function" "endfunction" "macro" "endmacro" "return")
           eow)
      (0 'font-lock-type-face t))
     ;; cyan: strings
     (,(rx "\"" (* (not (any "\"\\"))) "\"")
      (0 'font-lock-constant-face t))
     ;; brightblue: comments
     (,(rx "#" (* nonl))
      (0 'font-lock-comment-face t)))
  'append)

(add-hook 'cmake-mode-hook #'nano-keys-lang--setup-cmake)
(add-hook 'cmake-ts-mode-hook #'nano-keys-lang--setup-cmake)


;; ============================================================
;; TeX / LaTeX
;; ============================================================
(defun nano-keys-lang--setup-tex ()
  (font-lock-add-keywords
   nil
   `(;; yellow: inline math
     (,(rx "$" (* (not (any "$"))) "$")
      (0 'font-lock-string-face t))
     (,(rx "$$" (* (not (any "$"))) "$$")
      (0 'font-lock-string-face t))
     ;; green: commands
     (,(rx "\\" (+ (in "A-Z")))
      (0 'font-lock-keyword-face t))
     ;; magenta: braces
     (,(rx (any "{}"))
      (0 'font-lock-function-name-face t))
     ;; blue: comments
     (,(rx "%" (* nonl))
      (0 'font-lock-comment-face t)))
  'append)

(add-hook 'tex-mode-hook #'nano-keys-lang--setup-tex)
(add-hook 'latex-mode-hook #'nano-keys-lang--setup-tex)
(add-hook 'LaTeX-mode-hook #'nano-keys-lang--setup-tex)


;; ============================================================
;; SQL
;; ============================================================
(defun nano-keys-lang--setup-sql ()
  (font-lock-add-keywords
   nil
   `(;; cyan: SQL keywords
     (,(rx bow
           (or "ALL" "ASC" "AS" "ALTER" "AND" "ADD" "AUTO_INCREMENT"
               "BETWEEN" "BINARY" "BOTH" "BY" "BOOLEAN"
               "CHANGE" "CHECK" "COLUMNS" "COLUMN" "CROSS" "CREATE"
               "DATABASES" "DATABASE" "DATA" "DELAYED" "DESCRIBE" "DESC"
               "DISTINCT" "DELETE" "DROP" "DEFAULT"
               "ENCLOSED" "ESCAPED" "EXISTS" "EXPLAIN"
               "FIELDS" "FIELD" "FLUSH" "FOR" "FOREIGN" "FUNCTION" "FROM"
               "GROUP" "GRANT" "HAVING"
               "IGNORE" "INDEX" "INFILE" "INSERT" "INNER" "INTO" "IDENTIFIED"
               "IN" "IS" "IF"
               "JOIN" "KEYS" "KILL" "KEY"
               "LEADING" "LIKE" "LIMIT" "LINES" "LOAD" "LOCAL" "LOCK"
               "LOW_PRIORITY" "LEFT" "LANGUAGE"
               "MODIFY" "NATURAL" "NOT" "NULL" "NEXTVAL"
               "OPTIMIZE" "OPTION" "OPTIONALLY" "ORDER" "OUTFILE" "OR"
               "OUTER" "ON"
               "PROCEDURE" "PROCEDURAL" "PRIMARY"
               "READ" "REFERENCES" "REGEXP" "RENAME" "REPLACE" "RETURN"
               "REVOKE" "RLIKE" "RIGHT"
               "SHOW" "SONAME" "STATUS" "STRAIGHT_JOIN" "SELECT" "SETVAL" "SET"
               "TABLES" "TERMINATED" "TO" "TRAILING" "TRUNCATE" "TABLE"
               "TEMPORARY" "TRIGGER" "TRUSTED"
               "UNIQUE" "UNLOCK" "USE" "USING" "UPDATE" "VALUES" "VARIABLES" "VIEW"
               "WITH" "WRITE" "WHERE" "ZEROFILL" "TYPE" "XOR")
           eow)
      (0 'font-lock-constant-face t))
     ;; green: data types
     (,(rx bow
           (or "VARCHAR" "TINYINT" "TEXT" "DATE" "SMALLINT" "MEDIUMINT" "INT"
               "INTEGER" "BIGINT" "FLOAT" "DOUBLE" "DECIMAL" "DATETIME"
               "TIMESTAMP" "TIME" "YEAR" "UNSIGNED" "CHAR" "TINYBLOB" "TINYTEXT"
               "BLOB" "MEDIUMBLOB" "MEDIUMTEXT" "LONGBLOB" "LONGTEXT" "ENUM"
               "BOOL" "BINARY" "VARBINARY")
           eow)
      (0 'font-lock-keyword-face t))
     ;; brightcyan: ON/OFF
     (,(rx bow (or "ON" "OFF"))
      (0 'font-lock-preprocessor-face t))
     ;; blue: numbers
     (,(rx bow (+ digit))
      (0 'font-lock-comment-face t))
     ;; yellow: strings
     (,(rx (or (seq "\"" (* (not (any "\"\\"))) "\"")
               (seq "'"  (* (not (any "'\\")))  "'")
               (seq "`"  (* (not (any "`\\")))  "`")))
      (0 'font-lock-string-face t))
     ;; brightblack: comments
     (,(rx "--" (* nonl))
      (0 'font-lock-comment-face t)))
  'append)

(add-hook 'sql-mode-hook #'nano-keys-lang--setup-sql)


;; ============================================================
;; Swift
;; ============================================================
(defun nano-keys-lang--setup-swift ()
  (font-lock-add-keywords
   nil
   `(;; yellow: operators
     (,(rx (any ".:;,+*|=!?%")) (0 'font-lock-string-face t))
     (,(rx (any "<>/-&"))         (0 'font-lock-string-face t))
     ;; magenta: statements
     (,(rx bow
           (or "class" "import" "let" "var" "struct" "enum" "func" "if" "else"
               "switch" "case" "default" "for" "in" "static" "private" "public"
               "throws" "lazy" "get" "set" "self" "willSet" "didSet" "override"
               "super" "convenience" "weak" "strong" "mutating" "return" "guard"
               "protocol" "typealias" "prefix" "postfix" "operator" "extension"
               "internal" "external" "unowned" "init")
           eow)
      (0 'font-lock-function-name-face t))
     ;; brightmagenta: standard types
     (,(rx bow
           (or "Int" "Int8" "Int16" "Int32" "Int64"
               "UInt" "UInt8" "UInt16" "UInt32" "UInt64"
               "Double" "String" "Float" "Bool" "Dictionary" "Array"
               "Character" "Range" "Set" "Bit" "RawByte" "Slice"
               "UnicodeScalar" "UnsafePointer" "UnsafeMutablePointer"
               "AnyObject" "AnyClass" "GeneratorType" "AnyGenerator"
               "Element" "Optional" "Mirror"
               "true" "false" "nil")
           eow)
      (0 'font-lock-builtin-face t))
     ;; cyan: print
     (,(rx bow "print" eow)
      (0 'font-lock-constant-face t))
     ;; red: strings
     (,(rx "\"" (* (not (any "\"\\"))) "\"")
      (0 'font-lock-type-face t))
     ;; blue: numbers
     (,(rx bow (or (+ digit)
                   "U+" (+ (in "0-9A-Z"))
                   "0b" (+ (in "01"))
                   "0o" (+ (in "0-7"))
                   "0x" (+ (in "0-9a-fA-F")))
           eow)
      (0 'font-lock-comment-face t))
     ;; red: attributes
     (,(rx "@" (+ (in "a-zA-Z")))
      (0 'font-lock-type-face t))
     ;; green: comments
     (,(rx (or (seq "//" (* nonl))
               (seq "/*" (* nonl) "*/")))
      (0 'font-lock-keyword-face t))
     ;; brightgreen: doc comments
     (,(rx "///" (* nonl))
      (0 'font-lock-doc-face t)))
  'append)

(add-hook 'swift-mode-hook #'nano-keys-lang--setup-swift)


;; ============================================================
;; Kotlin
;; ============================================================
(defun nano-keys-lang--setup-kotlin ()
  (font-lock-add-keywords
   nil
   `(;; magenta: numbers
     (,(rx bow
           (or (seq (+ digit) "." (+ digit))
               (+ digit)
               "0" (+ (in "0-7"))
               "0x" (+ (in "0-9a-f")))
           eow)
      (0 'font-lock-function-name-face t))
     ;; yellow: operators
     (,(rx (any ".:;,+*|=!%@")) (0 'font-lock-string-face t))
     (,(rx (any "<>/-&"))        (0 'font-lock-string-face t))
     ;; green: keywords
     (,(rx bow
           (or "namespace" "as" "type" "class" "this" "super" "val" "var" "fun"
               "is" "in" "object" "when" "trait" "import" "where" "by" "get"
               "set" "abstract" "enum" "open" "annotation" "override" "private"
               "public" "internal" "protected" "out" "vararg" "inline" "final"
               "package" "lateinit" "constructor" "companion" "const" "suspend"
               "sealed")
           eow)
      (0 'font-lock-keyword-face t))
     ;; yellow: booleans/null
     (,(rx bow (or "true" "false" "null"))
      (0 'font-lock-string-face t))
     ;; cyan: control flow
     (,(rx bow
           (or "break" "catch" "continue" "do" "else" "finally" "for" "if"
               "return" "throw" "try" "while" "repeat")
           eow)
      (0 'font-lock-constant-face t))
     ;; brightred: inner/outer
     (,(rx bow (or "inner" "outer"))
      (0 'font-lock-type-face t))
     ;; brightblue: strings
     (,(rx "\"" (* (not (any "\"\\"))) "\"")
      (0 'font-lock-comment-face t))
     ;; red: comments
     (,(rx (or (seq "//" (* nonl))
               (seq "/*" (* nonl) "*/")))
      (0 'font-lock-type-face t)))
  'append)

(add-hook 'kotlin-mode-hook #'nano-keys-lang--setup-kotlin)
(add-hook 'kotlin-ts-mode-hook #'nano-keys-lang--setup-kotlin)


;; ============================================================
;; Scala
;; ============================================================
(defun nano-keys-lang--setup-scala ()
  (font-lock-add-keywords
   nil
   `(;; green: types
     (,(rx bow
           (or "boolean" "byte" "char" "double" "float" "int" "long" "new"
               "short" "this" "transient" "void")
           eow)
      (0 'font-lock-keyword-face t))
     ;; red: keywords
     (,(rx bow
           (or "match" "val" "var" "break" "case" "catch" "continue" "default"
               "do" "else" "finally" "for" "if" "return" "switch" "throw" "try"
               "while")
           eow)
      (0 'font-lock-type-face t))
     ;; cyan: modifiers
     (,(rx bow
           (or "def" "object" "case" "trait" "lazy" "implicit" "abstract" "class"
               "extends" "final" "implements" "import" "instanceof" "interface"
               "native" "package" "private" "protected" "public" "static"
               "strictfp" "super" "synchronized" "throws" "volatile" "sealed")
           eow)
      (0 'font-lock-constant-face t))
     ;; red: strings
     (,(rx "\"" (* (not (any "\"\\"))) "\"")
      (0 'font-lock-type-face t))
     ;; yellow: booleans/null
     (,(rx bow (or "true" "false" "null"))
      (0 'font-lock-string-face t))
     ;; blue: comments
     (,(rx (or (seq "//" (* nonl))
               (seq "/*" (* nonl) "*/")))
      (0 'font-lock-comment-face t))
     ;; brightblue: scaladoc
     (,(rx "/**" (* nonl) "*/")
      (0 'font-lock-comment-face t)))
  'append)

(add-hook 'scala-mode-hook #'nano-keys-lang--setup-scala)
(add-hook 'scala-ts-mode-hook #'nano-keys-lang--setup-scala)


;; ============================================================
;; Haskell
;; ============================================================
(defun nano-keys-lang--setup-haskell ()
  (font-lock-add-keywords
   nil
   `(;; red: keywords
     (,(rx bow
           (or "as" "case" "of" "class" "data" "default" "deriving" "do" "forall"
               "foreign" "hiding" "if" "then" "else" "import" "infix" "infixl"
               "infixr" "instance" "let" "in" "mdo" "module" "newtype" "qualified"
               "type" "where")
           eow)
      (0 'font-lock-type-face t))
     ;; cyan: symbols
     (,(rx (or "|" "@" "!" ":" "_" "~" "=" "\\" ";" "(" ")" "," "[" "]" "{"))
      (0 'font-lock-constant-face t))
     ;; magenta: operators
     (,(rx (or "==" "/=" "&&" "||" "<" ">" "<=" ">="))
      (0 'font-lock-function-name-face t))
     ;; cyan: arrows
     (,(rx (or "->" "<-" "=>"))
      (0 'font-lock-constant-face t))
     ;; magenta: data constructors
     (,(rx bow (or "True" "False" "Nothing" "Just" "Left" "Right" "LT" "EQ" "GT"))
      (0 'font-lock-function-name-face t))
     ;; magenta: type classes
     (,(rx bow
           (or "Read" "Show" "Enum" "Eq" "Ord" "Data" "Bounded" "Typeable" "Num"
               "Real" "Fractional" "Integral" "RealFrac" "Floating" "RealFloat"
               "Monad" "MonadPlus" "Functor")
           eow)
      (0 'font-lock-function-name-face t))
     ;; yellow: strings
     (,(rx "\"" (* (not (any "\"\\"))) "\"")
      (0 'font-lock-string-face t))
     ;; brightyellow: chars
     (,(rx "'" (* (not (any "'\\"))) "'")
      (0 'font-lock-number-face t))
     ;; green: comments
     (,(rx "--" (* nonl))
      (0 'font-lock-keyword-face t))
     ;; brightred: undefined
     (,(rx bow "undefined")
      (0 'font-lock-type-face t)))
  'append)

(add-hook 'haskell-mode-hook #'nano-keys-lang--setup-haskell)
(add-hook 'haskell-literate-mode-hook #'nano-keys-lang--setup-haskell)


;; ============================================================
;; Elixir
;; ============================================================
(defun nano-keys-lang--setup-elixir ()
  (font-lock-add-keywords
   nil
   `(;; yellow: reserved words
     (,(rx bow
           (or "case" "cond" "true" "if" "false" "nil" "when" "and" "or" "not"
               "in" "fn" "do" "end" "catch" "rescue" "after" "else" "with")
           eow)
      (0 'font-lock-string-face t))
     ;; yellow: def* forms
     (,(rx "def" (+ (in "a-z")))
      (0 'font-lock-string-face t))
     ;; brightblue: module attributes
     (,(rx "@" (+ (in "a-z")))
      (0 'font-lock-comment-face t))
     ;; magenta: atoms
     (,(rx ":" (+ (in "0-9a-z_")))
      (0 'font-lock-function-name-face t))
     ;; magenta: module names
     (,(rx bow (in "A-Z") (+ (in "a-zA-Z0-9")))
      (0 'font-lock-function-name-face t))
     ;; brightyellow: special vars
     (,(rx bow
           (or "__CALLER__" "__DIR__" "__ENV__" "__MODULE__" "__STACKTRACE__"
               "__add__" "__aliases__" "__build__" "__block__" "__deriving__"
               "__info__" "__protocol__" "__struct__" "__using__"))
      (0 'font-lock-number-face t))
     ;; green: double-quoted strings
     (,(rx "\"" (* (not (any "\"\\"))) "\"")
      (0 'font-lock-keyword-face t))
     ;; green: single-quoted strings
     (,(rx "'" (* (not (any "'\\"))) "'")
      (0 'font-lock-keyword-face t))
     ;; brightgreen: interpolation
     (,(rx "#{" (* (nonl)) "}")
      (0 'font-lock-doc-face t))
     ;; cyan: comments
     (,(rx "#" (* nonl))
      (0 'font-lock-constant-face t))
     ;; brightcyan: TODO/FIXME
     (,(rx (or "XXX" "TODO" "FIXME" "???"))
      (0 'font-lock-constant-face t)))
  'append)

(add-hook 'elixir-mode-hook #'nano-keys-lang--setup-elixir)
(add-hook 'elixir-ts-mode-hook #'nano-keys-lang--setup-elixir)


;; ============================================================
;; Lisp / Emacs Lisp / Scheme
;; ============================================================
(defun nano-keys-lang--setup-lisp ()
  (font-lock-add-keywords
   nil
   `(;; brightblue: function calls
     (,(rx "(" (in "a-z-") (+ (in "a-z0-9-")))
      (0 'font-lock-comment-face t))
     ;; red: comparison/arithmetic
     (,(rx "(" (or (any "+-*/<>") (seq (any "<>=") "=") "'"))
      (0 'font-lock-type-face t))
     ;; blue: numbers
     (,(rx bow (+ digit) eow)
      (0 'font-lock-comment-face t))
     ;; cyan: nil
     (,(rx bow "nil")
      (0 'font-lock-constant-face t))
     ;; brightcyan: t
     (,(rx bow (in "tT"))
      (0 'font-lock-constant-face t))
     ;; yellow: strings
     (,(rx "\"" (* (not (any "\"\\"))) "\"")
      (0 'font-lock-string-face t))
     ;; magenta: quoted symbols
     (,(rx "'" (in "a-zA-Z") (+ (in "a-zA-Z0-9_-")))
      (0 'font-lock-function-name-face t))
     ;; brightblack: comments
     (,(rx (or bol (* space)) ";" (* nonl))
      (0 'font-lock-comment-face t)))
  'append)

(add-hook 'emacs-lisp-mode-hook #'nano-keys-lang--setup-lisp)
(add-hook 'lisp-mode-hook #'nano-keys-lang--setup-lisp)
(add-hook 'scheme-mode-hook #'nano-keys-lang--setup-lisp)
(add-hook 'clojure-mode-hook #'nano-keys-lang--setup-lisp)


;; ============================================================
;; Clojure
;; ============================================================
(defun nano-keys-lang--setup-clojure ()
  (font-lock-add-keywords
   nil
   `(;; brightgreen: fn, quote
     (,(rx bow (or "fn" "#'"))
      (0 'font-lock-doc-face t))
     ;; green: core functions
     (,(rx bow (or "map" "reduce" "filter" "println")
           eow)
      (0 'font-lock-keyword-face t))
     ;; brightyellow: conditionals
     (,(rx bow
           (or "if" "if-let" "if-not" "cond" "condp" "when" "when-let"
               "when-not" "do" "doall" "dorun" "doseq" "dosync" "recur"
               "loop" "try" "catch" "finally" "throw"
               ":else")
           eow)
      (0 'font-lock-number-face t))
     ;; brightcyan: require/use/import/ns
     (,(rx bow (or "require" "use" "import" "ns")
           eow)
      (0 'font-lock-constant-face t))
     ;; brightred: let/def
     (,(rx bow (or "let" "letfn" "def" "defn" "defn-")
           eow)
      (0 'font-lock-type-face t))
     ;; brightwhite: booleans
     (,(rx bow (or "true" "false" "nil"))
      (0 'font-lock-number-face t))
     ;; brightblue: line comments
     (,(rx ";" (* nonl))
      (0 'font-lock-comment-face t)))
  'append)

(add-hook 'clojure-mode-hook #'nano-keys-lang--setup-clojure)
(add-hook 'clojurescript-mode-hook #'nano-keys-lang--setup-clojure)


;; ============================================================
;; Fortran
;; ============================================================
(defun nano-keys-lang--setup-fortran ()
  (font-lock-add-keywords
   nil
   `(;; red: numbers
     (,(rx bow (+ digit))
      (0 'font-lock-type-face t))
     ;; green: keywords
     (,(rx bow
           (or "action" "advance" "all" "allocatable" "allocated" "any"
               "apostrophe" "append" "asis" "assign" "assignment" "associated"
               "character" "common" "complex" "data" "default" "delim" "dimension"
               "double precision" "elemental" "epsilon" "external" "file" "fmt"
               "form" "format" "huge" "implicit" "include" "index" "inquire"
               "integer" "intent" "interface" "intrinsic" "iostat" "kind"
               "logical" "module" "none" "null" "only" "operator" "optional"
               "pack" "parameter" "pointer" "position" "private" "program"
               "public" "real" "recl" "recursive" "selected_int_kind"
               "selected_real_kind" "subroutine" "status")
           eow)
      (0 'font-lock-keyword-face t))
     ;; cyan: built-in functions
     (,(rx bow
           (or "abs" "achar" "adjustl" "adjustr" "allocate" "bit_size" "call"
               "char" "close" "contains" "count" "cpu_time" "cshift"
               "date_and_time" "deallocate" "digits" "dot_product" "eor"
               "eoshift" "function" "iachar" "iand" "ibclr" "ibits" "ibset"
               "ichar" "ieor" "iolength" "ior" "ishft" "ishftc" "lbound" "len"
               "len_trim" "matmul" "maxexponent" "maxloc" "maxval" "merge"
               "minexponent" "minloc" "minval" "mvbits" "namelist" "nearest"
               "nullify" "open" "pad" "present" "print" "product" "pure"
               "quote" "radix" "random_number" "random_seed" "range" "read"
               "readwrite" "replace" "reshape" "rewind" "save" "scan" "sequence"
               "shape" "sign" "size" "spacing" "spread" "sum" "system_clock"
               "target" "transfer" "transpose" "trim" "ubound" "unpack" "verify"
               "write" "tiny" "type" "use" "yes")
           eow)
      (0 'font-lock-constant-face t))
     ;; yellow: conditionals
     (,(rx bow
           (or ".and." "case" "do" "else" "elseif" "elsewhere" "end" "enddo"
               "endif" "endselect" ".eqv." "forall" "if" "lge" "lgt" "lle"
               "llt" ".neqv." ".not." ".or." "repeat" "select case" "then"
               "where" "while")
           eow)
      (0 'font-lock-string-face t))
     ;; magenta: flow control
     (,(rx bow (or "continue" "cycle" "exit" "goto" "result" "return"))
      (0 'font-lock-function-name-face t))
     ;; brightcyan: preprocessor
     (,(rx bol (* space) "#" (* space)
           (or "define" "include" "undef" "ifndef" "endif" "elif" "else" "if"
               "warning" "error"))
      (0 'font-lock-preprocessor-face t))
     ;; brightred: comments
     (,(rx "!" (* nonl))
      (0 'font-lock-type-face t)))
  'append)

(add-hook 'fortran-mode-hook #'nano-keys-lang--setup-fortran)
(add-hook 'f90-mode-hook #'nano-keys-lang--setup-fortran)


;; ============================================================
;; Assembly
;; ============================================================
(defun nano-keys-lang--setup-asm ()
  (font-lock-add-keywords
   nil
   `(;; red: ALL_CAPS labels
     (,(rx bow (+ (in "A_Z")) (+ (in "0-9A-Z_")) eow)
      (0 'font-lock-type-face t))
     ;; brightgreen: sections
     (,(rx bow "." (or "data" "subsection" "text"))
      (0 'font-lock-doc-face t))
     ;; green: directives
     (,(rx bow "."
           (or "align" "file" "globl" "global" "hidden" "section" "size" "type"
               "weak")
           eow)
      (0 'font-lock-keyword-face t))
     ;; brightyellow: data directives
     ($(rx bow "."
           (or "ascii" "asciz" "byte" "double" "float" "hword" "int" "long"
               "short" "single" "struct" "word")
           eow)
      (0 'font-lock-string-face t))
     ;; brightred: labels with colon
     (,(rx bol (* space) (+ (in ".0-9A-Z_")) ":")
      (0 'font-lock-type-face t))
     ;; brightcyan: preprocessor
     ($(rx bol (* space) "#" (* space)
           (or "define" "undef" "include" "ifndef" "endif" "elif" "else" "if"
               "warning" "error"))
      (0 'font-lock-preprocessor-face t))
     ;; brightblue: comments
     (,(rx (or (seq "//" (* nonl))
               (seq "/*" (* nonl) "*/")))
      (0 'font-lock-comment-face t)))
  'append)

(add-hook 'asm-mode-hook #'nano-keys-lang--setup-asm)
(add-hook 'nasm-mode-hook #'nano-keys-lang--setup-asm)


;; ============================================================
;; Makefile
;; ============================================================
(defun nano-keys-lang--setup-makefile ()
  (font-lock-add-keywords
   nil
   `(;; cyan: conditionals
     (,(rx bow
           (or "ifeq" "ifdef" "ifneq" "ifndef" "else" "endif")
           eow)
      (0 'font-lock-constant-face t))
     ;; cyan: export/include/override
     (,(rx bol (or "export" "include" "override") eow)
      (0 'font-lock-constant-face t))
     ;; brightmagenta: targets
     ($(rx bol (+ (not (any ":=" \t))) ":")
      (0 'font-lock-function-name-face t))
     ;; red: operators
     (,(rx (any "=,%")) (0 'font-lock-type-face t))
     ($(rx (or "+=" "?=" ":=" "&&" "||"))
      (0 'font-lock-type-face t))
     ;; brightblue: make functions
     ($(rx "$("
           (or "abspath" "addprefix" "addsuffix" "and" "basename" "call" "dir"
               "error" "eval" "filter" "filter-out" "findstring" "firstword"
               "flavor" "foreach" "if" "info" "join" "lastword" "notdir" "or"
               "origin" "patsubst" "realpath" "shell" "sort" "strip" "suffix"
               "value" "warning" "wildcard" "word" "wordlist" "words")
           (+ space))
      (0 'font-lock-comment-face t))
     ;; yellow: strings
     ($(rx (or (seq "\"" (* (not (any "\"\\"))) "\"")
               (seq "'"  (* (not (any "'\\")))  "'")))
      (0 'font-lock-string-face t))
     ;; brightyellow: variables
     ($(rx "$+" (or "{" "(") (+ (in "^ ")) (or "}" ")"))
      (0 'font-lock-string-face t))
     ($(rx "$" (any "@^<*?%|+"))
      (0 'font-lock-string-face t))
     ;; brightblack: comments
     ($(rx (or bol (* space)) "#" (* (nonl)))
      (0 'font-lock-comment-face t)))
  'append)

(add-hook 'makefile-mode-hook #'nano-keys-lang--setup-makefile)
(add-hook 'makefile-gmake-mode-hook #'nano-keys-lang--setup-makefile)
(add-hook 'makefile-bsdmakefile-mode-hook #'nano-keys-lang--setup-makefile)


;; ============================================================
;; TOML
;; ============================================================
(defun nano-keys-lang--setup-toml ()
  (font-lock-add-keywords
   nil
   `(;; magenta: booleans
     ($,(rx bow (or "true" "false"))
      (0 'font-lock-function-name-face t))
     ;; green: numbers
     ($,(rx bow (optional (any "+-")) (* space)
           (+ digit) (? "." (+ digit))
           (? (seq (any "Ee") (optional (any "+-")) (+ digit)))
           eow)
      (0 'font-lock-keyword-face t))
     ;; brightgreen: table keys
     ($,(rx (+ (in "a-zA-Z0-9_")) (? "." (+ (in "a-zA-Z0-9_"))))
      (0 'font-lock-doc-face t))
     ;; brightyellow: strings
     ($,(rx (or (seq "\"" (* (not (any "\"\\"))) "\"")
               (seq "'"  (* (not (any "'\\")))  "'")))
      (0 'font-lock-string-face t))
     ($,(rx "\"\"\"" (* (nonl)) "\"\"\"")
      (0 'font-lock-string-face t))
     ;; brightblue: comments
     ($,(rx "#" (* nonl))
      (0 'font-lock-comment-face t)))
  'append)

(add-hook 'toml-mode-hook #'nano-keys-lang--setup-toml)
(add-hook 'toml-ts-mode-hook #'nano-keys-lang--setup-toml)


;; ============================================================
;; Dockerfile
;; ============================================================
(defun nano-keys-lang--setup-dockerfile ()
  (font-lock-add-keywords
   nil
   `(;; green: instructions
     ($,(rx bol
           (or "FROM" "RUN" "CMD" "LABEL" "MAINTAINER" "EXPOSE" "ENV" "ADD"
               "COPY" "ENTRYPOINT" "VOLUME" "USER" "WORKDIR" "ARG" "ONBUILD"
               "STOPSIGNAL" "HEALTHCHECK" "SHELL")
           eow)
      (0 'font-lock-keyword-face t))
     ;; yellow: strings
     ($,(rx (or (seq "\"" (* (not (any "\"\\"))) "\"")
               (seq "'"  (* (not (any "'\\")))  "'")))
      (0 'font-lock-string-face t))
     ;; brightblue: comments
     ($,(rx "#" (* nonl))
      (0 'font-lock-comment-face t)))
  'append)

(add-hook 'dockerfile-mode-hook #'nano-keys-lang--setup-dockerfile)
(add-hook 'dockerfile-ts-mode-hook #'nano-keys-lang--setup-dockerfile)


;; ============================================================
;; Nginx config
;; ============================================================
(defun nano-keys-lang--setup-nginx ()
  (font-lock-add-keywords
   nil
   `(;; brightmagenta: block directives
     ($,(rx bow
           (or "events" "server" "http" "location" "upstream")
           (* space) "{")
      (0 'font-lock-function-name-face t))
     ;; cyan: directives (sample of common ones)
     ($,(rx (or (or "access_log" "add_header" "alias" "allow" "autoindex"
                      "break" "charset" "client_body_buffer_size"
                      "client_max_body_size" "default_type" "deny" "error_log"
                      "error_page" "expires" "fastcgi_pass" "gzip" "if" "index"
                      "listen" "location" "proxy_pass" "proxy_set_header"
                      "return" "rewrite" "root" "server" "server_name" "set"
                      "try_files" "upstream"))
      (0 'font-lock-constant-face t))
     ;; brightyellow: variables
     ($,(rx "$" (in "a-zA-Z") (+ (in "a-zA-Z0-9_")))
      (0 'font-lock-string-face t))
     ;; yellow: strings
     ($,(rx (or (seq "\"" (* (not (any "\"\\"))) "\"")
               (seq "'"  (* (not (any "'\\")))  "'")))
      (0 'font-lock-string-face t))
     ;; brightblue: comments
     ($,(rx (or bol (* space)) "#" (* nonl))
      (0 'font-lock-comment-face t)))
  'append)

(add-hook 'nginx-mode-hook #'nano-keys-lang--setup-nginx)


;; ============================================================
;; Puppet
;; ============================================================
(defun nano-keys-lang--setup-puppet ()
  (font-lock-add-keywords
   nil
   `(;; brightgreen: variables
     ($,(rx "$" (+ (in "a-z:_" (+ (in "a-z0-9_:")))))
      (0 'font-lock-doc-face t))
     ;; yellow: resource types
     ($,(rx bow
           (or "augeas" "computer" "cron" "exec" "file" "filebucket" "group"
               "host" "interface" "k5login" "macauthorization" "mailalias"
               "maillist" "mcx" "mount" "notify" "package" "resources" "router"
               "schedule" "scheduled_task" "selboolean" "selmodule" "service"
               "ssh_authorized_key" "sshkey" "stage" "tidy" "user" "vlan"
               "yumrepo" "zfs" "zone" "zpool" "anchor" "class" "define" "if"
               "else" "undef" "inherits")
           eow)
      (0 'font-lock-string-face t))
     ;; red: operators
     ($,(rx (or "=" "-" "~" ">"))
      (0 'font-lock-type-face t))
     ;; brightblue: constants
     ($,(rx (or "$" "@" "@@") ?\< (in "A-Z") (+ (in "0-9A-Z_a-z")))
      (0 'font-lock-comment-face t))
     ;; green: double-quoted strings
     ($,(rx "\"" (* (not (any "\"\\"))) "\"")
      (0 'font-lock-keyword-face t))
     ;; green: single-quoted strings
     ($,(rx "'" (* (not (any "'\\"))) "'")
      (0 'font-lock-keyword-face t))
     ;; brightgreen: interpolation
     ($,(rx "${" (* (nonl)) "}")
      (0 'font-lock-doc-face t))
     ;; cyan: comments
     ($,(rx "#" (* nonl))
      (0 'font-lock-constant-face t)))
  'append)

(add-hook 'puppet-mode-hook #'nano-keys-lang--setup-puppet)


;; ============================================================
;; Tcl
;; ============================================================
(defun nano-keys-lang--setup-tcl ()
  (font-lock-add-keywords
   nil
   `(;; cyan: built-in commands
     ($,(rx bow
           (or "after" "append" "array" "auto_execok" "auto_import" "auto_load"
               "auto_load_index" "auto_qualify" "binary" "break" "case" "catch"
               "cd" "clock" "close" "concat" "continue" "else" "encoding" "eof"
               "error" "eval" "exec" "exit" "expr" "fblocked" "fconfigure"
               "fcopy" "file" "fileevent" "flush" "for" "foreach" "format" "gets"
               "glob" "global" "history" "if" "incr" "info" "interp" "join"
               "lappend" "lindex" "linsert" "list" "llength" "load" "lrange"
               "lreplace" "lsearch" "lset" "lsort" "namespace" "open" "package"
               "pid" "puts" "pwd" "read" "regexp" "regsub" "rename" "return"
               "scan" "seek" "set" "socket" "source" "split" "string" "subst"
               "switch" "tclLog" "tell" "time" "trace" "unknown" "unset" "update"
               "uplevel" "upvar" "variable" "vwait" "while")
           eow)
      (0 'font-lock-constant-face t))
     ;; brightblue: proc
     ($,(rx bow "proc" (+ space))
      (0 'font-lock-comment-face t))
     ($,(rx (any "{}()"))
      (0 'font-lock-comment-face t))
     ;; green: syntax
     ($,(rx (any "()$;`|\\$>=!&|"))
      (0 'font-lock-keyword-face t))
     ;; brightyellow: numbers
     ($,(rx bow (+ digit) (? "." (+ digit)) eow)
      (0 'font-lock-string-face t))
     ;; yellow: strings
     ($,(rx (or (seq "\"" (* (not (any "\"\\"))) "\"")
               (seq "'"  (* (not (any "'\\")))  "'")))
      (0 'font-lock-string-face t))
     ;; brightred: variables
     ($,(rx "${" (+ (in "0-9A-Z_!@#$*?-")) "}")
      (0 'font-lock-type-face t))
     ($,(rx "$" (+ (in "0-9A-Z_!@#$*?-")))
      (0 'font-lock-type-face t))
     ;; magenta: comments
     ($,(rx (or bol (* space)) "#" (* nonl))
      (0 'font-lock-function-name-face t)))
  'append)

(add-hook 'tcl-mode-hook #'nano-keys-lang--setup-tcl)


;; ============================================================
;; AWK
;; ============================================================
(defun nano-keys-lang--setup-awk ()
  (font-lock-add-keywords
   nil
   `(;; brightyellow: built-in variables
     ($,(rx bow
           (or "ARGC" "ARGIND" "ARGV" "BINMODE" "CONVFMT" "ENVIRON" "ERRNO"
               "FIELDWIDTHS" "FILENAME" "FNR" "FS" "IGNORECASE" "LINT" "NF"
               "NR" "OFMT" "OFS" "ORS" "PROCINFO" "RS" "RT" "RSTART" "RLENGTH"
               "SUBSEP" "TEXTDOMAIN")
           eow)
      (0 'font-lock-string-face t))
     ;; brightblue: special patterns & functions
     ($,(rx bow
           (or "function" "extension" "BEGIN" "END"
               "close" "getline" "next" "nextfile" "print" "printf" "system"
               "fflush" "atan2" "cos" "exp" "int" "log" "rand" "sin" "sqrt"
               "srand" "asort" "asorti" "gensub" "gsub" "index" "length" "match"
               "split" "sprintf" "strtonum" "sub" "substr" "tolower" "toupper"
               "mktime" "strftime" "systime" "and" "compl" "lshift" "or" "rshift"
               "xor" "bindtextdomain" "dcgettext" "dcngettext")
           eow)
      (0 'font-lock-comment-face t))
     ;; cyan: control
     ($,(rx bow
           (or "for" "if" "while" "do" "else" "in" "delete" "exit"
               "break" "continue" "return")
           eow)
      (0 'font-lock-constant-face t))
     ;; red: operators
     ($,(rx (any "-+*/%^|!=&<>?;:\\")) (0 'font-lock-type-face t))
     ($,(rx (any "\\[" "\\]"))          (0 'font-lock-type-face t))
     ;; magenta: regex
     ($,(rx "/" (* (not (any "/\\"))) "/")
      (0 'font-lock-function-name-face t))
     ;; yellow: strings
     ($,(rx (or (seq "\"" (* (not (any "\"\\"))) "\"")
               (seq "'"  (* (not (any "'\\")))  "'")))
      (0 'font-lock-string-face t))
     ;; brightblack: comments
     ($,(rx (or bol (* space)) "#" (* nonl))
      (0 'font-lock-comment-face t))
     ;; TODO
     ($,(rx "TODO" (? ":"))
      (0 'font-lock-constant-face t)))
  'append)

(add-hook 'awk-mode-hook #'nano-keys-lang--setup-awk)


;; ============================================================
;; C#
;; ============================================================
(defun nano-keys-lang--setup-csharp ()
  (font-lock-add-keywords
   nil
   `(;; brightmagenta: class declarations
     ($,(rx "class" (+ space) (+ (in "a-zA-Z0-9"))
           (* space) (? ":" (* space) (+ (in "a-zA-Z0-9."))))
      (0 'font-lock-function-name-face t))
     ;; magenta: annotations
     ($,(rx "@" (+ (in "a-zA-Z")))
      (0 'font-lock-function-name-face t))
     ;; brightblue: function calls
     ($,(rx (in "a-zA-Z_") (* (in "a-zA-Z0-9_")) (* space) "(")
      (0 'font-lock-comment-face t))
     ;; green: types
     ($,(rx bow
           (or "bool" "byte" "sbyte" "char" "decimal" "double" "float" "IntPtr"
               "int" "uint" "long" "ulong" "object" "short" "ushort" "string"
               "base" "this" "var" "void")
           eow)
      (0 'font-lock-keyword-face t))
     ;; cyan: control keywords
     ($,(rx bow
           (or "alias" "as" "case" "catch" "checked" "default" "do" "dynamic"
               "else" "finally" "fixed" "for" "foreach" "goto" "if" "is" "lock"
               "new" "null" "return" "switch" "throw" "try" "unchecked" "while"
               "abstract" "async" "class" "const" "delegate" "enum" "event"
               "explicit" "extern" "get" "implicit" "in" "internal" "interface"
               "namespace" "operator" "out" "override" "params" "partial"
               "private" "protected" "public" "readonly" "ref" "sealed" "set"
               "sizeof" "stackalloc" "static" "struct" "typeof" "unsafe" "using"
               "value" "virtual" "volatile" "yield"
               "from" "where" "select" "group" "info" "orderby" "join" "let"
               "in" "on" "equals" "by" "ascending" "descending")
           eow)
      (0 'font-lock-constant-face t))
     ;; brightred: flow control
     ($,(rx bow (or "break" "continue"))
      (0 'font-lock-type-face t))
     ;; brightcyan: booleans
     ($,(rx bow (or "true" "false"))
      (0 'font-lock-constant-face t))
     ;; red: operators
     ($,(rx (any "-+/*=<>?:!~%&|"))
      (0 'font-lock-type-face t))
     ;; blue: numbers
     ($,(rx bow
           (or (seq (+ digit) (? "." (+ digit)) (? (any "FL")))
               "0x" (+ (in "0-9a-fA-F")) (* (any "FL"))
               "0b" (+ (in "01")) (* (any "FL")))
           eow)
      (0 'font-lock-comment-face t))
     ;; yellow: strings
     ($,(rx (or (seq "\"" (* (not (any "\"\\"))) "\"")
               (seq "'"  (* (not (any "'\\")))  "'")))
      (0 'font-lock-string-face t))
     ;; brightblack: comments
     ($,(rx (or (seq (or bol (* space)) "//" (* nonl))
               (seq "/*" (* nonl) "*/")))
      (0 'font-lock-comment-face t))
     ;; TODO
     ($,(rx "TODO" (? ":"))
      (0 'font-lock-constant-face t)))
  'append)

(add-hook 'csharp-mode-hook #'nano-keys-lang--setup-csharp)
(add-hook 'csharp-ts-mode-hook #'nano-keys-lang--setup-csharp)


;; ============================================================
;; F#
;; ============================================================
(defun nano-keys-lang--setup-fsharp ()
  (font-lock-add-keywords
   nil
   `(;; brightgreen: type/module declarations
     ($,(rx (or "type" "module") (+ space) (+ (in "a-zA-Z0-9"))
           (* space) (? ":" (* space) (+ (in "a-zA-Z0-9."))))
      (0 'font-lock-doc-face t))
     ;; brightmagenta: standard types
     ($,(rx bow
           (or "List" "Seq" "Array" "Option" "Choice" "Map" "list" "seq" "array"
               "option" "choice" "ref" "in" "out")
           eow)
      (0 'font-lock-function-name-face t))
     ;; brightgreen: type parameters
     ($,(rx "<" (+ (in "a-zA-Z0-9'^"))
           (* space) (? ":" (* space) (+ (in "a-zA-Z0-9'^."))) ">")
      (0 'font-lock-doc-face t))
     ;; brightgreen: basic types
     ($,(rx bow
           (or "bool" "byte" "sbyte" "int16" "uint16" "int" "uint32" "int64"
               "uint64" "char" "decimal" "double" "float" "float32" "single"
               "nativeint" "IntPtr" "unativeint" "UIntPtr" "object" "string")
           eow)
      (0 'font-lock-doc-face t))
     ;; cyan: keywords
     ($,(rx bow
           (or "abstract" "and" "let" "as" "assert" "base" "begin" "class"
               "default" "delegate" "do" "for" "to" "in" "while" "done"
               "downcast" "downto" "elif" "if" "then" "else" "end" "exception"
               "extern" "false" "finally" "try" "fixed" "fun" "function" "match"
               "global" "inherit" "inline" "interface" "internal" "lazy" "let!"
               "match!" "member" "module" "mutable" "namespace" "new" "not"
               "not" "struct" "null" "of" "open" "or" "override" "private"
               "public" "rec" "return" "return!" "select" "static" "struct"
               "true" "with" "type" "upcast" "use" "use!" "val" "void" "when"
               "yield" "yield!")
           eow)
      (0 'font-lock-constant-face t))
     ;; red: operators
     ($,(rx (any "-+/*=<>?:!~%&|"))
      (0 'font-lock-type-face t))
     ;; blue: numbers
     ($,(rx bow
           (or (seq (+ digit) (? "." (+ digit)) (? (any "FL")))
               "0x" (+ (in "0-9a-fA-F")) (* (any "FL"))
               "0b" (+ (in "01")) (* (any "FL")))
           eow)
      (0 'font-lock-comment-face t))
     ;; yellow: strings
     ($,(rx "\"" (* (not (any "\"\\"))) "\"")
      (0 'font-lock-string-face t))
     ;; brightblack: comments
     ($,(rx (or (seq (or bol (* space)) "//" (* nonl))
               (seq "/*" (* nonl) "*/")
               (seq "(*" (* nonl) "*)")))
      (0 'font-lock-comment-face t))
     ;; TODO
     ($,(rx "TODO" (? ":"))
      (0 'font-lock-constant-face t))
     ;; red: preprocessor
     ($,(rx "#if" (+ nonl))
      (0 'font-lock-type-face t))
     ($,(rx "#endif")
      (0 'font-lock-type-face t))
     ;; white: quoted strings
     ($,(rx "``" (* (nonl)) "``")
      (0 'font-lock-string-face t)))
  'append)

(add-hook 'fsharp-mode-hook #'nano-keys-lang--setup-fsharp)


;; ============================================================
;; OCaml
;; ============================================================
(defun nano-keys-lang--setup-ocaml ()
  (font-lock-add-keywords
   nil
   `(;; red: UPPER_CASE (modules/types)
     ($,(rx bow (in "A-Z") (+ (in "0-9a-z_")) (? (> 2 eow))
      (0 'font-lock-type-face t))
     ;; green: declarations
     ($,(rx bow
           (or "let" "val" "method" "in" "and" "rec" "private" "virtual" "constraint")
           eow)
      (0 'font-lock-keyword-face t))
     ;; red: structure items
     ($,(rx bow
           (or "type" "open" "class" "module" "exception" "external")
           eow)
      (0 'font-lock-type-face t))
     ;; blue: patterns
     ($,(rx bow
           (or "fun" "function" "functor" "match" "try" "with")
           eow)
      (0 'font-lock-comment-face t))
     ;; yellow: pattern modifiers
     ($,(rx bow (or "as" "when" "of"))
      (0 'font-lock-string-face t))
     ;; cyan: conditions
     ($,(rx bow (or "if" "then" "else"))
      (0 'font-lock-constant-face t))
     ;; magenta: blocks
     ($,(rx bow
           (or "begin" "end" "object" "struct" "sig" "for" "while" "do" "done"
               "to" "downto")
           eow)
      (0 'font-lock-function-name-face t))
     ;; green: constants
     ($,(rx bow (or "true" "false"))
      (0 'font-lock-keyword-face t))
     ;; green: modules/classes
     ($,(rx bow (or "include" "inherit" "initializer"))
      (0 'font-lock-keyword-face t))
     ;; yellow: expr modifiers
     ($,(rx bow (or "new" "ref" "mutable" "lazy" "assert" "raise"))
      (0 'font-lock-string-face t))
     ;; brightblack: strings
     ($,(rx "\"" (* (not (any "\"\\"))) "\"")
      (0 'font-lock-comment-face t)))
  'append)

(add-hook 'ocaml-mode-hook #'nano-keys-lang--setup-ocaml)
(add-hook 'tuareg-mode-hook #'nano-keys-lang--setup-ocaml)


;; ============================================================
;; Arduino (INO)
;; ============================================================
(defun nano-keys-lang--setup-arduino ()
  (font-lock-add-keywords
   nil
   `(;; brightred: ALL_CAPS constants
     ($,(rx bow (+ (in "A_Z")) (+ (in "0-9A-Z_")) eow)
      (0 'font-lock-type-face t))
     ;; green: constants
     ($,(rx bow (or "HIGH" "LOW" "INPUT" "OUTPUT" "PI" "HALF_PI" "TWO_PI"
                     "LSBFIRST" "MSBFIRST" "CHANGE" "FALLING" "RISING"
                     "DEFAULT" "EXTERNAL" "INTERNAL" "INTERNAL1V1" "INTERNAL2V56"
                     "DEC" "BIN" "HEX" "OCT" "BYTE")
           eow)
      (0 'font-lock-keyword-face t))
     ;; green: data types
     ($,(rx bow (or "boolean" "byte" "char" "float" "int" "long" "word")
           eow)
      (0 'font-lock-keyword-face t))
     ;; brightyellow: control + math + I/O functions
     ($,(rx bow
           (or "case" "class" "default" "do" "double" "else" "false" "for" "if"
               "new" "null" "private" "protected" "public" "short" "signed"
               "static" "String" "switch" "this" "throw" "try" "true" "unsigned"
               "void" "while"
               "abs" "acos" "asin" "atan" "atan2" "ceil" "constrain" "cos"
               "degrees" "exp" "floor" "log" "map" "max" "min" "radians" "random"
               "randomSeed" "round" "sin" "sq" "sqrt" "tan"
               "bitRead" "bitWrite" "bitSet" "bitClear" "bit" "highByte" "lowByte"
               "analogReference" "analogRead" "analogWrite"
               "attachInterrupt" "detachInterrupt"
               "delay" "delayMicroseconds" "millis" "micros"
               "pinMode" "digitalWrite" "digitalRead"
               "interrupts" "noInterrupts"
               "noTone" "pulseIn" "shiftIn" "shiftOut" "tone"
               "setup" "loop")
           eow)
      (0 'font-lock-string-face t))
     ;; magenta: flow control + Serial
     ($,(rx bow (or "goto" "continue" "break" "return"
                     "Serial" "Serial1" "Serial2" "Serial3"
                     "begin" "end" "peek" "read" "print" "println" "available" "flush")
           eow)
      (0 'font-lock-function-name-face t))
     ;; brightcyan: preprocessor
     ($,(rx bol (* space) "#" (* space)
           (or "define" "include" "include_next" "undef" "ifndef" "endif"
               "elif" "else" "if" "warning" "error" "pragma"))
      (0 'font-lock-preprocessor-face t))
     ;; brightyellow: strings
     ($,(rx "\"" (* (not (any "\"\\"))) "\"")
      (0 'font-lock-string-face t))
     ;; brightblue: comments
     ($,(rx (or (seq "//" (* nonl))
               (seq "/*" (* nonl) "*/")))
      (0 'font-lock-comment-face t)))
  'append)

(add-hook 'arduino-mode-hook #'nano-keys-lang--setup-arduino)


;; ============================================================
;; Verilog / SystemVerilog
;; ============================================================
(defun nano-keys-lang--setup-verilog ()
  (font-lock-add-keywords
   nil
   `(;; brightred: module/task/interface/program/class definitions
     ($,(rx (or "module" "package" "task" "interface" "program" "class")
           (+ space) (+ (in "0-9A-Z_")))
      (0 'font-lock-type-face t))
     ($,(rx "function" (+ space) (+ (in "0-9A-Z_")) (+ space) (+ (in "0-9A-Z_")))
      (0 'font-lock-type-face t))
     ;; green: Verilog keywords
     ($,(rx bow
           (or "always" "and" "assign" "automatic" "begin" "buf" "bufif0" "bufif1"
               "case" "casex" "casez" "cell" "class" "cmos" "config"
               "deassign" "default" "defparam" "design" "disable" "edge" "else"
               "end" "endcase" "endconfig" "endfunction" "endgenerate"
               "endmodule" "endprimitive" "endspecify" "endtable" "endtask"
               "event" "for" "force" "forever" "fork" "function" "generate"
               "genvar" "highz0" "highz1" "if" "iff" "ifnone" "incdir" "include"
               "initial" "inout" "input" "instance" "integer" "join"
               "large" "liblist" "library" "localparam" "macromodule" "medium"
               "module" "nand" "negedge" "nmos" "nor" "noshowcancelled"
               "not" "notif0" "notif1" "null" "or" "output" "parameter" "pmos"
               "posedge" "primitive" "pull0" "pull1" "pulldown" "pullup"
               "pulsestyle_onevent" "pulsestyle_ondetect" "rcmos" "real"
               "realtime" "reg" "release" "repeat" "rnmos" "rpmos" "rtran"
               "rtranif0" "rtranif1" "scalared" "showcancelled" "signed" "small"
               "specify" "specparam" "strong0" "strong1" "supply0" "supply1"
               "table" "task" "time" "tran" "tranif0" "tranif1" "tri" "tri0"
               "tri1" "triand" "trior" "trireg" "unsigned" "use" "uwire"
               "vectored" "wait" "wand" "weak0" "weak1" "while" "wire" "wor"
               "xnor" "xor")
           eow)
      (0 'font-lock-keyword-face t))
     ;; green: SystemVerilog keywords
     ($,(rx bow
           (or "alias" "always_comb" "always_ff" "always_latch" "assert" "assume"
               "before" "bind" "bins" "binsof" "bit" "break" "byte"
               "chandle" "clocking" "const" "constraint" "context" "continue"
               "cover" "covergroup" "coverpoint" "cross" "dist" "do"
               "endclass" "endclocking" "endgroup" "endinterface" "endpackage"
               "endprogram" "endproperty" "endsequence" "enum"
               "expect" "export" "extends" "extern" "final" "first_match"
               "foreach" "forkjoin" "ignore_bins" "illegal_bins" "import"
               "inside" "int" "interface" "intersect" "join_any" "join_none"
               "local" "logic" "longint" "matches" "modport" "new" "package"
               "packed" "priority" "program" "property" "protected" "pure"
               "rand" "randc" "randcase" "randsequence" "ref" "return"
               "sequence" "shortint" "shortreal" "solve" "static" "string"
               "struct" "super" "tagged" "this" "throughout" "timeprecision"
               "timeunit" "type" "typedef" "union" "unique" "var" "virtual"
               "void" "wait_order" "wildcard" "with" "within")
           eow)
      (0 'font-lock-keyword-face t))
     ;; cyan: builtin functions ($display etc)
     ($,(rx "$" (+ (in "0-9A-Z_")))
      (0 'font-lock-constant-face t))
     ;; brightyellow: strings
     ($,(rx "\"" (* (not (any "\"\\"))) "\"")
      (0 'font-lock-string-face t))
     ;; brightblue: comments
     ($,(rx (or (seq "//" (* nonl))
               (seq "/*" (* nonl) "*/")))
      (0 'font-lock-comment-face t))
     ;; TODO
     ($,(rx (or "FIXME" "TODO" "XXX"))
      (0 'font-lock-warning-face t)))
  'append)

(add-hook 'verilog-mode-hook #'nano-keys-lang--setup-verilog)
(add-hook 'verilog-ts-mode-hook #'nano-keys-lang--setup-verilog)


;; ============================================================
;; GLSL
;; ============================================================
(defun nano-keys-lang--setup-glsl ()
  (font-lock-add-keywords
   nil
   `(;; brightblue: function calls
     ($,(rx (in "a-zA-Z_") (* (in "a-zA-Z0-9_")) (* space) "(")
      (0 'font-lock-comment-face t))
     ;; green: types
     ($,(rx bow
           (or "void" "bool" "bvec2" "bvec3" "bvec4" "int" "ivec2" "ivec3"
               "ivec4" "float" "vec2" "vec3" "vec4" "mat2" "mat3" "mat4"
               "struct" "sampler1D" "sampler2D" "sampler3D" "samplerCUBE"
               "sampler1DShadow" "sampler2DShadow")
           eow)
      (0 'font-lock-keyword-face t))
     ;; green: gl_ prefixed
     ($,(rx bow "gl_"
           (or "DepthRangeParameters" "PointParameters" "MaterialParameters"
               "LightSourceParameters" "LightModelParameters" "LightModelProducts"
               "LightProducts" "FogParameters")
           eow)
      (0 'font-lock-keyword-face t))
     ;; cyan: control
     ($,(rx bow
           (or "const" "attribute" "varying" "uniform" "in" "out" "inout"
               "if" "else" "return" "discard" "while" "for" "do")
           eow)
      (0 'font-lock-constant-face t))
     ;; brightred: flow control
     ($,(rx bow (or "break" "continue"))
      (0 'font-lock-type-face t))
     ;; brightcyan: booleans
     ($,(rx bow (or "true" "false"))
      (0 'font-lock-constant-face t))
     ;; red: operators
     ($,(rx (any "-+/*=<>?:!~%&|^"))
      (0 'font-lock-type-face t))
     ;; blue: numbers
     ($,(rx bow (or (+ digit) "0x" (* (in "0-9a-fA-F"))) eow)
      (0 'font-lock-comment-face t))
     ;; brightblack: comments
     ($,(rx (or (seq (or bol (* space)) "//" (* nonl))
               (seq "/*" (* nonl) "*/")))
      (0 'font-lock-comment-face t))
     ;; TODO
     ($,(rx "TODO" (? ":"))
      (0 'font-lock-constant-face t)))
  'append)

(add-hook 'glsl-mode-hook #'nano-keys-lang--setup-glsl)


;; ============================================================
;; Nanorc
;; ============================================================
(defun nano-keys-lang--setup-nanorc ()
  (font-lock-add-keywords
   nil
   `(;; brightred: set/unset/include/syntax/color lines
     ($,(rx bol (* space)
           (group (or "set" "unset" "include" "syntax" "icolor" "color")))
      (1 'font-lock-type-face t))
     ;; brightgreen: set options
     ($,(rx bol (* space) (or "set" "unset") (+ space)
           (group (+ (in "a-z_"))))
      (1 'font-lock-doc-face t))
     ;; green: keywords
     ($,(rx bow
           (or "bind" "set" "unset" "syntax" "header" "include" "magic")
           eow)
      (0 'font-lock-keyword-face t))
     ;; white: strings
     ($,(rx "\"" (* (not (any "\"\\"))) "\"")
      (0 'font-lock-string-face t))
     ;; brightblue: comments
     ($,(rx bol (* space) "#" (* nonl))
      (0 'font-lock-comment-face t))
     ($,(rx bol (* space) "##" (* nonl))
      (0 'font-lock-constant-face t)))
  'append)

(add-hook 'nanorc-mode-hook #'nano-keys-lang--setup-nanorc)


;; ============================================================
;; Global mode
;; ============================================================
;;;###autoload
(define-minor-mode nano-keys-lang-mode
  "Toggle nano-style syntax highlighting for 40+ languages.

Adds font-lock keywords replicating nano's nanorc syntax rules."
  :global t
  :lighter " NanoLang"
  (if nano-keys-lang-mode
      (progn
        (dolist (buf (buffer-list))
          (with-current-buffer buf
            (when (derived-mode-p 'prog-mode)
              (font-lock-flush)
              (font-lock-ensure))))
        (message "Nano-Keys language highlighting enabled (40+ languages)."))
    (dolist (buf (buffer-list))
      (with-current-buffer buf
        (when (derived-mode-p 'prog-mode)
          (font-lock-flush)
          (font-lock-ensure)))
    (message "Nano-Keys language highlighting disabled."))))


(provide 'nano-keys-lang)

;;; nano-keys-lang.el ends here
