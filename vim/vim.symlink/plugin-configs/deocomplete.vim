"===============================================================================
" Plugin source
"===============================================================================
"'Shougo/deoplete.vim'

"===============================================================================
" Plugin Configurations
"===============================================================================
let g:deoplete#enable_at_startup = 1
let g:jedi#auto_vim_configuration = 0
let g:deoplete#force_overwrite_completefunc = 1
let g:deoplete#auto_completion_start_length = 99
call deoplete#custom#option({
      \ 'smart_case': v:true,
      \ 'enable_refresh_always': v:true,
      \ 'max_list': 30,
      \})
" This refresh may be too heavy weight!!
" let g:deoplete#enable_refresh_always = 1
" let g:deoplete#max_list = 30
" let g:deoplete#min_keyword_length = 1
" let g:deoplete#sources#syntax#min_keyword_length = 1
let g:deoplete#data_directory = $HOME.'/.vim/tmp/deoplete'
" Disable the auto select feature by default
let g:deoplete#enable_auto_select = 0

" To make compatible with jedi
if !exists('g:deoplete#sources#omni#input_patterns')
    let g:deoplete#sources#omni#input_patterns = {}
    let g:deoplete#sources#omni#input_patterns.python='[^. \t]\.\w*'
endif

set completeopt-=preview

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete

"===============================================================================
" Plugin Keymappings
"===============================================================================
" N/A

"===============================================================================
" Unite Keymap Menu Item(s)
"===============================================================================
" N/A
