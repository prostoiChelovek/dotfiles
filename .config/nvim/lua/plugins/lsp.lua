local lsp = require('lsp-zero')

lsp.preset('recommended')

require('rust-tools').setup({
  server = lsp.build_options('rust_analyzer', {})
})

lsp.setup()
