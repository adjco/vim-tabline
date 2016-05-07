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

"===  FUNCTION  ================================================================
"          NAME:  VimTabLabel     {{{1
"   DESCRIPTION:  Get the buffer name of the active window in the current tab.
"                 The buffer name is the name of the file it contains. The
"                 extension is removed fos use as the tab name. If there is no
"                 current buffer name, it is set to "[No-Name].
"    PARAMETERS:  n - Current tab number
"       RETURNS:  Tab name or [No-Name] if there is no buffer name.
"===============================================================================
function! VimTabLabel(n)
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	let tablabel = bufname(buflist[winnr - 1])
	if tablabel == ''
		let tablabel = '[No-Name]'
	else
		let tablabellen = strridx(tablabel, '.')
		if tablabellen > 0
			let tablabel = tablabel[0:tablabellen - 1]
		endif
	endif
	return tablabel
endfunction

"===  FUNCTION  ================================================================
"          NAME:  VimBufLabels     {{{1
"   DESCRIPTION:
"    PARAMETERS:  n - Current tab number
"       RETURNS:  A string containing the buffer names
"===============================================================================
function! VimBufLabels(n)
	let s:bufnames = {}
	let s .= '%#Buf#'
	let s .= 'Buffers'
	for tabnr in range( 1, tabpagenr('$') )
		for bufnr in tabpagebuflist( tabnr )
			let bufname = bufname( bufnr )
			if s:verbose =~ 'full_path'
				let bufname = fnamemodify( bufname, ':p' )
			else
				let bufname = fnamemodify( bufname, ':t' )
			endif
			if bufname == ''
				let bufname = '[No Name]'
			endif
			let s:bufnames[ bufnr ] = bufname
		endfor
	endfor
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
	let s = ''
	let s .= '%='
	for i in range(tabpagenr('$'))
		if i + 1 == tabpagenr()
			let s .= '%#TabSel#'
		else
			let s .= '%#Tab#'
		endif
		let s .= '%' . (i + 1) . 'T'
		let s .= (i + 1) . ':%{VimTabLabel(' . (i + 1) . ')} '
	endfor
	if tabpagenr('$') > 1
		let s .= '%#TabClose#%999X ╳ '
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
	hi! TabSel    term=BOLD    ctermfg=black    ctermbg=green
	hi! TabRev    term=BOLD    ctermfg=magenta  ctermbg=blue
	hi! TabFill   term=NONE    ctermfg=black    ctermbg=black
	hi! TabEnd    term=NONE    ctermfg=white    ctermbg=black
	hi! TabClose  term=BOLD    ctermfg=yellow   ctermbg=red
	hi! Sep       term=NONE    ctermfg=black    ctermbg=white
	hi! SepRev    term=REVERSE ctermfg=black    ctermbg=white
	hi! Buf       term=BOLD    ctermfg=yellow   ctermbg=darkgreen
	hi! BufSel    term=BOLD    ctermfg=magenta  ctermbg=blue
	hi! BufRev    term=BOLD    ctermfg=magenta  ctermbg=blue
endfunction

call VimTabSet_hl()
set tabline=%!VimTabLine()
"
" vim: fdm=marker foldenable ts=4 sw=4
