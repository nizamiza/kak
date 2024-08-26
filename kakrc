colorscheme tomorrow-night

set-option global tabstop 2
set-option global indentwidth 2
set-option global scrolloff 5,1
set-option global grepcmd 'rg --column'
set-option global completers filename word=all

add-highlighter global/ number-lines

# use up and down arrow keys for navigating autocomplete suggestions
hook global InsertCompletionShow .* %{
	try %{
  	# this command temporarily removes cursors preceded by whitespace;
    # if there are no cursors left, it raises an error, does not
    # continue to execute the mapping commands, and the error is eaten
    # by the `try` command so no warning appears.
    execute-keys -draft 'h<a-K>\h<ret>'
    map window insert <down> <c-n>
    map window insert <up> <c-p>
    hook -once -always window InsertCompletionHide .* %{
      unmap window insert <down> <c-n>
      unmap window insert <up> <c-p>
    }
  }
}

# LSP config
eval %sh{kak-lsp --session $kak_session --kakoune --config ~/.config/kak/kak-lsp.toml}
lsp-enable

lsp-inlay-diagnostics-enable global

map global insert <tab> '<a-;>:try lsp-snippets-select-next-placeholders catch %{ execute-keys -with-hooks <lt>tab> }<ret>' -docstring 'Select next snippet placeholder'
map global user k :lsp-hover<ret>             -docstring 'Hover documentation'
map global user a :lsp-code-actions<ret>      -docstring 'Code actions'
map global user d :lsp-diagnostic-object<ret> -docstring 'Next diagnostics error'
map global user D :lsp-diagnostics<ret>       -docstring 'All diagnostics'
map global user s :lsp-document-symbol<ret>   -docstring 'Document symbols'

hook global WinSetOption filetype=(typescript|javascript|css|html|json|rust) %{
  hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
  hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
  hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens
  hook -once -always window WinSetOption filetype=.* %{
    remove-hooks window semantic-tokens
  }
}
