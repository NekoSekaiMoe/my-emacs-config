# Nano mode for emacs

Personal Emacs configuration — a single `init.el` that makes Emacs behave like the Nano editor, with modern IDE features.

## Nano Keybindings

| Key | Action |
|-----|--------|
| `C-g` | Help |
| `C-o` / `C-s` | Save |
| `C-w` | Search |
| `C-k` | Cut line |
| `C-t` | Open file |
| `C-c` | Go to line |
| `C-6` | Mark set/clear |
| `C-x` | Exit |
| `C-r` | Read file |
- `C-\` | Replace |
| `C-u` | Paste |
| `C-j` | Justify |
| `C-/` | Go to line |
| `M-u` | Undo |
| `M-e` | Redo |

## IDE Features

- **company** — auto-completion popup after 1 character, `C-n`/`C-p` to navigate, `C-j`/`TAB` to confirm
- **flycheck** — real-time syntax checking on save and mode change
- **yasnippet** — code snippet expansion, snippets in `~/.emacs.d/snippets`

## Structure

- `init.el` — the entire config
- No build, test, or package manager

## Usage

Edit `init.el` and reload with `M-x eval-buffer` or restart Emacs. First startup installs company, flycheck, and yasnippet from MELPA automatically.
