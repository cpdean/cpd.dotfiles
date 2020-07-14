
" some sarky comment in the faq about trying the lazy loader but eh
let g:deoplete#enable_at_startup = 1

call deoplete#custom#source('_',
    \ 'matchers', ['matcher_full_fuzzy', 'matcher_length'])

call deoplete#custom#option({
\ 'auto_complete_delay': 200,
\ 'smart_case': v:true,
\ })

" might be cool
"
autocmd FileType vimwiki set completeopt+=noselect
call deoplete#custom#option('omni_patterns', {
\ 'vimwiki': '\[\[',
\ 'ruby': ['[^. *\t]\.\w*', '[a-zA-Z_]\w*::'],
\ 'java': '[^. *\t]\.\w*',
\ 'html': ['<', '</', '<[^>]*\s[[:alnum:]-]*'],
\ 'xhtml': ['<', '</', '<[^>]*\s[[:alnum:]-]*'],
\ 'xml': ['<', '</', '<[^>]*\s[[:alnum:]-]*'],
\})
