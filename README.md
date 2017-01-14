# vim-erlang-spec

Generate specifications for your Erlang functions.

When you are inside the function, call `:ErlangSpec` and this script will
produce specification for it. It won't fill in the argument types for you,
though.

[![asciicast](https://asciinema.org/a/19604.png)](https://asciinema.org/a/19604?autoplay=1)

## Installation

- [Pathogen][1] `git clone https://github.com/melekes/vim-erlang-spec ~/.vim/bundle/vim-erlang-spec`
- [Vundle][2] `Bundle 'melekes/vim-erlang-spec'`
- [NeoBundle][3] `NeoBundle 'melekes/vim-erlang-spec'`

Add a mapping to your ~/.vimrc (change the key to suit your taste):

    nnoremap <leader>s :ErlangSpec<CR>

## Alternative way - TypEr

If you are new to Erlang, you may be not aware of TypEr - tool, which can be
used to generate type annotations for functions. You can read about it
[here](http://learnyousomeerlang.com/types-or-lack-thereof) or in the "Erlang
Programming" book ("TypEr: Success Types and Type Inference").

## TODO

- [ ] transform record to record type (`#person{name=Name}` => `#person{}`)
- [ ] parse `is_integer` and other simple guards in when block (`f(N, _) when is_integer(N)` => `f(N, _) -> any() when N :: integer()`)

Any comments or suggestions? Feel free to open an issue and we will discuss them.

[1]: https://github.com/tpope/vim-pathogen
[2]: https://github.com/gmarik/vundle
[3]: https://github.com/Shougo/neobundle.vim
