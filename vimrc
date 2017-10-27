"
" An example for a vimrc file.
"
" Maintainer:	Jayanth Ram (jayanthram1991@gmail.com)
" Last change:	January 12,2015
"
" To use it, copy it to
"
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc
"

" When started as "evim", evim.vim will already have done these settings.

if v:progname =~? "evim"
	finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" start pathogen
execute pathogen#infect()

set number		" set line number
set ruler		" show the cursor position all the time
set history=1000	" keep 1000 lines of command line history
set incsearch		" do incremental searching
set showcmd		" display incomplete commands
set noswapfile		" set no swapfiles
set nobackup		" do not keep a backup file, use versions instead
set autowriteall	" Will save buffer when switching to other
set t_Co=256		" Enable 256 color
"remap <Esc> to jj in insert mode
imap jj <Esc>

"set hlsearch

"Invisible character colors
set listchars=tab:▸\ ,eol:¬
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

" Shortcuts
nmap <leader>l :set list!<CR> 	" shortcut to toggle listchars
nmap <leader>s :update<CR> 	" shortcut to update buffer (save file)

syntax enable		" syntax enable highlight

" solarized theme color settings

let g:solarized_termcolors=256 " important for terminal users
colorscheme solarized
if has('gui_running')
	set background=light
else
	set background=dark
endif

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.	Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
	set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
	syntax on
endif

" Functions

" Preserve cursor position after executing command
function! <SID>Preserve(command)
	" Preparation: save last search, and cursor position.
	let _s=@/
	let l = line(".")
	let c = col(".")
	" Run the command:
	execute a:command
	" Clean up: restore previous search history, and cursor position
	let @/=_s
	call cursor(l, c)
endfunction

" Only do this part when compiled with support for autocommands.

if has("autocmd")

	" Enable file type detection.
	" Use the default filetype settings, so that mail gets 'tw' set to 72,
	" 'cindent' is on in C files, etc.
	" Also load indent files, to automatically do language-dependent indenting.
	filetype plugin indent on

	" Update .vimrc on the fly
	autocmd BufWritePost .vimrc source $MYVIMRC

	" Preseve cursor postion
	" Remove trailing whitespace
	" Remove blank lines
	" Indent code
	autocmd BufWritePre * :call <SID>Preserve("%s/\\s\\+$//e")
	autocmd BufWritePre * :call <SID>Preserve("normal gg=G")

	" Put these in an autocmd group, so that we can delete them easily.
	augroup vimrcEx
		au!
		" For all text files set 'textwidth' to 78 characters.
		autocmd FileType text setlocal textwidth=80
		autocmd BufEnter * highlight OverLength ctermbg=darkgrey guibg=#592929
		autocmd BufEnter * match OverLength /\%80v/

		" When editing a file, always jump to the last known cursor position.
		" Don't do it when the position is invalid or when inside an event handler
		" (happens when dropping a file on gvim).
		" Also don't do it when the mark is in the first line, that is the default
		" position when opening a file.
		autocmd BufReadPost *
					\ if line("'\"") > 1 && line("'\"") <= line("$") |
					\   exe "normal! g`\"" |
					\ endif
	augroup END
else
	set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
				\ | wincmd p | diffthis
endif
