local M = { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = "make CC='zig cc'" },
    { 'nvim-telescope/telescope-symbols.nvim' },
    { 'nvim-telescope/telescope-file-browser.nvim' },
  }
}

function M.config()
  local ts = require('telescope')
  ts.setup{
    defaults = {
      mappings = {
        i = {
          ['<C-u>'] = false,
          ['<C-d>'] = false,
        },
      },
    },
  }
  ts.load_extension('fzf')
  ts.load_extension('file_browser')
end

function M.init()
  local ts = require('telescope')
  local tsb = require('telescope.builtin')
  -- See `:help telescope.builtin`
  vim.keymap.set('n', '<leader>?', tsb.oldfiles, { desc = '[?] Find recently opened files' })
  vim.keymap.set('n', '<leader><space>', tsb.buffers, { desc = '[ ] Find existing buffers' })
  vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    tsb.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = '[/] Fuzzily search in current buffer]' })

  vim.keymap.set('n', '<leader>ff', tsb.find_files, { desc = '[F]ind [F]iles' })
  vim.keymap.set('n', '<leader>fb', ts.extensions.file_browser.file_browser, { desc = '[F]ile [B]rowser' })
  vim.keymap.set('n', '<leader>sh', tsb.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sw', tsb.grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', tsb.live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', tsb.diagnostics, { desc = '[S]earch [D]iagnostics' })
end

return M
