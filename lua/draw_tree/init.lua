-- lua/draw_tree/init.lua
-- Minimal, self-contained tree-drawing mode plugin for Neovim (Lua)
-- Usage:
--   require("draw_tree").setup({ key = "<leader>t", key_order = {...}, symbols = {...} })
-- Then in insert mode press the key to toggle tree mode for the current buffer.

local M = {}

-- default ordered keys and symbols (you provided a preferred order)
local DEFAULT_KEY_ORDER = {"r", "v", "l", "z", "f", "j", "n", "y", "t", "b", "x"}
local DEFAULT_SYMBOLS = {
  r = "├", -- vertical + right
  v = "│", -- vertical
  l = "└", -- corner bottom-left
  h = "─", -- horizontal
  f = "┌", -- corner top-left
  j = "┘", -- corner bottom-right
  n = "┐", -- corner top-right
  y = "┤", -- vertical + left
  t = "┬", -- T down
  b = "┴", -- T up
  x = "┼", -- cross
}

-- state: set of buffers with mode enabled
local enabled = {}

-- configuration (populated by setup)
local config = {
  key = "<leader>t",        -- toggle key in insert mode
  key_order = DEFAULT_KEY_ORDER,
  symbols = DEFAULT_SYMBOLS,
  notify = false,       -- if true use vim.notify for on/off messages (optional)
}

-- Helper: deterministic help message using key_order
local function build_help_lines()
  local lines = { "Tree mode: ON", "Key mappings:" }
  for _, k in ipairs(config.key_order) do
    local sym = config.symbols[k] or "?"
    table.insert(lines, string.format("  %s → %s", k, sym))
  end
  return lines
end

-- Echo help to commandline
function M.echo_help()
  local lines = build_help_lines()
  vim.api.nvim_echo({{table.concat(lines, "\n"), "Normal"}}, true, {})
end

-- Enable tree mode for a buffer
local function enable_for_buf(bufnr)
  if not bufnr or bufnr == 0 then bufnr = vim.api.nvim_get_current_buf() end
  if enabled[bufnr] then return end
  enabled[bufnr] = true

  -- create buffer-local insert mappings for each ordered key
  for _, k in ipairs(config.key_order) do
    local rhs = config.symbols[k] or ""
    -- map to the literal symbol; allow mapping to be overwritten by buffer-local mappings
    vim.keymap.set("i", k, rhs, { buffer = bufnr, noremap = true, silent = true })
  end

  -- show help
  M.echo_help()
end

-- Disable tree mode for a buffer
local function disable_for_buf(bufnr)
  if not bufnr or bufnr == 0 then bufnr = vim.api.nvim_get_current_buf() end
  if not enabled[bufnr] then return end
  enabled[bufnr] = nil

  -- delete buffer-local mappings safely
  for _, k in ipairs(config.key_order) do
    pcall(vim.keymap.del, "i", k, { buffer = bufnr })
  end

  -- print off message
  vim.api.nvim_echo({{"Tree mode: OFF", "WarningMsg"}}, true, {})
end

-- Toggle (current buffer)
function M.toggle(bufnr)
  if not bufnr or bufnr == 0 then bufnr = vim.api.nvim_get_current_buf() end
  if enabled[bufnr] then
    disable_for_buf(bufnr)
  else
    enable_for_buf(bufnr)
  end
end

-- Expose enable/disable per-buffer as convenience
function M.enable(bufnr) enable_for_buf(bufnr) end
function M.disable(bufnr) disable_for_buf(bufnr) end

-- Setup function for customization
-- opts = { key = "<leader>t", key_order = {...}, symbols = {...}, notify = true/false }
function M.setup(opts)
  opts = opts or {}
  if opts.key then config.key = opts.key end
  if opts.key_order then config.key_order = opts.key_order end
  if opts.symbols then
    -- shallow merge so default symbols not overwritten if missing
    for k, v in pairs(opts.symbols) do
      config.symbols[k] = v
    end
  end
  if opts.notify ~= nil then config.notify = opts.notify end

  -- Create user commands and mappings
  -- :TreeModeToggle toggles for current buffer
  vim.api.nvim_create_user_command("TreeModeToggle", function() M.toggle() end, { desc = "Toggle Tree Mode (buffer-local)" })
  vim.api.nvim_create_user_command("TreeHelp", function() M.echo_help() end, { desc = "Show Tree Mode help" })

  -- Insert-mode mapping to toggle (global mapping)
  -- We map it to a Lua call that toggles the current buffer
  vim.keymap.set("i", config.key, function() M.toggle() end, { noremap = true, silent = true })

  -- return the config for convenience
  return config
end

return M

