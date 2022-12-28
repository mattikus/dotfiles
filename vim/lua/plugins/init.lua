return {
  { -- Colorschemes and such
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false, -- don't load lazily for colorscheme
    priority = 1000, -- load before all other plugins
    config = function()
      require('catppuccin').setup {
        integrations = {
          treesitter = true,
          fidget = true,
        }
      }
      vim.cmd.colorscheme 'catppuccin-mocha'
    end,
  },

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  { 'lewis6991/gitsigns.nvim', config = true },

  { -- Fancier statusline
    'nvim-lualine/lualine.nvim',
    config = {
      options = {
        theme = 'catppuccin',
        globalstatus = true,
        component_separators = '|',
        section_separators = '',
      },
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    config = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  {
    'folke/trouble.nvim',
    cmd = { 'TroubleToggle', 'Trouble' },
    config = {
      auto_open = false,
      use_diagnostic_signs = true,
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  { 'numToStr/Comment.nvim', config = true, },

  -- Languages
  'LnL7/vim-nix',
}
