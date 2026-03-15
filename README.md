# nvim_temper_syntax_highlighter

Syntax highlighting for the [Temper](https://github.com/nicegamer7/temper) programming language in Neovim.

Highlights both `.temper` files and `.temper.md` literate programming files, with distinct visual treatment for code blocks vs. markdown prose.

> This plugin is auto-published from [templight](https://github.com/notactuallytreyanastasio/templight). Do not edit this repo directly.

## Installation

### lazy.nvim

```lua
{
  "notactuallytreyanastasio/nvim_temper_syntax_highlighter",
}
```

### packer.nvim

```lua
use "notactuallytreyanastasio/nvim_temper_syntax_highlighter"
```

### vim-plug

```vim
Plug 'notactuallytreyanastasio/nvim_temper_syntax_highlighter'
```

### Manual

Clone into your Neovim packages directory:

```bash
git clone https://github.com/notactuallytreyanastasio/nvim_temper_syntax_highlighter.git \
  ~/.local/share/nvim/site/pack/plugins/start/nvim_temper_syntax_highlighter
```

## What it does

- Registers the `temper` filetype for `*.temper` files
- Applies syntax highlighting on `BufEnter`, `TextChanged`, and `TextChangedI`
- Handles `.temper.md` literate files:
  - 4-space indented blocks and `` ```temper `` fenced blocks get Temper code highlighting
  - Prose lines get markdown highlighting in a distinct color palette
  - Non-temper fenced blocks (e.g. `` ```log ``) are dimmed

## Highlight groups

### Code tokens

| Token | Highlight group | Meaning |
|-------|----------------|---------|
| `kw` | `@keyword` | Keywords (`let`, `if`, `fn`, `class`, ...) |
| `ty` | `@type` | Built-in types (`Int`, `String`, `List`, ...) |
| `st` | `@string` | String literals |
| `nm` | `@number` | Number literals |
| `cm` | `@comment` | Comments |
| `op` | `@operator` | Operators |
| `lt` | `@boolean` | Literal values (`true`, `false`, `null`) |
| `id` | `@variable` | Identifiers |
| `pn` | `@punctuation` | Punctuation |
| `ch` | `@character` | Character literals (`char'x'`) |
| `dc` | `@attribute` | Decorators (`@decorator`) |

### Markdown tokens

| Token | Highlight group | Meaning |
|-------|----------------|---------|
| `mh` | `@markup.heading` | Headings |
| `mt` | `@markup.raw` | Prose text |
| `me` | `@markup.italic` | Emphasis |
| `mb` | `@markup.strong` | Bold |
| `mc` | `@markup.raw.block` | Inline code |
| `ml` | `@markup.link` | Links |
| `mf` | `@comment` | Fence markers |

## Requirements

- Neovim 0.9+
