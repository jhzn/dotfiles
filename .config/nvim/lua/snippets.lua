local ls = require("luasnip")
local utils = require("utils")
-- some shorthands...
local s = ls.snippet
local t = ls.text_node local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local newline = function ()
	return t({"",""})
end

local function char_count_same(c1, c2)
	local line = vim.api.nvim_get_current_line()
	-- '%'-escape chars to force explicit match (gsub accepts patterns).
	-- second return value is number of substitutions.
	local _, ct1 = string.gsub(line, '%'..c1, '')
	local _, ct2 = string.gsub(line, '%'..c2, '')
	return ct1 == ct2
end

local function even_count(c)
	local line = vim.api.nvim_get_current_line()
	local _, ct = string.gsub(line, c, '')
	return ct % 2 == 0
end

local function neg(fn, ...)
	return not fn(...)
end

local function part(fn, ...)
	local args = {...}
	return function() print("part() called") return fn(unpack(args)) end
end

-- This makes creation of pair-type snippets easier.
local function pair(pair_begin, pair_end, expand_func, ...)
	-- triggerd by opening part of pair, wordTrig=false to trigger anywhere.
	-- ... is used to pass any args following the expand_func to it.
	return s({trig = pair_begin, wordTrig=false},{
			t({pair_begin}), i(1), t({pair_end})
		}, {

			condition = part(expand_func, part(..., pair_begin, pair_end))
		})
end

ls.add_snippets("all", {
	pair("(", ")", neg, char_count_same),
	pair("{", "}", neg, char_count_same),
	pair("[", "]", neg, char_count_same),
	pair("<", ">", neg, char_count_same),
	pair("'", "'", neg, even_count),
	pair('"', '"', neg, even_count),
	pair("`", "`", neg, even_count),

	s("mitl", fmt([[
	The MIT License (MIT)

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
	]], {}))
})

ls.add_snippets("go", {
	s("iferrp", {
		t("if err != nil {"),
		newline(),
		t("\tpanic(err)"),
		newline(),
		t("}"),
	}),
	s("iferr", {
		t("if err != nil {"),
		newline(),
		t("\treturn err"),
		newline(),
		t("}"),
	}),
	s("pjson", {
		t("{"),
		newline(),
		t("\tgurkaTempLog, _ := json.MarshalIndent("),
		i(1),
		t(', "", "\\t")'),
		newline(),
		t('\tfmt.Printf("P_DEBUG '),
		f(function()
			return { utils.ts_function_surrounding_current_cursor() }
		end, {}),
		t(' \\n%s\\n\", gurkaTempLog)'),
		newline(),
		t("}"),
	}),
	s("pde", {
		t('\tfmt.Printf("P_DEBUG: %+v '),
		f(function()
			return { utils.ts_function_surrounding_current_cursor() }
		end, {}),
		t('\\n",'),
		i(1),
		t(')'),
	}),
	s("pprof_heap", fmt([[
			go func() {{
				label := "{label}"
				for {{
					f, err := os.Create(fmt.Sprintf("/tmp/%s_heap_pprof_%s", label, time.Now().Format(time.RFC3339)))
					if err != nil {{
						panic(err)
					}}
					if err := pprof.WriteHeapProfile(f); err != nil {{
						panic(err)
					}}
					time.Sleep(1 * time.Second)
				}}
			}}()
	]], {
		label = i(1)
	})),
})
-- })

ls.add_snippets("sh", {
	s("root", {
		t("project_root_dir=$(git rev-parse --show-toplevel)"),
		newline(),
	}),
	s("set", fmt([[
			# Bash strict mode
			set -euo pipefail
			# Neat way to show the line and program which caused the error in a pipeline
			trap 's=$?; echo >&2 "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
	]], {})),
})

require("luasnip/loaders/from_vscode").lazy_load({ paths = { vim.env.HOME .. "/.config/nvim/snippets" } })
