-- Treesitter
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['ia'] = '@parameter.inner',
        ['aa'] = '@parameter.outer',
        ['if'] = '@function.inner',
        ['af'] = '@function.outer',
        ['it'] = { query = '@class.inner', desc = 'Select inner part of a class region' },
        ['at'] = '@class.outer',
        ['ir'] = '@return.inner',
        ['ar'] = '@return.outer',
        ['ib'] = '@block.inner',
        ['ab'] = '@block.outer',
        ['io'] = '@loop.inner',
        ['ao'] = '@loop.outer',
        ['il'] = '@call.inner',
        ['al'] = '@call.outer',
        ['ic'] = '@comment.inner',
        ['ac'] = '@comment.outer',
        ['isl'] = '@assignment.lhs',
        ['isr'] = '@assignment.rhs',
        ['as'] = '@assignment.outer',
        ['ii'] = '@conditional.inner',
        ['ai'] = '@conditional.outer',
      },
      include_surrounding_whitespace = true,
    },
    swap = {
      enable = true,
      swap_next = {
        ['<Leader>]a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<Leader>[a'] = '@parameter.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']f'] = '@function.outer',
        [']t'] = { query = '@class.outer', desc = 'Next class start' },
        [']b'] = '@block.outer',
        [']a'] = '@parameter.outer',
        [']r'] = '@return.outer',
        [']l'] = '@call.outer',
        [']o'] = '@loop.outer',
        [']s'] = '@assignment.outer',
        [']c'] = '@comment.outer',
        [']i'] = '@conditional.outer',
      },
      goto_next_end = {
        [']F'] = '@function.outer',
        [']T'] = { query = '@class.outer', desc = 'Next class start' },
        [']B'] = '@block.outer',
        [']A'] = '@parameter.outer',
        [']R'] = '@return.outer',
        [']L'] = '@call.outer',
        [']O'] = '@loop.outer',
        [']S'] = '@assignment.outer',
        [']C'] = '@comment.outer',
        [']I'] = '@conditional.outer',
      },
      goto_previous_start = {
        ['[f'] = '@function.outer',
        ['[t'] = { query = '@class.outer', desc = 'Next class start' },
        ['[b'] = '@block.outer',
        ['[a'] = '@parameter.outer',
        ['[r'] = '@return.outer',
        ['[l'] = '@call.outer',
        ['[o'] = '@loop.outer',
        ['[s'] = '@assignment.outer',
        ['[c'] = '@comment.outer',
        ['[i'] = '@conditional.outer',
      },
      goto_previous_end = {
        ['[F'] = '@function.outer',
        ['[T'] = { query = '@class.outer', desc = 'Next class start' },
        ['[B'] = '@block.outer',
        ['[A'] = '@parameter.outer',
        ['[R'] = '@return.outer',
        ['[L'] = '@call.outer',
        ['[O'] = '@loop.outer',
        ['[S'] = '@assignment.outer',
        ['[C'] = '@comment.outer',
        ['[I'] = '@conditional.outer',
      },
      -- Below will go to either the start or the end, whichever is closer.
      -- Use if you want more granular movements
      -- Make it even more gradual by adding multiple queries and regex.
      goto_next = {
      },
      goto_previous = {
      }
    },
  },
}

-- Boilerplates for autocompletion
local luasnip = require('luasnip')

local cmp = require('cmp')
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-b>'] = cmp.mapping.scroll_docs(-8),
    ['<C-f>'] = cmp.mapping.scroll_docs(8),
    ['<C-x>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    -- { name = 'orgmode' },
  },
}

luasnip.config.set_config({ history = true, updateevents = 'TextChanged,TextChangedI' })
require('luasnip.loaders.from_vscode').lazy_load()

require('nvim-autopairs').setup()
local autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', autopairs.on_confirm_done({ map_char = { tex = '' } }))

-- Languages
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { 'documentation', 'detail', 'additionalTextEdits' },
}

