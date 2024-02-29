set nu
set spell
syntax on
syntax enable
set nocp

" Maybe a better way to do this
set completeopt=menu,preview,menuone

" This ignores case for all lower-case searches, but if we haved a mixed-case
" search then this will do a case-sensitive search.
set ignorecase
set smartcase
" Quality of life improvement for keyword completion.
set infercase

" Maybe I can turn this on when I get muscle memory for turning it off
" or there's some plug-in that can do that.
set nohlsearch

" Turn off C-style indenting, smart indenting
set nocindent
" TODO: I don't think I need this, it's the default
set indentexpr=""
set smartindent

" Mouse mode acitve in all modes.
set mouse=a

" This changes `pwd` per file.
set autochdir

" Obviously we use spaces instead of tabs.
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
" Preserve indentation of current line when tabbing.
set preserveindent
" Allow backspacing over auto indented lines, line breaks, and the start of
" insert. (TODO I think this is the default?)
set backspace=indent,eol,start
" Only one space when joining lines separated by punctuation.
set nojs

" Visualize folds in the gutter. 4 might be a bit much, but it works okay.
set foldcolumn=1
" Without this, when we make a movement into a folded block, it'll enter and
" open the fold. Instead, we want to just skip over the folded block.
set foldopen-=block

" This basically is saying, if there's a comment, then don't force it to wrap
" automatically, let it run long, and `gq` will fix it.
set formatoptions=q

" The default is 78 for some reason, set it to 79.
set textwidth=79
" Add a colored column at 80.
set colorcolumn=+1

let g:editorconfig = v:true

" Turn on loading the plug-in files for specific file types.
filetype plugin on

" Wildcard completion mode.
set wildmode=longest,list,full
set wildmenu

" Save views persistently and automatically.
set viewoptions-=options
augroup remember_folds
    autocmd!
    autocmd BufWinLeave *.* if &ft !=# 'help' | mkview | endif
    autocmd BufWinEnter *.* if &ft !=# 'help' | silent! loadview | endif
augroup END

" Color.
"colors zenburn
"colors gruvbox
set tgc

command! -bang -nargs=* PRg
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, fzf#vim#with_preview({'dir': system('git rev-parse --show-toplevel 2> /dev/null')[:-2]}), <bang>0)

" Highlight extra whitespace. Note: must be after `colors`.
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

" Keeps signcolumn open, less jarring.
set signcolumn=yes

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maps
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let mapleader=" "

