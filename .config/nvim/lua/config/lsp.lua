
local M = {}

-- Mason and LSP Setup
function M.setup()
    require("mason").setup()
    require("mason-lspconfig").setup({
        ensure_installed = {
            "pyright",        -- Python
            "omnisharp",      -- C# and VB.Net
            "gopls",          -- Go
            "ts_ls",       -- JavaScript/TypeScript
            "rust_analyzer",  -- Rust
            "clangd",         -- C++
            "html",           -- HTML
            "cssls",          -- CSS
        },
    })

    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Configure each LSP server
    lspconfig.pyright.setup({ capabilities = capabilities })       -- Python
    lspconfig.omnisharp.setup({ capabilities = capabilities })     -- C# and VB.Net
    lspconfig.gopls.setup({
        capabilities = capabilities,
        settings = {
            gopls = { analyses = { unusedparams = true }, staticcheck = true },
        },
    }) -- Go
    lspconfig.ts_ls.setup({ capabilities = capabilities })      -- JavaScript/TypeScript
    lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        settings = {
            ["rust-analyzer"] = {
                cargo = { allFeatures = true },
                checkOnSave = { command = "clippy" },
            },
        },
    }) -- Rust
    lspconfig.clangd.setup({ capabilities = capabilities })        -- C++
    lspconfig.html.setup({ capabilities = capabilities })          -- HTML
    lspconfig.cssls.setup({ capabilities = capabilities })         -- CSS

    -- Key mappings
    local opts = { noremap = true, silent = true, desc = "LSP action" }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

    -- Format on save
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.py", "*.cs", "*.go", "*.js", "*.ts", "*.rs", "*.cpp", "*.html", "*.css" },
        callback = function()
            vim.lsp.buf.format({ async = false })
        end,
    })
end

return M
