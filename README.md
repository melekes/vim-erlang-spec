vim-erlang-spec
===============

Generate specifications for your Erlang functions.

When you are inside the function, call `:ErlangSpec` and this script will
produce specification for it. It won't fill in the argument types for you,
though.

[![asciicast](https://asciinema.org/a/19602.png)](https://asciinema.org/a/19602)

Installation
============

- [Pathogen][1] `git clone https://github.com/akalyaev/vim-erlang-spec ~/.vim/bundle/vim-erlang-spec`
- [Vundle][2] `Bundle 'akalyaev/vim-erlang-spec'`
- [NeoBundle][3] `NeoBundle 'akalyaev/vim-erlang-spec'`

Add a mapping to your ~/.vimrc (change the key to suit your taste):

    nnoremap <leader>s :ErlangSpec<CR>

TODO
====

- [ ] transform record to record type (`#person{name=Name}` => `#person{}`)
- [ ] parse `is_integer` and other simple guards in when block (`f(N, _) when is_integer(N)` => `f(N, _) -> any() when N :: integer()`)

Any comments or suggestions? Feel free to open an issue and we will discuss them.

[1]: https://github.com/tpope/vim-pathogen
[2]: https://github.com/gmarik/vundle
[3]: https://github.com/Shougo/neobundle.vim
