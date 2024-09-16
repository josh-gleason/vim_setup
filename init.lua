-- Basic settings
vim.cmd('syntax on')  -- Turn syntax highlighting on
vim.o.backspace = 'indent,eol,start'  -- Make backspace work as expected
vim.o.encoding = 'utf-8'  -- Set UTF-8 encoding
vim.o.fileencoding = 'utf-8'  -- Set UTF-8 encoding for file
vim.o.number = true  -- Turn line numbers on
vim.o.showmatch = true  -- Highlight matching braces
vim.o.mouse = 'a'  -- Set mouse mode on
vim.o.scrolloff = 5  -- Show context around the cursor
vim.o.visualbell = false  -- Turn off screen flashing
vim.o.hlsearch = true  -- Highlight searches
vim.o.ruler = true  -- Show cursor position
vim.o.showcmd = true  -- Display incomplete commands
vim.o.wildmenu = true  -- Display completion matches in a status line
vim.o.laststatus = 2  -- Always show status line
vim.o.smartindent = true  -- Use smartindent
vim.o.timeout = true  -- Enable timeout for escape sequences
vim.o.timeoutlen = 1000  -- Lower the timeout length to 1000ms
vim.o.textwidth = 0  -- Don't autowrap code
vim.o.wrapmargin = 0  -- Set wrap margin
vim.o.clipboard = 'unnamedplus'  -- Use system clipboard
vim.o.tabstop = 4  -- Set tab width
vim.o.shiftwidth = 4  -- Set shift width for indent
vim.o.expandtab = true  -- Convert tabs to spaces

-- FileType specific settings
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'make',
    command = 'setlocal noexpandtab shiftwidth=8 softtabstop=0 tabstop=8'
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    command = 'setlocal equalprg=autopep8\\ -'
})

vim.g.python_highlight_all = 1

-- Key mappings
vim.api.nvim_set_keymap('n', '<Space>', ':nohlsearch<Bar>:echo<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-Left>', ':tabprevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-Right>', ':tabnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Left>', ':bprevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Right>', ':bnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-d>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '==', ':ALEFix<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('x', 'p', '"_dP', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'p', '"_dP', { noremap = true, silent = true })

-- Insert mode mappings

-- remove annoying behavior where indentation removed when you enter a #
vim.api.nvim_set_keymap('i', '#', 'X␈#', { noremap = true, silent = true })

-- coc.nvim specific mapping
-- refresh autocomplete with Ctrl+Space
vim.api.nvim_set_keymap('i', '<C-Space>', 'coc#refresh()', { noremap = true, silent = true, expr = true })
-- select autocomplete option with Enter
vim.api.nvim_set_keymap('i', '<CR>', [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], { noremap = true, silent = true, expr = true })
vim.api.nvim_set_keymap('n', '<leader>d', '<Plug>(coc-definition)', {silent = true})

-- in terminal use <Esc> to leave insert mode
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true } )

-- Custom command
vim.api.nvim_create_user_command('DiffOrig', 'vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis', {})

vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use { 'williamboman/mason.nvim' }
  use { 'neoclide/coc.nvim', branch='release' }
  use 'dense-analysis/ale'
  use 'preservim/nerdcommenter'
  use { 'nvim-tree/nvim-tree.lua', requires = { 'nvim-tree/nvim-web-devicons', opt = true } }
  use { 'nvim-lualine/lualine.nvim', requires = { 'nvim-tree/nvim-web-devicons', opt = true } }
  use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}
  use 'tpope/vim-fugitive'
  use 'flazz/vim-colorschemes'
  use 'kien/rainbow_parentheses.vim'
  use 'cespare/vim-toml'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
        local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
        ts_update()
    end,
  }
  use {
      "ViViDboarder/wombat.nvim",
      requires = "rktjmp/lush.nvim",
  }
end)

-- mason
require("mason").setup()

-- bufferline
require("bufferline").setup{}

-- treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "cpp", "rust", "python", "lua", "vim", "vimdoc", "toml", "json", "yaml" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    disable = { },
    additional_vim_regex_highlighting = false,
  },
}

-- Color and basic settings
vim.cmd[[colorscheme wombat]]

-- ALE Settings
vim.g.ale_virtualtext_cursor = 0

vim.g.ale_fixers = {
    ['*'] = {'remove_trailing_lines', 'trim_whitespace'},
    ['python'] = {'autopep8'},
    ['rust'] = {'rustfmt'},
}

-- NERDCommenter
vim.g.NERDSpaceDelims = 0
vim.g.NERDDefaultAlign = 'left'
vim.g.NERDCommentEmptyLines = 1

-- Nvim-Tree

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- lualine
require('lualine').setup()

-- setup with some options
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

-- Rainbow Parenthesis
vim.g.rbpt_loadcmd_toggle = 1
vim.g.rbpt_max = 18
vim.g.rbpt_colorpairs = {
    {'yellow', '#9eb8ff'},
    {'red',    '#ff3083'},
    {'gray',   '#c654ff'},
    {'green',  '#ff8921'},
    {'brown',  '#dbffa6'},
    {'blue',   '#ff91f0'},
    {'magenta','#ffcfa6'},
    {'cyan',   '#54ff8d'},
    {'yellow', '#9eb8ff'},
    {'red',    '#ff3083'},
    {'gray',   '#c654ff'},
    {'green',  '#ff8921'},
    {'brown',  '#dbffa6'},
    {'blue',   '#ff91f0'},
    {'magenta','#ffcfa6'},
    {'cyan',   '#54ff8d'},
    {'yellow', '#9eb8ff'},
    {'red',    '#ff3083'}
}

-- Autocommands for rainbow parentheses
vim.api.nvim_create_autocmd('VimEnter', {
    pattern = '*',
    command = 'RainbowParenthesesActivate'
})
vim.api.nvim_create_autocmd('Syntax', {
    pattern = '*',
    command = 'RainbowParenthesesLoadRound'
})
vim.api.nvim_create_autocmd('Syntax', {
    pattern = '*',
    command = 'RainbowParenthesesLoadSquare'
})
vim.api.nvim_create_autocmd('VimEnter', {
    pattern = '*',
    command = 'RainbowParenthesesLoadBraces'
})

-- Resume from previous line
local group = vim.api.nvim_create_augroup("jump_last_position", { clear = true })
vim.api.nvim_create_autocmd(
  "BufReadPost",
  {callback = function()
      local row, col = unpack(vim.api.nvim_buf_get_mark(0, "\""))
      if {row, col} ~= {0, 0} then
        vim.api.nvim_win_set_cursor(0, {row, 0})
      end
    end,
  group = group
  }
)
