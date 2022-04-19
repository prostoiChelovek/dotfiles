local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('i', '<C-]>', '<Esc>')
map('c', '<C-j>', '<Up>')
map('c', '<C-k>', '<Down>')
map('n', '<C-c>', ':bp | bd #<CR>')

