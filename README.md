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

## IDE Features

- **company** — auto-completion popup after 1 character, `C-n`/`C-p` to navigate, `C-j`/`TAB` to confirm
- **flycheck** — real-time syntax checking on save and mode change
- **yasnippet** — code snippet expansion, snippets in `~/.emacs.d/snippets`
- **eglot (LSP)** — on-demand per language; starts only when the server binary is installed

## Supported Languages

Go, Rust, Python, JavaScript, TypeScript, YAML, TOML, JSON, Markdown, Dockerfile, Lua — each with autoload + optional LSP.

## Search & Replace

- `C-w` opens a custom nano-style search prompt. Enter empty input to repeat last search (find next). Supports wrap and `M-c` to toggle case.
- `C-\` opens a custom nano-style replace flow: enter search term → replace term → interactive match navigation (`y`/`n`/`a` for all).

## Startup Page

On launch, a custom `*Welcome*` buffer is shown with a keybinding cheat sheet and up to 10 recent files. Press `1`–`0` to open a file, `C-o` to browse, `C-r` to refresh.

## Structure

- `init.el` — the entire config
- No build, test, or package manager

## Usage

Edit `init.el` and reload with `M-x eval-buffer` or restart Emacs. First startup installs company, flycheck, and yasnippet from MELPA automatically.
