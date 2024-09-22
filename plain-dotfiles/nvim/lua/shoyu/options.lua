local opt = vim.opt

-- Disable mouse
opt.mouse = ''

-- We have lualine
opt.showmode = false
-- Unique, global status-line
opt.laststatus = 3

-- We have Treesitter
opt.syntax = 'off'

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = 'yes'

opt.scrolloff = 4

opt.splitbelow = true
opt.splitright = true
opt.splitkeep = 'screen'

opt.wrap = true
opt.linebreak = true
opt.showbreak = '↪'

opt.list = true
opt.listchars = 'tab:⇤–⇥,space:·,trail:·,precedes:⇠,extends:⇢,nbsp:×'

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

opt.grepformat = '%f:%l:%c:%m'
opt.grepprg = 'rg --vimgrep'

opt.inccommand = 'nosplit'

opt.expandtab = true
opt.shiftwidth = 4
opt.shiftround = true

opt.completeopt = 'menu,menuone,noselect'

opt.undofile = true
