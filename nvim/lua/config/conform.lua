-- Generated Ai
vim.pack.add({
	"https://github.com/stevearc/conform.nvim",
})
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
require("conform").setup({
	formatters_by_ft = {
		-- ==========================================
		-- 1. FILE CONFIG, DEVOPS & INFRASTRUKTUR
		-- ==========================================
		json = { "oxfmt" },
		jsonc = { "oxfmt" },
		json5 = { "oxfmt" },
		yaml = { "oxfmt" },
		["yaml.docker-compose"] = { "oxfmt" },
		["yaml.gitlab"] = { "oxfmt" },
		["yaml.helm-values"] = { "oxfmt" },
		toml = { "taplo" },
		xml = { "xmllint" },
		ini = { "ini_fmt" },
		dosini = { "ini_fmt" },
		cfg = { "ini_fmt" },
		conf = { "ini_fmt" },
		config = { "ini_fmt" },
		properties = { "ini_fmt" },
		dotenv = { "dotenv-linter" },
		sh = { "shfmt" },
		bash = { "shfmt" },
		zsh = { "shfmt" },
		fish = { "fish_indent" },
		dockerfile = { "dockerfmt" },
		terraform = { "terraform_fmt" },
		tf = { "terraform_fmt" },
		["terraform-vars"] = { "terraform_fmt" },
		hcl = { "terraform_fmt" },
		nginx = { "nginxfmt" },
		apache = { "apache-config-formatter" },
		nix = { "alejandra", "nixfmt", stop_after_first = true },
		proto = { "buf" },
		kdl = { "kdlfmt" },
		ron = { "ronfmt" },
		cue = { "cue_fmt" },
		dhall = { "dhall" },
		jsonnet = { "jsonnetfmt" },
		starlark = { "buildifier" },
		bzl = { "buildifier" },
		cmake = { "cmake_format" },
		make = { "bake" },
		just = { "just" },
		editorconfig = { "trim_whitespace" },
		gitconfig = { "trim_whitespace" },
		gitignore = { "trim_whitespace" },
		systemd = { "trim_whitespace" },

		-- ==========================================
		-- 2. WEB DEVELOPMENT (Frontend & Backend)
		-- ==========================================
		javascript = { "oxfmt" },
		javascriptreact = { "oxfmt" },
		typescript = { "oxfmt" },
		typescriptreact = { "oxfmt" },
		html = { "oxfmt" },
		css = { "oxfmt" },
		scss = { "oxfmt" },
		less = { "oxfmt" },
		vue = { "oxfmt" },
		svelte = { "oxfmt" },
		astro = { "oxfmt" },
		graphql = { "oxfmt" },
		markdown = { "oxfmt" },
		mdx = { "oxfmt" },
		svg = { "xmllint" },
		php = { "pint", "php_cs_fixer", stop_after_first = true },
		blade = { "blade-formatter" },
		ruby = { "rubocop" },
		eruby = { "erb_format" },
		sql = { "sqlfluff" },
		prisma = { "prisma" },
		htmx = { "oxfmt" },
		templ = { "templ" },

		-- ==========================================
		-- 3. LOW-LEVEL & SYSTEMS PROGRAMMING
		-- ==========================================
		c = { "clang-format" },
		cpp = { "clang-format" },
		objc = { "clang-format" },
		objcpp = { "clang-format" },
		cuda = { "clang-format" },
		rust = { "rustfmt" },
		go = { "gofumpt", "goimports" },
		asm = { "asmfmt" },
		nasm = { "asmfmt" },
		forth = { "gforth" },

		-- ==========================================
		-- 4. BAHASA PEMROGRAMAN BARU & MODERN
		-- ==========================================
		zig = { "zigfmt" },
		odin = { "odinfmt" },
		v = { "vfmt" },
		vlang = { "vfmt" },
		gleam = { "gleam" },
		elixir = { "mix" },
		heex = { "mix" },
		mojo = { "mojo_format" },
		typst = { "typstyle" },
		nushell = { "nufmt" },
		roc = { "roc_format" },
		carbon = { "clang-format" },
		hare = { "harefmt" },
		jai = { "jaifmt" },

		-- ==========================================
		-- 5. BAHASA POPULER LAINNYA & MOBILE
		-- ==========================================
		lua = { "stylua" },
		python = { "isort", "black" },
		java = { "google-java-format" },
		kotlin = { "ktlint" },
		scala = { "scalafmt" },
		cs = { "csharpier" },
		fsharp = { "fantomas" },
		swift = { "swiftformat" },
		dart = { "dart_format" },
		haskell = { "fourmolu", "ormolu", stop_after_first = true },
		ocaml = { "ocamlformat" },
		clojure = { "zprint" },
		r = { "styler" },
		julia = { "jupytext" },

		-- ==========================================
		-- 6. FALLBACK GLOBAL (Untuk semua file teks/config tak dikenal)
		-- ==========================================
		["_"] = { "trim_whitespace", "trim_newlines" },
	},
})
