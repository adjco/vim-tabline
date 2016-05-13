"===============================================================================
"
"        File:  vim-tabline.vim
"
"  Description:  Vim support     (VIM Version 7.0+)
"
"  VIM Version:  7.0+
"
"       Author:  Alan D. Ogden (alan@aogden.me.uk)
"
"      Version:  1.0
"      Created:  May, 2016
"  MIT License:  Copyright (c) 2016 Alan D. Ogden
"                Permission is hereby granted, free of charge, to any person
"                obtaining a copy of this software and associated documentation
"                files (the "Software"), to deal in the Software without
"                restriction, including without limitation the rights to use,
"                copy, modify, merge, publish, distribute, sublicense, and/or
"                sell copies of the Software, and to permit persons to whom the
"                Software is furnished to do so, subject to the following
"                conditions:
"
"                The above copyright notice and this permission notice shall be
"                included in all copies or substantial portions of the Software.
"
"                THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
"                EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
"                OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
"                NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
"                HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
"                WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
"                FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
"                OTHER DEALINGS IN THE SOFTWARE.
"===============================================================================
"
if has("gui_running")
	finish
endif
"if !exists("s:tablineset")
"	let s:tablineset = [0]
"endif
if !exists("g:tabline_buffer_full_path")
	let g:tabline_buffer_full_path = 0
endif
if !exists("g:tabline_use_powerline_fonts")
	let g:tabline_use_powerline_fonts = 1
endif
if exists('g:airline_symbols')
	let g:tabline_left_sep = ''
	let g:tabline_left_alt_sep = ''
	let g:tabline_right_sep = ''
	let g:tabline_right_alt_sep = ''
else
	let g:tabline_left_alt_sep = '|'
	let g:tabline_left_sep = ' '
	let g:tabline_right_alt_sep = '|'
	let g:tabline_right_sep = ' '
endif

"===  FUNCTION  ================================================================
"          NAME:  VimTabLabel     {{{1
"   DESCRIPTION:  Get the buffer name of the active window in the current tab.
"                 The buffer name is the name of the file it contains. The
"                 extension is removed fos use as the tab name. If there is no
"                 current buffer name, it is set to "[No-Name].
"    PARAMETERS:  n - Current tab number
"       RETURNS:    - Tab name or [No-Name] if there is no buffer name.
"===============================================================================
function! VimTabLabel(n)
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	let tablabel = bufname(buflist[winnr - 1])
	if tablabel == ''
		let tablabel = '[No-Name]'
	else
		let tablabel = fnamemodify( tablabel, ':t:r' )
	endif
	return tablabel
endfunction

"===  FUNCTION  ================================================================
"          NAME:  VimBufLabels     {{{1
"   DESCRIPTION:
"    PARAMETERS:  n - Current buffer number
"       RETURNS:    - Buffer name or [No-Name] if there is no buffer name.
"===============================================================================
function! VimBufLabel(n)
	let buflabel = bufname( a:n )
	if g:tabline_buffer_full_path
		let buflabel = fnamemodify( buflabel, ':~' )
	else
		let buflabel = fnamemodify( buflabel, ':t' )
	endif
	if buflabel == ''
		let buflabel = '[No Name]'
	endif
	return buflabel
endfunction

