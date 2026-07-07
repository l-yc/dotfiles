return {
	-- Lean 4 theorem prover: LSP, infoview, unicode abbreviations.
	-- Needs a Lean toolchain on PATH (install elan: https://github.com/leanprover/elan).
	{
		"Julian/lean.nvim",
		ft = { "lean" },
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-lua/plenary.nvim",
		},
		opts = {
			-- \-prefixed unicode input, e.g. \to -> →, \forall -> ∀.
			abbreviations = { builtin = true },
			-- Start the Lean LSP (lake serve) on .lean files.
			lsp = {},
			-- <LocalLeader> mappings for infoview, goto, etc. (see :h lean.nvim).
			mappings = true,
		},
	},
}
