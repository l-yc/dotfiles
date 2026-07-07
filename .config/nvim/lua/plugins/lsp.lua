return {
	-- Completion engine. Release tag pulls a prebuilt fuzzy-matcher binary,
	-- so no Rust toolchain is needed to build it.
	{
		"saghen/blink.cmp",
		version = "*",
		dependencies = { "rafamadriz/friendly-snippets" },
		opts = {
			-- Hybrid: <Tab>/<S-Tab> cycle through suggestions, <Enter> accepts.
			-- Built on the "enter" preset; both keys fall back to their normal
			-- behavior when the completion menu is closed. <C-space> opens the
			-- menu, <C-e> dismisses it.
			keymap = {
				preset = "enter",
				["<Tab>"] = { "select_next", "fallback" },
				["<S-Tab>"] = { "select_prev", "fallback" },
			},
			appearance = { nerd_font_variant = "mono" },
			completion = { documentation = { auto_show = true } },
			sources = { default = { "lsp", "path", "snippets", "buffer" } },
		},
		opts_extend = { "sources.default" },
	},

	-- LSP: mason installs the servers, nvim-lspconfig provides their configs,
	-- and vim.lsp.enable (Neovim 0.11+) activates them.
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			-- Add a server here (and to mason if needed) to enable a language.
			-- e.g. "rust_analyzer", "lua_ls"
			local servers = { "pyright", "ts_ls", "clangd" }

			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = servers,
			})

			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})
			vim.lsp.enable(servers)

			-- Buffer-local keymaps, set only once a server attaches to the buffer.
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local map = function(keys, fn, desc)
						vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
					end
					map("gd", vim.lsp.buf.definition, "Goto definition")
					map("gr", vim.lsp.buf.references, "References")
					map("gi", vim.lsp.buf.implementation, "Goto implementation")
					map("K", vim.lsp.buf.hover, "Hover docs")
					map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
					map("<leader>ca", vim.lsp.buf.code_action, "Code action")
					map("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev diagnostic")
					map("]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
				end,
			})
		end,
	},
}
