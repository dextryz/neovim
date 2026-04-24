-- Filetype detection — must be first, before LSP and plugins
vim.filetype.add({
    extension = {
        templ = "templ",
        zig   = "zig",
    },
})

vim.opt.cursorline     = true
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.expandtab      = false
vim.opt.swapfile       = false
vim.opt.tabstop        = 4
vim.opt.shiftwidth     = 4  -- removed duplicate
vim.opt.softtabstop    = 4
vim.opt.clipboard      = "unnamedplus"
vim.o.showcmd          = false
vim.o.wrap             = true
vim.o.linebreak        = true
vim.o.foldenable       = true
vim.o.foldmethod       = 'indent'
vim.o.foldlevel        = 1
vim.o.foldlevelstart   = 99

vim.api.nvim_set_hl(0, "StatusLineModified", { fg = "#A7C080", bold = true })
vim.o.statusline = "%f%r %#StatusLineModified#%m%* %=[%L]"

vim.pack.add({
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/neanias/everforest-nvim" },
	{ src = "https://github.com/rebelot/kanagawa.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/karb94/neoscroll.nvim" },
	{ src = "https://github.com/windwp/nvim-autopairs" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{
		src = "https://github.com/saghen/blink.cmp",
		version = "v1.6.0",
	},
})

vim.keymap.set("n", "<space>s", [[:.!sh<CR>]], { noremap = true, silent = false })

vim.keymap.set("n", "<space>ff", function()
	require("fzf-lua").files()
end)

vim.keymap.set("n", "<space>bb", function()
	require("fzf-lua").buffers()
end)

vim.keymap.set("n", "<space>gg", function()
	require("fzf-lua").live_grep()
end)

vim.keymap.set("n", "<space>do", function()
	vim.diagnostic.open_float()
end)

vim.keymap.set("n", "<space>fb", function()
	vim.lsp.buf.format()
end)

vim.keymap.set("n", "<space>gd", function()
	vim.lsp.buf.definition()
end)

vim.keymap.set("n", "<space>gi", function()
	vim.lsp.buf.implementation()
end)

vim.keymap.set("n", "<space>gc", function()
	vim.lsp.buf.code_action()
end)

vim.lsp.enable({
	"lua_ls",
	"bashls",
	"gopls",
	"zk",
	"zls",
--	"pyright", -- type checking, goto jumps, etc
	"basedpyright",
	"ruff",    -- fast linting, formatting, and import sorting
	"html",
	"templ",
	"cssls",
	"cssmodules_ls",
})

vim.lsp.config("basedpyright", {
    settings = {
        basedpyright = {
            disableOrganizeImports = true,
            analysis = {
                typeCheckingMode = "off",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
            },
        },
    },
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				library = { vim.env.VIMRUNTIME },
				checkThirdParty = false,
			},
		},
	},
})

-- templ LSP config
vim.lsp.config("templ", {
    filetypes    = { "templ" },
    root_markers = { "go.mod", ".git" },
})

-- html LSP — attach to both html and templ files
vim.lsp.config("html", {
    filetypes    = { "html", "templ" },
    root_markers = { ".git" },
})

-- cssls — templ gets CSS completions inside <style> tags too
vim.lsp.config("cssls", {
    filetypes    = { "css", "scss", "less", "templ" },
    root_markers = { ".git" },
})

require("gitsigns").setup({})

--require("everforest").setup({
--	background = "medium",
--	transparent_background_level = 2,
--	italics = true,
--	disable_italic_comments = false,
--	sign_column_background = "none",
--	ui_contrast = "low",
--	dim_inactive_windows = false,
--	diagnostic_text_highlight = false,
--	diagnostic_virtual_text = "coloured",
--	diagnostic_line_highlight = false,
--	spell_foreground = false,
--	show_eob = true,
--	float_style = "bright",
--	inlay_hints_background = "none",
--	on_highlights = function(highlight_groups, palette) end,
--	colours_override = function(palette) end,
--})
--require("everforest").load()

require('nvim-autopairs').setup()

require('neoscroll').setup()

require('blink.cmp').setup({
	fuzzy = { implementation = 'prefer_rust_with_warning' },
	signature = { enabled = true },
	keymap = {
		preset = "default",
		["<Tab>"] = { "select_and_accept" },
		["<C-p>"] = { "select_prev", "fallback" },
		["<C-n>"] = { "select_next", "fallback" },
		["<C-y>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-k>"] = { "snippet_forward", "fallback" },  -- jump to next placeholder
		["<C-j>"] = { "snippet_backward", "fallback" }, -- jump to previous
	},
	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = "normal",
	},
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		}
	},
	cmdline = {
		keymap = {
			preset = 'inherit',
			['<CR>'] = { 'accept_and_enter', 'fallback' },
		},
	},
	sources = { default = { "lsp", "snippets" } },
	snippets = { preset = "default" },  -- loads from ~/.config/nvim/snippets/
})

require('fzf-lua').setup {
	files = {
		hidden = false,
	},
	winopts = {
		preview = {
			layout  = "vertical",
			title   = false,
			winopts = {
				number = false,
			},
		},
	},
}

-- Python: use spaces per PEP 8 (overrides global hard tabs)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.opt_local.expandtab   = true
		vim.opt_local.tabstop     = 4
		vim.opt_local.shiftwidth  = 4
		vim.opt_local.softtabstop = 4
	end,
})

-- Format Python on save via ruff
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.py",
    callback = function()
        vim.lsp.buf.format({ name = "ruff" })
    end,
})

-- Format .templ on save via `templ fmt`
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern  = "*.templ",
    callback = function()
        local bufnr    = vim.api.nvim_get_current_buf()
        local filename = vim.api.nvim_buf_get_name(bufnr)
        vim.fn.jobstart({ "templ", "fmt", filename }, {
            on_exit = function()
                if vim.api.nvim_get_current_buf() == bufnr then
                    vim.cmd("e!")
                end
            end,
        })
    end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = 'Highlight when yanking text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern  = "*.zig",
    callback = function()
        vim.lsp.buf.format({ name = "zls" })
    end,
})

-- Disable unused built-in plugins
vim.g.loaded_2html_plugin      = 1
vim.g.loaded_getscriptPlugin   = 1
vim.g.loaded_gzip              = 1
vim.g.loaded_logiPat           = 1
vim.g.loaded_rrhelper          = 1
vim.g.loaded_spec              = 1
vim.g.loaded_tar               = 1
vim.g.loaded_tarPlugin         = 1
vim.g.loaded_vimball           = 1
vim.g.loaded_vimballPlugin     = 1
vim.g.loaded_zip               = 1
vim.g.loaded_zipPlugin         = 1
vim.g.loaded_netrw             = 1
vim.g.loaded_netrwPlugin       = 1
vim.g.loaded_netrwSettings     = 1
vim.g.loaded_netrwFileHandlers = 1

-- Default options:
require('kanagawa').setup({
    compile = false,             -- enable compiling the colorscheme
    undercurl = true,            -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true},
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = true,         -- do not set background color
    dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
    terminalColors = true,       -- define vim.g.terminal_color_{0,17}
    colors = {                   -- add/modify theme and palette colors
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
    },
    overrides = function(colors) -- add/modify highlights
        return {
			LineNr = { bg = "none" },
		}
    end,
    theme = "wave",              -- Load "wave" theme
    background = {               -- map the value of 'background' option to a theme
        dark = "wave",           -- try "dragon" !
        light = "lotus"
    },
})

-- setup must be called before loading
vim.cmd("colorscheme kanagawa")
