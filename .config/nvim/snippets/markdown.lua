-- Returns a snippet_node wrapped around an insert_node whose initial
-- text value is set to the current date in the desired format.
local date_input = function(args, snip, old_state, fmt)
	local fmt = fmt or "%Y-%m-%d"
	return sn(nil, i(1, os.date(fmt)))
end

local date_res = function(args, snip, old_state, fmt)
	local fmt = fmt or "%Y-%m-%d"
	return sn(nil, t(os.date(fmt)))
end

return {
	s("bugr", {
		t "# bug",
		i(1),
		t { "", "", "tags: " },
		i(2),
		t { "", "", "## Descrição", "", "" },
		i(0),
	}),
	s("th", {
		d(1, date_res, {}, { user_args = { "# %T" } }),
		t { "", "", "" },
		i(0),
	}),
	s("lhj", {
		d(1, date_res, {}, { user_args = {"[%d](%Y-%m-%d.md)" } }),
		t { "" },
	}),
	s("cth", {
		d(1, date_res, {}, { user_args = { "## %Y-%m-%d %T" } }),
		t { "", "", "" },
	}),
}
