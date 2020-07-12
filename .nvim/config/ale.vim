" this keeps segfaulting python3
" let b:ale_linters = {'text': ['proselint']}
let b:ale_linters = {}
let b:ale_linters['rust'] = ['rls']

let b:ale_fixers = {'rust': ['rustfmt']}
let g:ale_fix_on_save = 1
let g:ale_rust_rls_toolchain = 'stable'

" ALE MAPPINGS
noremap <Leader>e :ALEDetail<CR>
noremap <Leader>j <Plug>(ale_next)
noremap <Leader>k <Plug>(ale_previous)
noremap <silent> gd :ALEGoToDefinition<CR>
" mapping conflicts with vimux "resend"
" noremap <silent> <CR> :ALEHOVER<CR>
noremap <silent> K :ALEHover<CR>

