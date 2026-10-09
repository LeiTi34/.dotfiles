local grammerguard = require("grammar-guard")
if not grammerguard then return end

grammerguard.init()

local lspconfig = require("lspconfig")
if not lspconfig then return end

-- setup LSP config
lspconfig.grammar_guard.setup({
  cmd = { 'ltex-ls' }, -- add this if you install ltex-ls yourself
	settings = {
		ltex = {
			enabled = { "latex", "tex", "bib", "markdown" },
			language = "de",
			diagnosticSeverity = "information",
			setenceCacheSize = 2000,
			additionalRules = {
				enablePickyRules = true,
				motherTongue = "de",
			},
			trace = { server = "verbose" },
			dictionary = {},
			disabledRules = {},
			hiddenFalsePositives = {},
		},
	},
})
