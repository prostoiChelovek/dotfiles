local actions = require('telescope.actions')
local tb = require('telescope.builtin')

require('telescope').setup {
    defaults = {
        file_sorter = require('telescope.sorters').get_fzy_sorter,
        prompt_prefix = ' >',
        color_devicons = true,

        file_previewer   = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer   = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

        mappings = {
            i = {
                ["<C-x>"] = false,
                ["<C-q>"] = actions.send_to_qflist,
            },
        }
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    }
}

require('telescope').load_extension('fzy_native')

local function search_dotfiles ()
    tb.find_files({
        prompt_title = "< VimRC >",
        cwd = "$HOME/.config/nvim",
    })
end

vim.keymap.set('n', '<C-p>', tb.git_files, {})
vim.keymap.set('n', '<leader>pf', tb.find_files, {})
vim.keymap.set('n', '<leader>ps', tb.live_grep, {})
vim.keymap.set('n', '<leader>pb', tb.buffers, {})
vim.keymap.set('n', '<leader>vrc', search_dotfiles, {})

