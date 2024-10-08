####################################
# Base configuration               #
####################################

colorscheme kanagawa

set-option global tabstop 2
set-option global aligntab false
set-option global indentwidth 2
set-option global scrolloff 5,1
set-option global grepcmd 'rg -Hn --no-heading'
set-option global completers filename word=all

add-highlighter global/ number-lines
add-highlighter global/ column 128 default,bright-black
add-highlighter global/ show-whitespaces -indent "▏" -spc " " -tab "→" -lf " "

####################################
# Hooks                            #
####################################

# keep system clipboard in sync with Kakoune
hook global RegisterModified '"' %{
  nop %sh{
    printf %s "$kak_main_reg_dquote" | pbcopy
  }
}

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

####################################
# LSP configuration                #
####################################

eval %sh{kak-lsp --session $kak_session --kakoune --config ~/.config/kak/kak-lsp.toml}
lsp-enable

lsp-inlay-diagnostics-enable global

map global insert <tab> '<a-;>:try lsp-snippets-select-next-placeholders catch %{ execute-keys -with-hooks <lt>tab> }<ret>' \
  -docstring "Select next snippet placeholder"

map global user   . ':try %{lsp-inlay-hints-enable buffer} catch %{lsp-inlay-hints-disable buffer}<ret>' \
  -docstring "Toggle inlay hints"

map global normal K ':lsp-hover<ret>'             -docstring "Hover documentation"
map global user   a ':lsp-code-actions<ret>'      -docstring "Code actions"
map global user   d ':lsp-diagnostic-object<ret>' -docstring "Next diagnostics error"
map global user   D ':lsp-diagnostics<ret>'       -docstring "All diagnostics"
map global user   s ':lsp-document-symbol<ret>'   -docstring "Document symbols"
map global user   r ':lsp-rename-prompt<ret>'     -docstring "Rename symbol under the cursor"

hook global WinSetOption filetype=(typescript|javascript|css|html|json|rust|ruby|eruby) %{
  hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
  hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
  hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens
  hook window BufWritePre .* lsp-formatting-sync
  hook -once -always window WinSetOption filetype=.* %{
    remove-hooks window semantic-tokens
  }
}

####################################
# Custom commands and integrations #
####################################

# FZF
define-command -docstring "Search for a file using fzf" find-file %{
  nop %sh{
  	file="$(rg --files | fzf --tmux 80%)"
  	echo "edit $file" > $kak_command_fifo
	}
}

# LazyGit
define-command -docstring "Open LazyGit" lazygit %{
  nop %sh{
    current_path="$(tmux display-message -pF '#{pane_current_path}')"
    tmux popup -E -h 95% -w 95% -e kak_command_fifo=$kak_command_fifo -d "$current_path" -- 'lazygit'
  }
}

# Yazi - a file explorer
define-command -docstring "Open Yazi file explorer" yazi %{
  nop %sh{
    current_path="$(tmux display-message -pF '#{pane_current_path}')"
    tmux popup -E -h 95% -w 95% -e kak_command_fifo=$kak_command_fifo -d "$current_path" -- '
      yazi --chooser-file /tmp/yazi-chooser-file.txt
      echo "edit $(tail -n 1 /tmp/yazi-chooser-file.txt)" > $kak_command_fifo
    '
  }
}

map global user f :find-file<ret> -docstring "Find a file"
map global user g :lazygit<ret>   -docstring "Open LazyGit"
map global user o :yazi<ret>      -docstring "Open Yazi"
