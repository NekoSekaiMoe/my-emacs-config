# nano-keys.el — Nano-style Emacs (keybindings, theme, status bar, languages, LSP)

Faithfully replicates the nano editor experience in Emacs.

| Mode | What it does |
|------|-------------|
| `nano-keys-mode` | Nano keyboard shortcuts |
| `nano-keys-theme-mode` | Nano default syntax highlighting colours |
| `nano-keys-statusbar-mode` | Nano two-line bottom title/status bar |
| `nano-keys-lang-mode` | Per-language nanorc highlighting (40+ languages) |
| `nano-keys-lsp-mode` | LSP integration with nano keybindings |

## Installation

```elisp
(add-to-list 'load-path "~/path/to/nano-keys")
(require 'nano-keys)
(require 'nano-keys-lang)   ; optional: per-language highlighting
(require 'nano-keys-lsp)    ; optional: LSP integration

(nano-keys-mode 1)
(nano-keys-theme-mode 1)
(nano-keys-statusbar-mode 1)
(nano-keys-lang-mode 1)     ; optional
(nano-keys-lsp-mode 1)      ; optional
```

Or with `use-package`:

```elisp
(use-package nano-keys
  :load-path "~/path/to/nano-keys"
  :config
  (nano-keys-mode 1)
  (nano-keys-theme-mode 1)
  (nano-keys-statusbar-mode 1))

(use-package nano-keys-lang
  :load-path "~/path/to/nano-keys"
  :after nano-keys
  :config (nano-keys-lang-mode 1))

(use-package nano-keys-lsp
  :load-path "~/path/to/nano-keys"
  :after (nano-keys lsp-mode)
  :config (nano-keys-lsp-mode 1))
```

## Keybindings

