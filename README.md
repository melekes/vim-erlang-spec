vim-erlang-spec
===============

Generate specifications for your Erlang functions.

When you are inside the function, call `:ErlangSpec` and this script will
produce specification for it. It won't fill in the argument types for you,
though.

Installation
============

- [Pathogen][1] `git clone https://github.com/akalyaev/vim-erlang-spec ~/.vim/bundle/vim-erlang-spec`
- [Vundle][2] `Bundle 'akalyaev/vim-erlang-spec'`
- [NeoBundle][3] `NeoBundle 'akalyaev/vim-erlang-spec'`

Add a mapping to your ~/.vimrc (change the key to suit your taste):

    nnoremap <leader>s :ErlangSpec<CR>

[1]: https://github.com/tpope/vim-pathogen
[2]: https://github.com/gmarik/vundle
[3]: https://github.com/Shougo/neobundle.vim
