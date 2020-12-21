" " " starting over from scratch
" " " || " originally sourced from
" " " || " https://github.com/dakom/dotfiles/blob/80e6d9efeeeb3af56a31478f55f476e2042253f2/.config/nvim/config/coc.vim
" " " || "
" " " || " NOTE: in addition to the coc.vim config here, you need to install additional
" " " || " coc extensions:
" " " || " :CocInstall coc-rls
" " " || "
" " " || " and access the cocconfig to enable rust format on save (format selected does
" " " || " not work)
" " " || " :CocConfig
" " " || " " add :CocInstall coc-rls
" " " || " "coc.preferences.formatOnSaveFiletypes": ["rust"]
" " " || 
" " " || 
" " " || " search for <OPTOUT> ... </OPTOUT>
" " " || " for parts of the config not yet included from the source
" " " || " if hidden not set, TextEdit might fail.
" " " || set hidden
" " " || 
" " " || " Better display for messages
" " " || set cmdheight=1
" " " || 
" " " || " Smaller updatetime for CursorHold & CursorHoldI
" " " || set updatetime=300
" " " || " signcolumn: auto (only when there is an alert), yes (always open), no (never)
" " " || set signcolumn=auto
" " " || 
" " " || " <OPTOUT>
" " " || " 
" " " || " " Use tab for trigger completion with characters ahead and navigate.
" " " || " " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
" " " || " inoremap <silent><expr> <TAB>
" " " || "       \ pumvisible() ? "\<C-n>" :
" " " || "       \ <SID>check_back_space() ? "\<TAB>" :
" " " || "       \ coc#refresh()
" " " || " inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" " " || " 
" " " || " function! s:check_back_space() abort
" " " || "   let col = col('.') - 1
" " " || "   return !col || getline('.')[col - 1]  =~# '\s'
" " " || " endfunction
" " " || " 
" " " || " " Use <c-space> for trigger completion.
" " " || " inoremap <silent><expr> <c-space> coc#refresh()
" " " || " 
" " " || " " Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" " " || " " Coc only does snippet and additional edit on confirm.
" " " || " inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" " " || " 
" " " || " </OPTOUT>
" " " || " use up/down directions and <leader>i for navigating diagnostic
" " " || nmap <silent> <Leader>j <Plug>(coc-diagnostic-next)
" " " || nmap <silent> <Leader>k <Plug>(coc-diagnostic-prev)
" " " || nmap <silent> <Leader>i <Plug>(coc-diagnostic-info)
" " " || 
" " " || " Remap keys for gotos
" " " || nmap <silent> gd <Plug>(coc-definition)
" " " || nmap <silent> gy <Plug>(coc-type-definition)
" " " || nmap <silent> gi <Plug>(coc-implementation)
" " " || nmap <silent> gr <Plug>(coc-references)
" " " || 
" " " || " show documentation in preview window 
" " " || " nnoremap <silent> K :call <SID>show_documentation()<CR>
" " " || nmap <silent> <Leader>h :call <SID>show_documentation()<CR>
" " " || 
" " " || function! s:show_documentation()
" " " ||   if &filetype == 'vim'
" " " ||     execute 'h '.expand('<cword>')
" " " ||   else
" " " ||     call CocAction('doHover')
" " " ||   endif
" " " || endfunction
" " " || 
" " " || " NOTE: THIS IS BROKEN AND I DO NOT KNOW WHY
" " " || " Remap for format selected region
" " " || vmap <leader>f  <Plug>(coc-format-selected)
" " " || nmap <leader>f  <Plug>(coc-format-selected)
" " " || 
" " " || " Setup formatexpr specified filetype(s).
" " " || augroup mycocgroup
" " " ||   autocmd!
" " " ||   autocmd FileType typescript,json,rust setl formatexpr=CocAction('formatSelected')
" " " || augroup end
" " " || 
" " " || " <OPTOUT>
" " " || " " conradnote: i don't want CursorHold because it's visual noise as you're typing
" " " || " " conradnote: maybe it will be good when i get fluent at what coc.vim provides
" " " || " " conradnote: but for now Flow is sacred.
" " " || " " Highlight symbol under cursor on CursorHold
" " " || " autocmd CursorHold * silent call CocActionAsync('highlight')
" " " || " 
" " " || " " Remap for rename current word
" " " || " nmap <leader>rn <Plug>(coc-rename)
" " " || " 
" " " || " 
" " " || " 
" " " || " " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
" " " || " vmap <leader>a  <Plug>(coc-codeaction-selected)
" " " || " nmap <leader>a  <Plug>(coc-codeaction-selected)
" " " || " 
" " " || " " Remap for do codeAction of current line
" " " || " nmap <leader>ac  <Plug>(coc-codeaction)
" " " || " 
" " " || " " Use `:Format` for format current buffer
" " " || " command! -nargs=0 Format :call CocAction('format')
" " " || " 
" " " || " " Use `:Fold` for fold current buffer
" " " || " command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" " " || " 
" " " || " " conradnote: I don't have lightline installed... yet?
" " " || " " Add diagnostic info for https://github.com/itchyny/lightline.vim
" " " || " let g:lightline = {
" " " || "       \ 'colorscheme': 'wombat',
" " " || "       \ 'active': {
" " " || "       \   'left': [ [ 'mode', 'paste' ],
" " " || "       \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
" " " || "       \ },
" " " || "       \ 'component_function': {
" " " || "       \   'cocstatus': 'coc#status'
" " " || "       \ },
" " " || "       \ }
" " " || " 
" " " || " 
" " " || " 
" " " || " " conradnote: I don't have denite yet
" " " || " " Shortcuts for denite interface
" " " || " " Show extension list
" " " || " nnoremap <silent> <space>e  :<C-u>Denite coc-extension<cr>
" " " || " " Show symbols of current buffer
" " " || " nnoremap <silent> <space>o  :<C-u>Denite coc-symbols<cr>
" " " || " " Search symbols of current workspace
" " " || " nnoremap <silent> <space>t  :<C-u>Denite coc-workspace<cr>
" " " || " " Show diagnostics of current workspace
" " " || " nnoremap <silent> <space>a  :<C-u>Denite coc-diagnostic<cr>
" " " || " " Show available commands
" " " || " nnoremap <silent> <space>c  :<C-u>Denite coc-command<cr>
" " " || " " Show available services
" " " || " nnoremap <silent> <space>s  :<C-u>Denite coc-service<cr>
" " " || " " Show links of current buffer
" " " || " nnoremap <silent> <space>l  :<C-u>Denite coc-link<cr>
" " " || " 
" " " || " "Status line
" " " || " function! StatusDiagnostic() abort
" " " || "   let info = get(b:, 'coc_diagnostic_info', {})
" " " || "   if empty(info) | return '' | endif
" " " || "   let msgs = []
" " " || "   if get(info, 'error', 0)
" " " || "     call add(msgs, 'E' . info['error'])
" " " || "   endif
" " " || "   if get(info, 'warning', 0)
" " " || "     call add(msgs, 'W' . info['warning'])
" " " || "   endif
" " " || "   return join(msgs, ' '). ' ' . get(g:, 'coc_status', '')
" " " || " endfunction
" " " || " 
" " " || " " Airline statusline integration
" " " || " let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
" " " || " let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'
" " " || " " let g:airline_section_error = '%{airline#util#wrap(StatusDiagnostic(),0)}'
" " " || " </OPTOUT>

""""""""""""""""""""""""""
"""""" CoC Config! """""""
""""""""""""""""""""""""""

" current additional plugins that need to be installed
" :CocInstall coc-rust-analyzer
" :CocInstall coc-clangd


"" set up all the mappings

" navigation mappings
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references-used)

