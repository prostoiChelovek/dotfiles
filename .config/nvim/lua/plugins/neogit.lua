local neogit = require('neogit')
neogit.setup {
    use_magit_keybindings = true,
    integrations = {
        diffview = true
    },
}

vim.api.nvim_set_keymap('n', '<leader>gg', ':Neogit<cr>', { noremap = true })
