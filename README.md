vim-erlang-spec
===============

Generate specifications for your Erlang functions.

When you are inside the function, call `:ErlangSpec` and this script will
produce specification for it. It won't fill in the argument types for you,
though.

Optionally, you can map it to some key. For example:

    nnoremap <leader>s :ErlangSpec<cr>


Installation
============

- [Pathogen][1] `git clone https://github.com/akalyaev/vim-erlang-spec ~/.vim/bundle/vim-erlang-spec`
- [Vundle][2] `Bundle 'akalyaev/vim-erlang-spec'`
- [NeoBundle][3] `NeoBundle 'akalyaev/vim-erlang-spec'`

[1]: https://github.com/tpope/vim-pathogen
[2]: https://github.com/gmarik/vundle
[3]: https://github.com/Shougo/neobundle.vim
