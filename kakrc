colorscheme tomorrow-night

set-option global tabstop 2
set-option global indentwidth 2
set-option global scrolloff 5,1
set-option global grepcmd 'rg --column'
set-option global completers filename word=all

add-highlighter global/ number-lines

eval %sh{kak-lsp --session $kak_session --kakoune --config ~/.config/kak/kak-lsp.toml}
lsp-enable
lsp-inlay-hints-enable global

map global user k :lsp-hover<ret> -docstring 'LSP hover'