" inspect
nmap <silent> <leader>i :call CocAction("doHover")<CR>

" ctrl space to trigger completion menu
inoremap <silent><expr> <c-space> coc#refresh()

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
" nmap <leader>ac  <Plug>(coc-codeaction)

" Use `:Format` for format current buffer
command! -nargs=0 Format :call CocAction('format')
autocmd FileType rust nmap <leader>f  :Format<CR>


" file specific mappings
" doHover plugin mapping does not work??
"autocmd FileType c,cpp nmap <silent> K <Plug>(coc-action-doHover)
autocmd FileType c,cpp nmap <silent> K :call CocAction("doHover")<CR>
" like shift-K for doc but... different? i dunno.
" this should potentially be invoked during insertmode as you're typing and
" get confused but whatever
autocmd FileType c,cpp nmap <silent> <leader>k :call CocAction("showSignatureHelp")<CR>


" return to the list results, going to the next item
nmap <silent> gl :CocListResume<CR>

nmap <silent> <C-j> :silent CocNext<CR>
nmap <silent> <C-k> :silent CocPrev<CR>
" because the response from the above commands comes back as an async request,
" and because coc.nvim hard-codes this behavior of echoing the line we are
" navigating to into the cmdline, long-lined files will cause nvim's UI to
" lock up, informing me to "hit enter to continue" when I am trying to scroll
" through results.  what a garbage idea.
" There not, to my knowledge, any way to prevent this from happening!
" - No amount of wrapping the commands in layers of calls to `silent` will work,
" the CocNext/Prev commands themselves are not doing the echo
" - No amount of suffixing the mapping with additional <CR> or <ESC> will do it,
" a mapping executes much faster than the response from the coc server
"
" Either we increase the size of cmdline permanently to accomodate this
" randomly-occurring event, or we disable vim from being able to display the
" results of echo. what a worthless casserole of bad ideas stapled and
" ducttaped to the side of a rusty tractor this is! It's enough to make you
" want to switch to emacs.

" the advice to tweak 'shortmess' is not able to truncate :echo messages, so
" we just have to permanently increase the cmdline height. 

" only make vim slightly worse for cpp
autocmd FileType c,cpp set cmdheight=2
