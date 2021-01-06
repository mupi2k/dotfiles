" settings for Tsuquyomi Typescript completion plugin

let g:tsuquyomi_completeion_detail = 1

if &ballooneval
    autocmd FileType typescript setlocal balloonexpr=tsuquyomi#balloonexpr()
else
    autocmd FileType typescript nmap <buffer> <Leader>t : <C-u>echo tsuquyomi#hint()<CR>
endif
