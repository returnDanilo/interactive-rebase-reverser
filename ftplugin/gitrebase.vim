" Only load this plugin once.
if exists('g:interactive_rebase_reverser')
  finish
endif
let g:interactive_rebase_reverser = 1

function! s:Reverse()
  let l:previous_cursor_pos = getpos(".")

  " Delete all comments and emtpy lines.
  silent global/\(^#\)\|\(^$\)/d

  " Reverse all lines.
  global/.*/m0

  " Add message at the top.
  0put ='# Reversed by interactive-rebase-reverser!'
  1put =''

  call setpos('.', l:previous_cursor_pos)
endfunction

" Execute once when this filetype (gitrebase) is loaded.
call s:Reverse()

augroup interactive_rebase_reverser
	autocmd!
	" (un)reverse lines before writing the file so that git sees the commits
	" in the order it expects to see normally.
	autocmd BufWritePre <buffer> call s:Reverse()
	" Just after the file is written, reverse buffer lines again to make sure
	" your buffer always has reversed commits, while the saved file will
	" always have the commit order git is expecting to parse.
	autocmd BufWritePost <buffer> call s:Reverse()
augroup END