" Finding next braces.
map <Leader>} /\{<CR>%
map <Leader>] /\[<CR>%
map <Leader>) /\(<CR>%
map <Leader>{ /\{<CR>
map <Leader>[ /\[<CR>
map <Leader>( /\(<CR>

" Quick shortcuts for putting from 0 register.
map <Leader>P "0P
map <Leader>p "0p

" System clipboard. Note: Usually I use the "+ register directly, but on this
" Chromebook, I have to interface with system commands, unfortunately. This
" involves special handling when in visual mode since I want to copy selected
" text and paste overwriting the selected text.
" vmap <Leader>c "+y
" map <Leader>v "+p
map <Leader>c :silent %y+<CR>:silent call system("wl-copy", @+)<CR>
vmap <Leader>c "+y:silent call system("wl-copy", @+)<CR>
map <Leader>v :r !wl-paste<CR>
vmap <Leader>v :<CR>:silent let @+=system("wl-paste")<CR>gv"+p

" Add blank line above/below without leaving command mode.
map <Leader>o mzo<Esc>`z
map <Leader>O mzO<Esc>`z

" Add semicolon to the end of the line. TODO: I don't use this much, reevaluate
" late.
map <Leader>; A;<Esc>

" Formats the current paragraph.
map <Leader>gq gwap

" Collapse a C-style comment block.
map <Leader>zfc [*V]*zf

" Make the current pane big.
map <Leader>M :resize<CR>:vert resize<CR>
" Make the current pane 89 wide.
map <Leader>> :vert res 89<CR>

" Use the Q macro slot.
map Q @q

" Search in very special mode by default.
noremap / /\v
noremap ? ?\v

" Selects the last edited text.
map <Leader>gv `[v`]

" Open terminal.
autocmd TermOpen * setlocal nospell
autocmd TermOpen * setlocal nonu
map <Leader>T :new<CR>:terminal<CR><C-W>H
" TODO this was to reopen a hidden terminal, but it doesn't seem great.
" map <Leader>t <C-W>v<C-W>:buf bash<CR>i
tnoremap <C-W>N <C-\><C-N>
tnoremap <C-W>h <C-\><C-N><C-W>h
tnoremap <C-W>j <C-\><C-N><C-W>j
tnoremap <C-W>k <C-\><C-N><C-W>k
tnoremap <C-W>l <C-\><C-N><C-W>l

" Neovim has some weird default mappings for these which are really bad.
unmap *
unmap #

map <Leader>=b :Format<CR>
map <Leader>gd :lua vim.lsp.buf.definition()<CR>

" FZF
map <Leader>/ :PRg<CR>
map <Leader>f :GFiles<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Install vim-plug if not found
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source ~/.config/nvim/init.vim
endif
call plug#begin()
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'jeetsukumaran/vim-pythonsense'
Plug 'michaeljsmith/vim-indent-object'

Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

" Plug 'leafgarland/typescript-vim'
" Plug 'peitalin/vim-jsx-typescript'

Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

Plug 'jeetsukumaran/vim-pythonsense'
Plug 'michaeljsmith/vim-indent-object'

Plug 'nvim-lualine/lualine.nvim'
" Plug 'nvim-tree/nvim-web-devicons'

Plug 'l3mon4d3/luasnip'

Plug 'onsails/lspkind.nvim'

Plug 'mhartington/formatter.nvim'

Plug 'tjdevries/colorbuddy.nvim'
"Plug 'svrana/neosolarized.nvim'
"Plug 'phha/zenburn.nvim'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'jay-babu/mason-null-ls.nvim'

Plug 'github/copilot.vim'

" fzf native plugin
Plug 'junegunn/fzf'
" fzf.vim
Plug 'junegunn/fzf.vim'

let g:copilot_assume_mapped = v:true

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
call plug#end()

" Set up for Mason / LSP "
lua <<END
  local mason = require("mason")
  local lspconfig = require("mason-lspconfig")

  mason.setup()
  lspconfig.setup()

  local status, nvim_lsp = pcall(require, "lspconfig")
  if (not status) then return end

  lspconfig.setup {
    ensure_installed = { "tsserver", "tailwindcss", "clangd", "emmet_ls",
                         "kotlin_language_server", "pylsp", },
  }

  -- TypeScript
  nvim_lsp.tsserver.setup {
    filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact" },
    cmd = { "typescript-language-server", "--stdio" }
  }

  -- Tailwind
  nvim_lsp.tailwindcss.setup {
    filetypes = { "html", "css", "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact" },
  }

  -- Kotlin
  nvim_lsp.kotlin_language_server.setup {
    filetypes = { "kotlin" },
  }

  -- Emmet
  nvim_lsp.emmet_ls.setup {
    filetypes = {
        'html', 'typescriptreact', 'javascriptreact', 'javascript',
        'typescript', 'javascript.jsx', 'typescript.tsx', 'css'
    },
  }

  -- Python
  nvim_lsp.pylsp.setup {
    filetypes = { "python" },
    settings = {
      pylsp = {
        plugins = {
          pycodestyle = {
            ignore = {'W391'},
            maxLineLength = 100
          }
        }
      }
    }
  }

  --Java
  nvim_lsp.java_language_server.setup {
    filetypes = { "java" }
  }

  -- clangd
  nvim_lsp.clangd.setup {
    filetypes = { "c", "cpp" },
  }
END

" Formaters "
lua <<END
-- Utilities for creating configurations
local util = require "formatter.util"

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    -- Formatter configurations for filetype "lua" go here
    -- and will be executed in order
    lua = {
      -- "formatter.filetypes.lua" defines default configurations for the
      -- "lua" filetype
      require("formatter.filetypes.lua").stylua,

      -- You can also define your own configuration
      function()
        -- Supports conditional formatting
        if util.get_current_buffer_file_name() == "special.lua" then
          return nil
        end

        -- Full specification of configurations is down below and in Vim help
        -- files
        return {
          exe = "stylua",
          args = {
            "--search-parent-directories",
            "--stdin-filepath",
            util.escape_path(util.get_current_buffer_file_path()),
            "--",
            "-",
          },
          stdin = true,
        }
      end
    },
    perl = {
      function()
        return {
          exe = "perltidy",
          args = {
            "--quiet",
            "--paren-tightness=2",
            "--square-bracket-tightness=2",
            "--brace-tightness=2",
            "--block-brace-tightness=0",
            "--extended-block-tightness",
            "--indent-columns=2",
            "--maximum-line-length=80",
            "--cuddled-else",
            "--novalign",
          },
          stdin = true,
        }
      end
    },
    html = {
      require("formatter.filetypes.html").prettier
    },
    css = {
      require("formatter.filetypes.css").prettier
    },
    javascript = {
      require("formatter.filetypes.javascript").prettier
    },
    javascriptreact = {
      require("formatter.filetypes.javascriptreact").prettier
    },
    typescript = {
      require("formatter.filetypes.typescript").prettier
    },
    typescriptreact = {
      require("formatter.filetypes.typescriptreact").prettier
    },
    cpp = {
      require("formatter.filetypes.cpp").clangformat
    },
    c = {
      require("formatter.filetypes.c").clangformat
    },
    kotlin = {
      require("formatter.filetypes.kotlin").ktlink
    },
    python = {
      -- require("formatter.filetypes.python").black,

      -- You can also define your own configuration
      function()
        return {
          exe = "black",
          args = { "-q", "--line-length=100", "-" },
          stdin = true,
        }
      end
    },
    sql = {
      function()
        return {
            exe = "sql-formatter",
            args = {vim.api.nvim_buf_get_name(0), "-l", "bigquery"},
            stdin = true
        }
      end
    },
    java = {
      require("formatter.filetypes.java").google_java_formatter
    },

    -- Use the special "*" filetype for defining formatter configurations on
    -- any filetype
    ["*"] = {
      -- "formatter.filetypes.any" defines default configurations for any
      -- filetype
      require("formatter.filetypes.any").remove_trailing_whitespace
    }
  }
}
END

lua <<END
  require("mason-null-ls").setup({
      ensure_installed = { "pettier", "black", "clangformat", "ktlink", "sql-formatter" }
  })
END

" Setup for Lua Line "
lua <<END
  local status, lualine = pcall(require, "lualine")
  if (not status) then return end

  lualine.setup {
    options = {
      icons_enabled = false,
      theme = 'gruvbox_dark',
      section_separators = { left = '', right = '' },
      component_separators = { left = '', right = '' },
      disabled_filetypes = {}
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch' },
      lualine_c = { {
        'filename',
        file_status = true, -- displays file status (readonly status, modified status)
        path = 2 -- 0 = just filename, 1 = relative path, 2 = absolute path
      } },
      lualine_x = {
        { 'diagnostics', sources = { "nvim_diagnostic" }, symbols = { error = ' ', warn = ' ', info = ' ',
          hint = ' ' } },
        'encoding',
        'filetype'
      },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { {
        'filename',
        file_status = true, -- displays file status (readonly status, modified status)
        path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
      } },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    extensions = { 'fugitive' }
  }
END

" Setup for `cmp` "
lua <<END
  local status, cmp = pcall(require, "cmp")
  if (not status) then return end
  local lspkind = require 'lspkind'

  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<Down>'] = cmp.mapping.select_next_item(),
      ['<Up>'] = cmp.mapping.select_prev_item(),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<Tab>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
      }),
      ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
      }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'buffer' },
    }),
    formatting = {
      format = lspkind.cmp_format({
        mode = 'text', -- show only text annotations
        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

        -- The function below will be called before any actual modifications from lspkind
        -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
        before = function (entry, vim_item)
          return vim_item
        end
      })
    }
  })

  vim.cmd [[
    set completeopt=menuone,noinsert,noselect
    highlight! default link CmpItemKind CmpItemMenuDefault
  ]]
END

" Color Setup "
lua << EOF
  -- setup must be called before loading the colorscheme
  -- Default options:
  require("gruvbox").setup({
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
      strings = false, -- true
      comments = false, -- true
      operators = false,
      folds = true,
    },
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
  vim.cmd("colorscheme gruvbox")
EOF


set foldmethod=indent
set foldnestmax=1

lua require'nvim-treesitter.configs'.setup{highlight={enable=true}}
