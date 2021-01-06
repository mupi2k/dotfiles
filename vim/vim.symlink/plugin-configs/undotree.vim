let g:undotree_WindowLayout = 2
nnoremap <Leader>ud :UndotreeToggle<CR>
nnoremap <F5> :UndotreeToggle<CR>
"===============================================================================
" Unite Keymap Menu Item(s)
"===============================================================================
let g:unite_source_menu_menus.CustomKeyMaps.command_candidates += [['➤ Toggle visual undo tree                                       <Leader>ud', 'UndotreeToggle']]
