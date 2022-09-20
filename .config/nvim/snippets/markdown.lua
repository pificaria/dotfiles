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

local on_top = function()
	local cursor = vim.api.nvim_win_get_cursor(0)
	if cursor[1] <= 3 then
		return true
	end
	return false
end

local pipe = function(fns)
    return function(...)
        for _, fn in ipairs(fns) do
            if not fn(...) then
                return false
            end
        end

        return true
    end
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
	s("hj", {
		d(1, date_res, {}, { user_args = { "%Y-%m-%d" } }),
		i(0),
	}),
	s("grifo", {
		t "[grifo meu]",
		i(0)
	}),
	s("cgrifo", {
		t "[⤵]",
		i(0),
	}),
	s("egrifo", {
		t "[↑ grifo meu]",
		i(0),
	}),
	s({trig="meta", name="Markdown front matter"}, {
			t { "---", "title: " },
			i(1),
			t { "", "date: " },
			p(os.date, "%Y-%m-%d %H:%M:%S"),
			t { "", "tags: [" },
			i(2),
			t { "]", "---", "" },
			i(0),
	}, { condition = pipe { on_top, conds.line_begin }, show_condition = on_top } ),
	s({ trig = ',b', name = 'bold' }, { t '**', i(1), t '**' }),
	s({ trig = ',i', name = 'italic' }, { t '*', i(1), t '*' }),
	s({ trig = ',c', name = 'code' }, { t '`', i(1), t '`' }),
	s({ trig = ',s', name = 'strikethrough' }, { t '~~', i(1), t '~~' }),
}