"===  FUNCTION  ================================================================
"          NAME:  VimTabLine     {{{1
"   DESCRIPTION:  The main function that constructs the tabline, including
"                 highlighting. First construct a list of the active buffers in
"                 the curent tab. Then get a list of all tabs. The buffers are
"                 aligned left and the tabs are aligned right. The tabs can be
"                 selected with the mouse, but not the buffers.
"    PARAMETERS:  - None
"       RETURNS:  - Nothing
"===============================================================================
function! VimTabLine()
	let bufferlist = tabpagebuflist(tabpagenr())
	let numBuffers = len(bufferlist)
	let firstBuffer = bufferlist[0]
	let lastBuffer = bufferlist[numBuffers - 1]
	let s = '%#BufFill#Buffers'
	for bufnr in bufferlist
		if bufnr == firstBuffer             " seperator at start of buffer list
			if bufnr == bufnr('%')
				let s .= '%#BufSepA#' . g:tabline_left_sep . '%#BufSel#'
			else
				let s .= '%#BufSepB#' . g:tabline_left_sep . '%#Buf#'
			endif
		endif
		let bufPos = index(bufferlist, bufnr)
		if bufPos > 0                         " seperator within buffer list
			let activeBufPos = index(bufferlist, bufnr('%'))
			if bufPos <= activeBufPos - 1     " multiple buffers before active
				let s .= ' ' . g:tabline_left_alt_sep . ' '
			elseif bufPos - 1 == activeBufPos " previous buffer active
				let s .= '%#Buf#' . g:tabline_left_sep . '%#Buf#'
			elseif bufPos == activeBufPos     " this buffer active
				let s .= '%#BufSel#' . g:tabline_left_sep . '%#BufSel#'
			elseif bufPos + 1 == activeBufPos " next buffer active
				let s .= '%#Buf#' . g:tabline_left_sep . '%#Buf#'
			else                              " multiple buffers after active
				let s .= ' ' . g:tabline_left_alt_sep . ' '
			endif
		endif
		let s .= bufnr . ':%{VimBufLabel(' . bufnr . ')}'
		if bufnr == lastBuffer                " seperator at end of buffer list
			if bufnr == bufnr('%')
				let s .= '%#BufSepC#' . g:tabline_left_sep . '%#BufFill#'
			else
				let s .= '%#BufSepD#' . g:tabline_left_sep . '%#BufFill#'
			endif
		endif
	endfor
	let s .= '%='
	for i in range(tabpagenr('$'))
		if i == 0                                " first tab
			if i + 1 == tabpagenr()
				let s .= '%#TabSepA#' . g:tabline_right_sep . '%#TabSel#'
			else
				let s .= '%#TabSepB#' . g:tabline_right_sep . '%#Tab#'
			endif
		endif
		let thisTab = i + 1
		if thisTab > 1                      " seperator within tab list
			if thisTab <= tabpagenr() - 1    " multiple tabs before active
				let s .= ' ' . g:tabline_right_alt_sep . ' '
			elseif thisTab - 1 == tabpagenr() " previous tab active
				let s .= '%#TabSel#' . g:tabline_right_sep . '%#Tab#'
			elseif thisTab == tabpagenr()     " this tab active
				let s .= '%#Tab#' . g:tabline_right_sep . '%#TabSel#'
			elseif thisTab + 1 == tabpagenr() " next tab active
				let s .= '%#TabSel#' . g:tabline_right_sep . '%#Tab#'
			else                              " multiple tabs after active
				let s .= ' ' . g:tabline_right_alt_sep . ' '
			endif
		endif
		let s .= '%' . (i + 1) . 'T'
		let s .= (i + 1) . ':%{VimTabLabel(' . (i + 1) . ')}'
	endfor
	if tabpagenr('$') > 1
		if i + 1 == tabpagenr()                  " last tab
			let s .= '%#TabSepC#' . g:tabline_right_sep . '%#Close#%999XClose'
		else
			let s .= '%#TabSepD#' . g:tabline_right_sep . '%#Close#%999XClose'
		endif
	endif
	return s
endfunction

"===  FUNCTION  ================================================================
"          NAME:  VimTabSet_hl     {{{1
"   DESCRIPTION:  Set the colours for the tabline
"    PARAMETERS:  - None
"       RETURNS:  - Nothing
"===============================================================================
function! VimTabSet_hl()
	hi! Tab       term=BOLD    ctermfg=green    ctermbg=darkred
	hi! TabSel    term=BOLD    ctermfg=darkred  ctermbg=green
	hi! TabSepA   term=NONE    ctermfg=green    ctermbg=black
	hi! TabSepB   term=NONE    ctermfg=darkred  ctermbg=black
	hi! TabSepC   term=BOLD    ctermfg=black    ctermbg=green
	hi! TabSepD   term=BOLD    ctermfg=black    ctermbg=darkred
	hi! Close     term=NONE    ctermfg=green    ctermbg=black
	hi! Buf       term=BOLD    ctermfg=yellow   ctermbg=darkred
	hi! BufSel    term=BOLD    ctermfg=darkred  ctermbg=yellow
	hi! BufFill   term=NONE    ctermfg=yellow   ctermbg=black
	hi! BufSepA   term=NONE    ctermfg=black    ctermbg=yellow
	hi! BufSepB   term=NONE    ctermfg=black    ctermbg=darkred
	hi! BufSepC   term=NONE    ctermfg=yellow   ctermbg=black
	hi! BufSepD   term=NONE    ctermfg=darkred  ctermbg=black
endfunction

call VimTabSet_hl()
set tabline=%!VimTabLine()
"
" vim: fdm=marker foldenable ts=4 sw=4
