# Vim-Tabline

## Description

A more instructive tabline for vim. On the left are all the buffers active in
the current tab, including the buffer number. On the right there is a list of
all the tabs in the current session. The tab names can be clicked with the
left mouse button to change tabs.

**NOTE** This plugin only works in terminal vim, **NOT** gvim. gvim has it's
own tabline see 'guioptions' and 'guitablabel'.

## Installation
The easiest way to install this plugin is via
[Vundle](https://github.com/gmarik/Vundle.vim). Simply put
`Plugin 'adjco/vim-tabline'`between the `call vundle#begin()` and
`call vundle#end() tags` and then run `PluginInstall` or `PluginUpdate`.
Alternatively, download the
[archive](https://github.com/adjco/vim-tabline/archive/master.zip)
and extract it in your `~/.vim/` directory.

## Usage

If you have [vim-airline](https://github.com/vim-airline/vim-airline) or
[powerline](https://github.com/powerline/powerline) installed with the
powerline fonts, this plugin can use those fonts to blend in. Disable this by
putting this in your `.vimrc`:

    g:vim_tabline_use_powerline_fonts = 0

By default, the buffer name is shortened to just the filename. To use the full
path (relative to your home directory) put this in your `.vimrc`:

    g:vim_tabline_buffer_full_path = 1

##TO DO##
 - A better algorithm for path shortening.
 - Persistent tab labels.
 - Choose which buffer types should be shown.

## MIT License

Copyright (c) 2016 Alan D. Ogden
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sub-license, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