| Key  | Action          |
|------|-----------------|
| C-o  | Save file       |
| C-x  | Exit Emacs      |
| C-w  | Search forward  |
| C-k  | Cut line        |
| C-u  | Paste cut text  |
| C-g  | Help            |
| C-r  | Read file       |
| C-y  | Page up         |
| C-v  | Page down       |
| C-a  | Line start      |
| C-e  | Line end        |
| C-d  | Delete char     |
| C-h  | Backspace       |
| C-s  | Save            |
| C-l  | Recenter        |
| C-z  | Suspend frame   |
| C-c  | Cursor position |
| C-j  | Justify         |
| C-t  | Spell check     |
| C-_  | Go to line      |
| M-w  | Search next     |
| M-u  | Undo            |
| M-e  | Redo            |
| M-a  | Set mark        |
| M-6  | Copy            |
| M-}  | Indent          |
| M-{  | Unindent        |

## Theme

Colours extracted directly from nano's default nanorc syntax files:

| Colour | Used for | Hex |
|--------|----------|-----|
| **bright red** | Types (`int`, `float`, `void`…) | `#ff0000` |
| **green** | Control-flow keywords (`for`, `if`, `while`…) | `#00aa00` |
| **bright magenta** | Flow control (`return`, `break`, `continue`) | `#ff00ff` |
| **bright cyan** | Preprocessor (`#include`, `#define`…) | `#00ffff` |
| **yellow** | Strings & characters | `#aa5500` |
| **bright blue** | Comments | `#5c5cff` |
| **cyan** | Built-in functions/constants (`None`, `True`, `self`) | `#00aaaa` |
| **bright yellow** | Numbers | `#ffff00` |
| **magenta** | Operators & parentheses | `#aa00aa` |
| **bright green** | Decorators (`@override`), TODO/FIXME | `#00ff00` |

Background: `#000000` / Foreground: `#aaaaaa`

## Language Highlighting (`nano-keys-lang`)

Per-language font-lock keyword rules extracted from nano's nanorc files.
**40+ languages supported:**

| Language | Modes | LSP Server |
|----------|-------|------------|
| C / C++ | `c-mode`, `c++-mode` | clangd |
| Python | `python-mode`, `python-ts-mode` | pylsp, pyright |
| JavaScript / TypeScript | `js-mode`, `js2-mode`, `typescript-mode`, `typescript-ts-mode`, `tsx-ts-mode` | typescript-language-server |
| Go | `go-mode`, `go-ts-mode` | gopls |
| Java | `java-mode`, `java-ts-mode` | jdtls |
| Lua | `lua-mode` | lua-language-server |
| Ruby | `ruby-mode`, `ruby-ts-mode` | solargraph |
| Rust | `rust-mode`, `rust-ts-mode` | rust-analyzer |
| PHP | `php-mode` | intelephense |
| Perl | `perl-mode`, `cperl-mode` | perlnavigator |
| Shell / Bash | `sh-mode`, `bash-ts-mode` | bash-language-server |
| HTML | `html-mode`, `mhtml-mode`, `html-ts-mode` | vscode-html-language-server |
| CSS / SCSS / Less | `css-mode`, `scss-mode`, `less-css-mode`, `css-ts-mode` | vscode-css-language-server |
| JSON | `json-mode`, `json-ts-mode` | vscode-json-language-server |
| YAML | `yaml-mode`, `yaml-ts-mode` | yaml-language-server |
| XML | `nxml-mode`, `xml-mode` | — |
| Markdown | `markdown-mode`, `gfm-mode` | marksman |
| CMake | `cmake-mode`, `cmake-ts-mode` | cmake-language-server |
| TeX / LaTeX | `tex-mode`, `latex-mode`, `LaTeX-mode` | texlab |
| SQL | `sql-mode` | sqls |
| Swift | `swift-mode` | sourcekit-lsp |
| Kotlin | `kotlin-mode`, `kotlin-ts-mode` | kotlin-language-server |
| Scala | `scala-mode`, `scala-ts-mode` | metals |
| Haskell | `haskell-mode`, `haskell-literate-mode` | haskell-language-server |
| Elixir | `elixir-mode`, `elixir-ts-mode` | elixir-ls |
| Lisp / Emacs Lisp | `emacs-lisp-mode`, `lisp-mode`, `scheme-mode` | — |
| Clojure | `clojure-mode`, `clojurescript-mode` | clojure-lsp |
| Fortran | `fortran-mode`, `f90-mode` | fortls |
| Assembly | `asm-mode`, `nasm-mode` | — |
| Makefile | `makefile-mode`, `makefile-gmake-mode` | — |
| TOML | `toml-mode`, `toml-ts-mode` | taplo |
| Dockerfile | `dockerfile-mode`, `dockerfile-ts-mode` | docker-langserver |
| Nginx | `nginx-mode` | nginx-language-server |
| Puppet | `puppet-mode` | puppet-languageserver |
| Tcl | `tcl-mode` | tcl-language-server |
| AWK | `awk-mode` | awk-language-server |
| C# | `csharp-mode`, `csharp-ts-mode` | omnisharp |
| F# | `fsharp-mode` | fsautocomplete |
| OCaml | `ocaml-mode`, `tuareg-mode` | ocamllsp |
| Arduino | `arduino-mode` | clangd |
| Verilog / SystemVerilog | `verilog-mode`, `verilog-ts-mode` | svls |
| GLSL | `glsl-mode` | glsl_analyzer |
| Nanorc | `nanorc-mode` | — |

## LSP Integration (`nano-keys-lsp`)

Nano-style keybindings for LSP operations (works with `lsp-mode` or `eglot`):

| Key | LSP Action | Nano Equivalent |
|-----|-----------|-----------------|
| M-s | Find references | Where Is |
| M-d | Show diagnostics | To Spell |
| M-g | Go to definition | Go To Line |
| M-r | Rename symbol | Read File |
| M-t | Show hover doc | To Spell |
| M-a | Execute code action | Mark Text |
| M-i | Describe thing at point | — |
| M-c | Signature help | — |
| C-M-g | Go to implementation | — |
| C-M-t | Find type definition | — |
| C-M-d | Peek definitions | — |
| C-M-r | Peek references | — |
| C-M-f | Format buffer | — |

Auto-configures LSP servers for all 40+ languages listed above.

## Status Bar

Replicates nano's two-line bottom bar in a dedicated window:

```
  File: example.c **
  C-x Exit   C-o WriteOut   C-w WhereIs   C-k Cut   C-u Uncut   C-g Help
  Ln 42, Col 7
```

- **Line 1** — `File: <name>` with `**` if modified, `[Read Only]` if read-only
- **Line 2** — Nano shortcut hints (keys highlighted in bright cyan)
- **Line 3** — `Ln <line>, Col <column>`

Background: blue (`#0000aa`) / Foreground: white — matching nano's title bar.

## Customization

```elisp
(setq nano-keys-enable-on-load nil)      ; auto-enable keybindings (default nil)
(setq nano-keys-statusbar-show t)        ; show status bar (default t)
(setq nano-keys-statusbar-height 2)      ; status bar height in lines (default 2)
(setq nano-keys-lsp-enable-diagnostics t) ; LSP diagnostics (default t)
(setq nano-keys-lsp-enable-completion t)  ; LSP completion (default t)
(setq nano-keys-lsp-enable-hover t)       ; LSP hover docs (default t)
```

## License

GPL-3.0-or-later
