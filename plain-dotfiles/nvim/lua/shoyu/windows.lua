local map = vim.keymap.set

map(
  'n',
  '\\',
  function()
    if vim.v.count > 0 then
      return '<C-w><C-w>'
    else
      return '<C-w><C-p>'
    end
  end,
  { expr = true }
)

map('n', '<C-h>', '<C-w>h', { remap = true })
map('n', '<C-j>', '<C-w>j', { remap = true })
map('n', '<C-k>', '<C-w>k', { remap = true })
map('n', '<C-l>', '<C-w>l', { remap = true })
map('n', '<Leader>w-', '<C-w>s', { remap = true })
map('n', '<Leader>w\\', '<C-w>v', { remap = true })
map('n', '<Leader>ww', '<C-w>p', { remap = true })
map('n', '<Leader>wd', '<C-w>c', { remap = true })
map('n', '<Leader>w<S-d>', '<C-w><C-c>', { remap = true })
map('n', '<Leader>wo', '<C-w>o', { remap = true })
map('n', '<Leader>w<S-o>', '<C-w><C-o>', { remap = true })
