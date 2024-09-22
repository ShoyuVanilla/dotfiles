vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local map = vim.keymap.set

-- Escape into Normal Mode
map('i', 'jk', '<Esc>')
map('v', ';', '<Esc>')

-- Clear search on Esc
map({ 'n', 'i' }, '<Esc>', '<Cmd>nohlsearch<CR><Esc>')

-- Better Movements on Wrapped Lines
map({ 'n', 'v' }, 'j', 'v:count == 0 ? "gj" : "j"', { expr = true, silent = true })
map({ 'n', 'v' }, 'k', 'v:count == 0 ? "gk" : "k"', { expr = true, silent = true })

-- Better indentation
map('v', '<', '<gv')
map('v', '>', '>gv')

map({ 'n', 'x' }, 'ge', 'G')
map({ 'n', 'x' }, 'gh', '0')
map({ 'n', 'x' }, 'gs', '^')
map({ 'n', 'x' }, 'gl', '$')

-- Tabs
map('n', '<Leader>td', '<Cmd>tabclose<CR>')
map('n', '<Leader>t<S-d>', '<Cmd>tabclose!<CR>')
map('n', '<Leader>to', '<Cmd>tabonly<CR>')
map('n', '<Leader>t<S-o>', '<Cmd>tabonly!<CR>')

-- VCS
-- map('n', '<Leader><S-v>', '<Cmd>tab G<CR>')
-- map('n', '<Leader>vc', '<Cmd>Telescope git_bcommits<CR>', { silent = true })
-- map('n', '<Leader>v<S-C>', '<Cmd>Telescope git_commits<CR>', { silent = true })
-- map('n', '<Leader>vb', '<Cmd>Telescope git_branches<CR>', { silent = true })
-- map('n', '<Leader>vs', '<Cmd>Telescope git_status<CR>', { silent = true })
-- map('n', '<Leader>v<S-s>', '<Cmd>Telescope git_stash<CR>', { silent = true })

-- clipboard
map({ 'n', 'v' }, '<Leader>y', '"*y')
map({ 'n', 'v' }, '<Leader>p', '"*p')
map({ 'n', 'v' }, '<Leader><S-p>', '"*<S-p>')
