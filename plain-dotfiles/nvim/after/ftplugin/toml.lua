vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2

local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':t')
if fname ~= 'Cargo.toml' then
  return
end

-- TODO: Rust analyzer reload workspace
