let g:lightline = {
            \ 'colorscheme': 'gruvbox',
            \ 'active': {
            \   'left': [
            \             ['mode', 'paste'],
            \             ['readonly', 'activeFilename', 'gitDiffInfo', 'charvaluehex', 'modified'],
            \             ['currentSymbol']
            \           ],
            \   'right': [
            \              ['linter_errors', 'linter_warnings', 'lineinfo'],
            \              ['percent'],
            \              ['filetype']
            \            ]
            \ },
            \ 'component': {
            \   'charvaluehex': '0x%B',
            \ },
            \ 'component_expand': {
            \   'activeFilename': 'UserFuncGetFileName',
            \   'gitDiffInfo': 'UserFuncGitDiffInfo',
            \   'currentSymbol': 'UserFuncCurrentSymbol',
            \   'linter_warnings': 'UserFuncGetLinterWarnings',
            \   'linter_errors': 'UserFuncGetLinterErrors',
            \ },
            \ 'component_type': {
            \   'linter_warnings': 'warning',
            \   'linter_errors': 'error'
            \ },
            \ }

augroup Lightline_user
    autocmd!
    autocmd User ALELint call s:update_light_line()
    autocmd User CocDiagnosticChange call s:update_light_line()
    autocmd User GitPDiffAndBlameUpdate call s:update_light_line()
augroup END

function! s:update_light_line() abort
    if get(s:, 'is_active', v:true)
        try
            call lightline#update()
        catch /.*/
        endtry
    endif
endfunction

function! s:deactive() abort
    let s:is_active = v:false
endfunction

function! s:active() abort
    let s:is_active = v:true
endfunction

function! UserFuncGitDiffInfo() abort
  let l:info = ''
  if exists('b:gitp_diff_state')
    let l:info = '%<%{"+' . b:gitp_diff_state['add'] . ' -' . b:gitp_diff_state['delete'] . ' ~' . b:gitp_diff_state['modify'] . '"}'
  endif
  return l:info
endfunction

function! UserFuncCurrentSymbol() abort
  return get(b:, 'coc_current_function', '')
endfunction

augroup UserMatchupOffscreen
  autocmd!
  autocmd User MatchupOffscreenEnter call s:deactive()
  autocmd User MatchupOffscreenLeave call s:active()
augroup END
