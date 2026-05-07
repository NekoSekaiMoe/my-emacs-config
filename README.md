# Nano mode for emacs

Personal Emacs configuration — a single `init.el` that makes Emacs behave like the Nano editor, with modern IDE features.

## Nano Keybindings

| Key | Action |
|-----|--------|
| `C-g` | Cancel / keyboard quit |
| `C-?` | Help (info) |
| `C-o` / `C-s` | Save |
| `C-w` | Search (custom nano-style) |
| `C-f` | Go to line |
| `C-k` | Cut (region or whole line) |
| `C-t` | Open file |
| `C-c` | Show cursor location |
| `C-6` / `C-^` | Mark set/clear |
| `C-x` | Exit (prompts to save) |
| `C-r` | Read file (open) |
| `C-\` | Replace (custom nano-style) |
| `C-u` | Paste |
| `C-j` | Justify paragraph |
| `C-/` | Go to line (with sub-commands) |
| `M-u` | Undo |
| `M-e` | Redo |
| `M-c` | Toggle search case sensitivity |

### Go To Line Sub-commands

After pressing `C-/` and entering a line number, the following sub-commands are available:

| Key | Action |
|-----|--------|
| `C-o` | Jump to end of file |
| `M-w` | Jump to start of file |
| `C-v` | Jump to bottom of screen |
| `C-y` | Jump to top of screen |
| `C-t` | Jump to specific text |
| `C-c` / `C-g` | Cancel |

## IDE Features

- **company** — auto-completion popup after 1 character, `C-n`/`C-p` to navigate, `C-j`/`TAB` to confirm
- **flycheck** — real-time syntax checking on save and mode change
- **yasnippet** — code snippet expansion, snippets in `~/.emacs.d/snippets`
- **eglot (LSP)** — on-demand per language; starts only when the server binary is installed

## Supported Languages

| Language | LSP Server | Keyword Completion |
|----------|-----------|-------------------|
| C/C++ | clangd | — |
| Go | gopls | ✅ |
| Java | jdtls | ✅ |
| Kotlin | kotlin-language-server | ✅ |
| Rust | rust-analyzer | ✅ |
| Python | pylsp/pyright | ✅ |
| JavaScript/TypeScript | typescript-language-server | ✅ |
| CMake | cmake-language-server | ✅ |
| YAML | yaml-language-server | — |
| JSON | vscode-json-language-server | — |
| Markdown | marksman | — |
| Dockerfile | docker-langserver | ✅ |
| Lua | lua-language-server | ✅ |
| TOML | — | — |
| Makefile | — | — |
| Autoconf | — | — |
| Meson | — | — |
| Lex/Yacc | — | — |

## Search & Replace

- `C-w` opens a custom nano-style search prompt. Enter empty input to repeat last search (find next). Supports wrap and `M-c` to toggle case.
- `C-\` opens a custom nano-style replace flow: enter search term → replace term → interactive match navigation (`y`/`n`/`a` for all).

## Startup Page

On launch, a custom `*Welcome*` buffer is shown with a keybinding cheat sheet and up to 10 recent files. Press `1`–`0` to open a file, `C-o` to browse, `C-r` to refresh.

## Structure

```
init.el              ← Entry point, loads modules
nano/
  nano-util.el       ← Encoding, clipboard, basic settings, backup, UI
  nano-window.el     ← Header-line, mode-line, GC optimization
  nano-keys.el       ← Keybindings, search, replace, go-to-line
  nano-lsp.el        ← LSP config, language modes, keyword completion
  nano-welcome.el    ← Startup welcome page
```

- No build, test, or package manager.

## Usage

Edit `init.el` or files in `nano/` and reload with `M-x eval-buffer` or restart Emacs. First startup auto-installs required packages from MELPA:

- Core: `company`, `flycheck`, `yasnippet`
- Languages: `go-mode`, `python-mode`, `js2-mode`, `typescript-mode`, `yaml-mode`, `toml-mode`, `json-mode`, `markdown-mode`, `dockerfile-mode`, `lua-mode`, `kotlin-mode`, `cmake-mode`, `meson-mode`
