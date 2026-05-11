# Termux Stable Branch

This branch is intended to be a fixed Termux-compatible baseline for this
Neovim config.

## Version policy

- Neovim plugins are pinned by `lazy-lock.json`.
- `lazy.nvim` update checking is disabled on this branch. Use `:Lazy restore`
  for this branch, and run `:Lazy update` only when intentionally rolling the
  baseline forward.
- On Termux, Mason stays available as a UI, but it does not auto-install LSP
  servers. Language servers are expected to be installed on `$PATH`.
- On Termux, `blink.cmp` uses the Lua fuzzy matcher instead of the Rust matcher
  binary, so completion does not depend on an Android-specific prebuilt binary.

## Termux packages

Install the Termux app from F-Droid or GitHub, then install the runtime tools:

```sh
pkg update
pkg install git neovim nodejs-lts npm ripgrep fd unzip curl tar gzip make clang pkg-config python golang rust lua-language-server stylua lazygit termux-api
```

`termux-api` also requires the separate Termux:API Android app if you want the
system clipboard mappings to work through Neovim's clipboard provider.

Known compatible Termux package baseline checked on 2026-05-11:

| Tool | Termux package | Baseline |
| --- | --- | --- |
| Neovim | `neovim` | 0.12.2 |
| Node.js | `nodejs-lts` | 24.14.1 |
| Go | `golang` | 1.26.2 |
| Rust | `rust` | 1.95.0 |
| Python | `python` | 3.13.13 |
| Lua LSP | `lua-language-server` | 3.18.2 |
| ripgrep | `ripgrep` | 15.1.0 |
| fd | `fd` | 10.4.2 |
| lazygit | `lazygit` | 0.61.1 |
| make | `make` | 4.4.1 |

Termux packages are rolling. If you need a fully frozen phone environment after
installing, record `pkg list-installed` output with this branch.

## PATH language servers

The configured LSP servers are:

- `gopls`
- `lua_ls`
- `bashls`
- `yamlls`
- `jsonls`
- `taplo`
- `buf_ls`

Install the PATH executables with:

```sh
go install golang.org/x/tools/gopls@latest
go install github.com/bufbuild/buf/cmd/buf@latest
npm install -g bash-language-server yaml-language-server vscode-langservers-extracted
cargo install --features lsp --locked taplo-cli
```

After installation, make sure Go's bin directory is on PATH:

```sh
echo 'export PATH="$HOME/go/bin:$PATH"' >> ~/.profile
. ~/.profile
```

## Formatter tools

The current formatter config expects:

- `stylua`
- `gofmt`
- `goimports`
- `gofumpt`
- `gofumports`
- `golines`

Install the Go formatters with:

```sh
go install golang.org/x/tools/cmd/goimports@latest
go install mvdan.cc/gofumpt@latest
go install mvdan.cc/gofumpt/gofumports@v0.1.1
go install github.com/segmentio/golines@latest
```

## Verification

From this repo:

```sh
nvim --headless -u NONE -i NONE -l scripts/check-termux-config.lua
```

Inside Neovim on Termux:

```vim
:checkhealth vim.lsp
:Lazy restore
```
