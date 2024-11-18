-- Basic settings
vim.o.backspace = 'indent,eol,start'  -- Make backspace work as expected
vim.o.fileencoding = 'utf-8'  -- Set UTF-8 encoding for file
vim.o.number = true  -- Turn line numbers on
vim.o.showmatch = true  -- Highlight matching braces
vim.o.mouse = "a"  -- Set mouse mode on
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
vim.o.clipboard = "unnamedplus"  -- Use system clipboard
vim.o.tabstop = 4  -- Set tab width
vim.o.shiftwidth = 4  -- Set shift width for indent
vim.o.softtabstop = 4  -- Insert 4 spaces when pressing Tab
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
vim.opt.indentkeys:remove('0#')

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
  use { 'nvim-tree/nvim-tree.lua', requires = { 'nvim-tree/nvim-web-devicons' } }
  use { 'nvim-lualine/lualine.nvim', requires = { 'nvim-tree/nvim-web-devicons' } }
  use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}
  use 'tpope/vim-fugitive'
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

-- mason (conditional to avoid issues in first packer install)
local mason_ok, mason = pcall(require, "mason")
if mason_ok then
    mason.setup()
end

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

-- override italic setting globally then load colorscheme
wombat_lush_colors = require("lush_theme.wombat_lush_colors")
wombat_lush_colors.italic = false

vim.cmd[[colorscheme wombat_classic]]

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
require('lualine').setup {
  options = {
    theme = 'wombat',
    section_separators = '',
    component_separators = '',
  },
}

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
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    -- ...
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
}

-- Reset cursor when leaving neovim (https://github.com/neovim/neovim/issues/4396#issuecomment-1377191592)
vim.api.nvim_create_autocmd('VimLeave', {
  callback = function()
    vim.opt.guicursor = ''
    vim.fn.chansend(vim.v.stderr, '\x1b[ q')
  end
})

-- Resume from previous line
local group = vim.api.nvim_create_augroup("jump_last_position", { clear = true })
vim.api.nvim_create_autocmd(
  "BufReadPost",
  {callback = function()
      local row, col = unpack(vim.api.nvim_buf_get_mark(0, "\""))
      if row > 0 and row <= vim.api.nvim_buf_line_count(0) then
        vim.api.nvim_win_set_cursor(0, {row, col})
      end
    end,
  group = group
  }
)

