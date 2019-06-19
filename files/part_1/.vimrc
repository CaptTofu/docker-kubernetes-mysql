 :highlight ExtraWhitespace ctermbg=red guibg=red
" The following alternative may be less obtrusive.
:highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
" Try the following if your GUI uses a dark background.
:highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen

" However, be aware that future colorscheme commands may clear all user-defined highlight groups. Using,

:autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

" before the first colorscheme command will ensure that the highlight group gets created and is not cleared by future colorscheme commands. :help :colorscheme

" Once this highlight group is created, it can be associated with matching text as in the following examples.

" Show trailing whitespace:
:match ExtraWhitespace /\s\+$/

" Show trailing whitespace and spaces before a tab:
:match ExtraWhitespace /\s\+$\| \+\ze\t/

" Show tabs that are not at the start of a line:
:match ExtraWhitespace /[^\t]\zs\t\+/

" Show spaces used for indenting (so you use only tabs for indenting).
:match ExtraWhitespace /^\t*\zs \+/

" Alternatively, the following pattern will match trailing whitespace, except when typing at the end of a line.

:match ExtraWhitespace /\s\+\%#\@<!$/