lspconfig.rust_analyzer.setup {
  settings = {
    ['rust-analyzer'] = {
      cargo = { targetDir = true },
      check = { command = 'clippy' },
      inlayHints = {
        bindingModeHints = { enabled = true },
        closureCaptureHints = { enabled = true },
        closureReturnTypeHints = { enable = 'always' },
        maxLength = 100,
      },
    }
  },
  capabilities = capabilities,
}

lspconfig.clangd.setup {
  capabilities = capabilities,
}

lspconfig.lua_ls.setup {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- Depending on the usage, you might want to add additional paths here.
          -- '${3rd}/luv/library'
          -- '${3rd}/busted/library',
        }
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file('', true)
      }
    })
  end,
  settings = {
    Lua = {}
  },
  capabilities = capabilities,
}

lspconfig.nil_ls.setup {
  capabilities = capabilities,
}

lspconfig.gopls.setup {
  capabilities = capabilities,
}

lspconfig.golangci_lint_ls.setup {
  capabilities = capabilities,
}

lspconfig.bashls.setup {
  capabilities = capabilities,
}

lspconfig.tsserver.setup {
  capabilities = capabilities,
}

lspconfig.pylsp.setup {
  capabilities = capabilities,
}

lspconfig.taplo.setup {
  capabilities = capabilities,
}

lspconfig.yamlls.setup {
  settings = {
    yaml = {
      schemas = {
        ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
        ['https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json'] = '/*.k8s.yaml',
      },
    }
  },
  filetypes = { 'yaml', 'yaml.gitlab' },
  capabilities = capabilities,
}

lspconfig.docker_compose_language_service.setup {
  capabilities = capabilities,
}

lspconfig.dockerls.setup {
  capabilities = capabilities,
}

lspconfig.jsonls.setup {
  capabilities = capabilities,
}

lspconfig.html.setup {
  capabilities = capabilities,
}

lspconfig.cssls.setup {
  capabilities = capabilities,
}

lspconfig.typst_lsp.setup {
  capabilities = capabilities,
}

lspconfig.cmake.setup {
  capabilities = capabilities,
}

lspconfig.markdown_oxide.setup {
  capabilities = capabilities,
}

lspconfig.csharp_ls.setup {
  capabilities = capabilities,
}

-- Keymaps
local builtin = require('telescope.builtin')

local diag_local = function()
  builtin.diagnostics({ bufnr = 0 })
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.lsp.inlay_hint.enable(true)
    local opts = { buffer = ev.buf }
    vim.keymap.set({ 'n', 'v' }, '<Leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<Leader>r', vim.lsp.buf.rename, { buffer = ev.buf })
    vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, opts)
    vim.keymap.set(
      'n',
      '[d',
      function()
        vim.diagnostic.goto_prev({ severity = { min = vim.diagnostic.severity.WARN } })
      end,
      opts
    )
    vim.keymap.set(
      'n',
      ']d',
      function()
        vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.WARN } })
      end,
      opts
    )
    vim.keymap.set('n', '<Leader>d', diag_local, opts)
    vim.keymap.set('n', '<Leader><S-d>', builtin.diagnostics, opts)

    vim.keymap.set('n', 'gr', builtin.lsp_references, opts)
    vim.keymap.set('n', 'gd', builtin.lsp_definitions, opts)
    vim.keymap.set('n', 'gy', builtin.lsp_type_definitions, opts)
    vim.keymap.set('n', 'gi', builtin.lsp_implementations, opts)
    vim.keymap.set('n', '<Leader>s', builtin.lsp_document_symbols, opts)
    vim.keymap.set('n', '<Leader>S', builtin.lsp_dynamic_workspace_symbols, opts)
  end,
})

-- Format
require('conform').setup({
  formatters_by_ft = {
    nix = { 'nixfmt' },
    typst = { 'typstfmt' },
    markdown = { 'mdformat' },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})

vim.keymap.set('n', '<Leader>cf', vim.lsp.buf.format)

require('lsp_lines').setup()
