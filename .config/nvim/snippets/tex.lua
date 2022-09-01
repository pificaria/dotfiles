local is_math_ctx = function(line_to_cursor, matched_trigger, captures)
	return vim.api.nvim_eval("vimtex#syntax#in_mathzone()") == 1
end

local math_opts = {
	condition = is_math_ctx,
}

local postfix = require("luasnip.extras.postfix").postfix

return {
	s("mk", { t"$", i(1), t"$ ", i(0) }),
	s("dm", { t{ "", "$$" }, i(1), t{"$$", ""}, i(0) }),
	postfix("_", { l(l.POSTFIX_MATCH .. "_{"), i(1), t"}", i(0) }, math_opts),
	postfix("!", { l(l.POSTFIX_MATCH .. "^{"), i(1), t"}", i(0) }, math_opts),
	s("(", { t"\\left( ", i(1), t"\\right)", i(0) }, math_opts),
	s("{", { t"\\left{ ", i(1), t"\\right}", i(0) }, math_opts),
	postfix("inv", { l(l.POSTFIX_MATCH .. "_{-1}"), i(0) }, math_opts),
	s("//", { t"\\frac{", i(1), t"}{", i(2), t"}", i(0) }, math_opts),
	s("ali", { t{"","$$\\begin{aligned}",""}, i(1), t{"","\\end{aligned}$$","",""} }),
}
