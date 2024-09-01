# My [Kakoune](https://kakoune.org) Configuration

Kakoune is an interesting editor. [Helix](https://helix-editor.com) was heavily inspired by it.

## Try it out!

I have Kakoune setup in a specific way, which requires external dependencies to access features such as
fuzzy finder, Git UI via LazyGit, file explorer, etc.

### Current dependencies

- [ripgrep (rg)](https://github.com/BurntSushi/ripgrep)
- [tmux](https://github.com/tmux/tmux/wiki/Installing)
- [fzf](https://github.com/junegunn/fzf)
- [LazyGit](https://github.com/jesseduffield/lazygit)
- [Yazi](https://github.com/sxyazi/yazi)

All of these can be installed via [Homebrew](https://brew.sh):

```sh
brew install ripgrep tmux fzf lazygit yazi
```

### Installing the config

Make sure that you have the editor downloaded and installed on your system. Then, install
[Kakoune LSP](https://github.com/kakoune-lsp/kakoune-lsp) and clone this repository:

> Make a backup of your current config if you have any!

```sh
git clone https://github.com/nizamiza/kak.git ~/.config/kak
```

Start hacking!
