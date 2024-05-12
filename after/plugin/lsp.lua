require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = {
        "lua_ls",
        "gopls",
        "angularls",
        "tsserver",
        "html",
        "cssls",
        "somesass_ls",
        "jsonls",
        "eslint",
        "dockerls",
        "marksman",
    },
}

local lsp = require('lspconfig')

lsp.lua_ls.setup {}
lsp.gopls.setup{}
lsp.angularls.setup {}
lsp.tsserver.setup {}
lsp.html.setup {}
lsp.cssls.setup {}
lsp.somesass_ls.setup {}
lsp.jsonls.setup {}
lsp.eslint.setup {}
lsp.dockerls.setup {}
lsp.marksman.setup {}

local autocmd = vim.api.nvim_create_autocmd

autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end
})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function (e)
    	local opts = { buffer = e.buf }
	    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
	    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
	    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
	    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
	    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
	    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
	    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
	    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
	    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)

    end
})


vim.diagnostic.config({
    signs = false
})




local cmp = require("cmp")

cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
      ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
      ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ['<C-Space>'] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
      { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})
