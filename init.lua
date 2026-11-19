require("config.lazy")

-- Opciones generales de edición
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250

-- Mapeo de tecla líder (Space)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.background = "dark" -- Configurar modo oscuro
vim.cmd([[colorscheme oxocarbon]])

-- Forzar el mapeo de Ctrl + b en el modo Normal
vim.keymap.set("n", "<C-n>", "<cmd>Neotree toggle left<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<C-b>", "<cmd>Neotree toggle left<CR>", { desc = "Toggle Neo-tree" })
-- vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle left<CR>", { desc = "Toggle Neo-tree" })
-- Cmd+P / Cmd+L / Cmd+H / Cmd+W
-- (Ghostty los envía como CSI u; ver ~/.config/ghostty/config)
vim.keymap.set({ "n", "i", "v" }, "<D-p>", function()
  vim.cmd("stopinsert")
  require("telescope.builtin").find_files()
end, { desc = "Buscar archivos" })
vim.keymap.set({ "n", "i", "v" }, "<D-l>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Tab siguiente" })
vim.keymap.set({ "n", "i", "v" }, "<D-h>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Tab anterior" })
vim.keymap.set({ "n", "i", "v" }, "<D-w>", function()
  local buf = vim.api.nvim_get_current_buf()
  local listed = vim.fn.getbufinfo({ buflisted = 1 })
  if #listed > 1 then
    vim.cmd("BufferLineCyclePrev")
  else
    vim.cmd("enew")
  end
  if vim.api.nvim_buf_is_valid(buf) then
    vim.cmd("silent! bdelete! " .. buf)
  end
end, { desc = "Cerrar tab" })

-- Diagnósticos (squiggly lines) con hover
vim.diagnostic.config({
  underline = true,
  virtual_text = false,
  severity_sort = true,
  float = { border = "rounded", source = true, focusable = false },
})
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
  end,
})

-- Opciones básicas
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 8
vim.opt.cursorline = true
vim.opt.undofile = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.mouse = "a"

-- Tabs reales solo en Go; espacios en el resto de lenguajes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "c", "cpp", "json", "yaml", "javascript", "typescript", "python" },
  callback = function() vim.bo.expandtab = true end,
})

-- Cmd+S guardar, Cmd+/ comentar, Cmd+Shift+F buscar texto
vim.keymap.set({ "n", "i", "v" }, "<D-s>", "<Cmd>w<CR>", { desc = "Guardar" })
vim.keymap.set("n", "<D-/>", "gcc", { remap = true, desc = "Comentar línea" })
vim.keymap.set("i", "<D-/>", "<Esc>gcca", { remap = true, desc = "Comentar línea" })
vim.keymap.set("v", "<D-/>", "gc", { remap = true, desc = "Comentar selección" })
for _, lhs in ipairs({ "<D-F>", "<D-S-f>" }) do
  vim.keymap.set({ "n", "i", "v" }, lhs, function()
    vim.cmd("stopinsert")
    require("telescope.builtin").live_grep()
  end, { desc = "Buscar texto" })
end
