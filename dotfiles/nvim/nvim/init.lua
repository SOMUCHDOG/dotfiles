--Basic settings
--
-- Leader key
vim.g.mapleader = ' '          -- Set leader key to space
vim.g.maplocalleader = ' '

vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = true  -- Relative line numbers
vim.opt.wrap = false           -- No line wrapping
vim.opt.tabstop = 4            -- Tabs = 4 spaces
vim.opt.shiftwidth = 4         -- Indentation = 4 spaces
vim.opt.expandtab = true       -- Use spaces instead of tabs
vim.opt.cursorline = true      -- Highlight the current line
vim.opt.showmode = false       -- Don't show the mode it's redundant
vim.opt.mouse = 'a'            -- Enable mouse mode
vim.opt.undofile = true        -- Save undo history
vim.opt.ignorecase = true      -- Case-Insensitive searching UNLESS \C or 1+ capital letters in the search
vim.opt.smartcase = true       -- "
vim.opt.clipboard = 'unnamedplus' --
vim.opt.signcolumn = 'yes'     -- https://neovim.io/doc/user/sign.html#_1.-introduction
vim.opt.updatetime = 250       -- makes nvim a bit more snappy
vim.opt.timeoutlen = 400       -- timeoutlen of mapped sequences

vim.opt.inccommand = 'split'   -- Preview substitutions as you type
vim.opt.cursorline = true      -- Show which line the cursor is on

vim.opt.hlsearch = true        -- Highlight searched terms

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})


-- Integrate with your workflow later
--
-- Diagnostic keymaps
--
--
-- Plugin manager and plugins
--
-- Install Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    print("Lazy.nvim is not installed! Clone the repository first.")
end
vim.opt.rtp:prepend(lazypath)

-- Plugin configuration
require("lazy").setup({
    -- Add your plugins here
    { "christoomey/vim-tmux-navigator" },
    { "catppuccin/nvim", name = "catppuccin" },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    { "neovim/nvim-lspconfig" },
    { "nvim-tree/nvim-tree.lua" },
    { "folke/tokyonight.nvim" }, -- Example colorscheme
    { "ThePrimeagen/harpoon", branch = 'harpoon2', dependencies = { "nvim-lua/plenary.nvim" } },
    { "williamboman/mason.nvim" }, -- Manager for LSPs
    { "williamboman/mason-lspconfig.nvim" },

    -- LSP Completions
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "L3MON4D3/LuaSnip" }, -- Snippet engine
    { "saadparwaiz1/cmp_luasnip" }, -- LuaSnip source for nvim-cmp
    { "rafamadriz/friendly-snippets" }, -- Predefined snippets
})


require'nvim-treesitter.configs'.setup {
    ensure_installed = "all",
    highlight = {
        enable = true,
    },
}
 
-- Telescope config
--
require'telescope'.setup {
    defaults = {
        prompt_prefix = "> ",
    }
}


local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

-- Harpoon config
local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<M-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<M-j>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<M-k>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<M-l>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

-- Theme setup for Catppuccin
--
-- Set the Catppuccin flavor
vim.g.catppuccin_flavour = "frappe" -- Options: latte, frappe, macchiato, mocha

-- Load the theme
require("catppuccin").setup({
    integrations = {
        telescope = true,    -- Enable Catppuccin integration for Telescope
        nvimtree = true,     -- Enable integration for NvimTree
        treesitter = true,   -- Enable integration for Treesitter
        lsp_trouble = true,  -- Enable LSP trouble integration
    },
})

-- Apply the theme
vim.cmd.colorscheme "catppuccin"

-- LSP
require("config.lsp").setup()

-- Neovim completions

-- Load LuaSnip and predefined snippets

local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

-- Optional: Add a keybinding to expand or jump in snippets
vim.keymap.set({ "i", "s" }, "<C-l>", function()
    if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    end
end, { desc = "Expand or jump in snippets" })

vim.keymap.set({ "i", "s" }, "<C-h>", function()
    if luasnip.jumpable(-1) then
        luasnip.jump(-1)
    end
end, { desc = "Jump backwards in snippets" })

local cmp = require("cmp")

cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body) -- For snippet support
        end,
    },
    mapping = {
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif require("luasnip").expand_or_jumpable() then
                require("luasnip").expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif require("luasnip").jumpable(-1) then
                require("luasnip").jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = {
        { name = "nvim_lsp" }, -- Use LSP as a source
        { name = "buffer" }, -- Use buffer content
        { name = "path" }, -- Use file paths
        { name = "luasnip" }, -- Use snippets
    },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

