-- plugin management - plugins that nix doesn't handle well
vim.cmd [[packadd packer.nvim]]
require('packer').startup(function(use)
    -- let packer manage itself
    use 'wbthomason/packer.nvim'

    -- quality of life
    use 'junegunn/fzf.vim'
    use 'tpope/vim-surround'
    use 'airblade/vim-rooter'
    use 'direnv/direnv.vim'

    -- completion with CoC
    --use { 
    --    'neoclide/coc.nvim',
    --    branch = 'master',
    --    run = 'yarn install --frozen-lockfile'
    --}

    -- programming languages
    use 'rust-lang/rust.vim'
    use 'LnL7/vim-nix'
    
    -- theming/ricing, so to say
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = false }
    }
    use 'ellisonleao/gruvbox.nvim'
    
end)

-- nice status bar
require('lualine').setup({
    options = { theme = "gruvbox" }
})

-- theming
require("gruvbox").setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = true,
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
})
vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])

-- set a leader key to use with '<leader>' in keybindings (space)
vim.g.mapleader = ' '

-- relative line numbers, but with current line indicating the actual line number
vim.cmd [[
   set relativenumber
   set number
]]

-- settings for neovide
if vim.g.neovide then -- we're 9n a neovide session
    vim.g.neovide_scale_factor = 0.9
    vim.opt.guifont = { "Iosevka Comfy Motion", "h12" }
    vim.g.neovide_transparency = 0.7
    vim.g.neovide_hide_mouse_when_typing = false
end

-- copy and paste from and to system clipboard
vim.keymap.set({'n', 'x'}, '<leader>y', '"+y')
vim.keymap.set({'n', 'x'}, '<leader>p', '"+p')

---- Settings for searching
-- Case sensitive search only if the search term contains uppercase letters
vim.opt.smartcase = true
-- don't highlight previous search results
vim.opt.hlsearch = false
-- search results centered please
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')
vim.keymap.set('n', '*', '*zz')
vim.keymap.set('n', '#', '#zz')
vim.keymap.set('n', 'g*', 'g*zz')

---- Text behaviour on screen
-- tab settings
vim.opt.wrap = true
vim.opt.tabstop = 4
vim.opt.shiftwidth=4
vim.opt.softtabstop=4
vim.opt.expandtab = true

vim.keymap.set('n', '<space>w', '<cmd>write<cr>', {desc = 'Save'})

---- coc.nvim settings
vim.cmd [[
let g:coc_config_home = '~/.files/nvim'
]]
vim.cmd [[
"############################ coc.nvim settings #############################
" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
"
" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
"############################################################################
]]
