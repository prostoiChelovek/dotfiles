local lsp = require('lsp-zero')

lsp.preset('recommended')

require('rust-tools').setup({
  server = lsp.build_options('rust_analyzer', {})
})

lsp.nvim_workspace({
  library = vim.api.nvim_get_runtime_file('', true)
})

lsp.setup()
