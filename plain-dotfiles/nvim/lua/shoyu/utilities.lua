local map = vim.keymap.set

-- File explorer
require('oil').setup()

-- Comment
require('Comment').setup()

-- Surround
require('nvim-surround').setup {}

-- Orgmode
-- require('orgmode').setup {
--   org_agenda_files = '~/orgfiles/**/*',
--   org_default_notes_file = '~/orgfiles/refile.org',
-- }

-- Harpoon
local harpoon = require('harpoon')

harpoon:setup()

-- map('n', '\\a', function() harpoon:list():add() end)

local conf = require('telescope.config').values
local function harpoon_telescope()
  local file_paths = {}
  for _, item in ipairs(harpoon:list().items) do
    table.insert(file_paths, item.value)
  end

  require('telescope.pickers').new({}, {
    prompt_title = 'Harpoon',
    finder = require('telescope.finders').new_table({
      results = file_paths,
    }),
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end
-- map('n', '\\f', harpoon_telescope)

local function harpoon_quick()
  local count = vim.v.count
  if count == 0 then
    harpoon.ui:toggle_quick_menu(harpoon:list())
  else
    harpoon:list():select(count)
  end
end

-- map('n', '\\\\', harpoon_quick)

-- map('n', '[\\', function() harpoon:list():prev() end)
-- map('n', ']\\', function() harpoon:list():next() end)
