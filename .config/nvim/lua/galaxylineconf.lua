local gl = require("galaxyline")
local gls = gl.section
local condition = require("galaxyline.condition")
local fileinfo = require("galaxyline.condition")
local utils = require("utils")
local plenary_path = require("plenary.path")

gl.short_line_list = { " " }

local colors = require('onedark.palette')[vim.g.theme_style]
colors.statusline_bg = colors.bg0
colors.lightbg = colors.bg1

local checkwidth = function()
	local squeeze_width = vim.fn.winwidth(0) / 2
	if squeeze_width > 30 then
		return true
	end
	return false
end

-- TODO: Use this as the default programmatically
local separator = ""
local separator_highlight = { colors.purple, colors.lightbg }
local highlight = function(foreground)
	return { foreground, colors.statusline_bg }
end

local left = {
	{
		FirstElement = {
			provider = function()
				return "▋"
			end,
			highlight = { colors.blue, colors.blue }
		}
	},
	{
		statusIcon = {
			provider = function()
				return "  "
			end,
			highlight = { colors.statusline_bg, colors.blue },
			separator = " ",
			separator_highlight = highlight(colors.blue),
		}
	},
	{
		current_dir = {
			provider = function()
				local filepath = vim.fn.fnamemodify(vim.fn.expand('%:p:h'), ':~:.')
				return "   " .. plenary_path.new(filepath):shorten(5) .. " "
			end,
			highlight = highlight(colors.grey),
			separator = separator,
		}
	},
	{
		FileName = {
			provider = { "FileName" },
			condition = condition.buffer_not_empty,
			highlight = { colors.white, colors.statusline_bg },
			separator = separator,
			separator_highlight = highlight(colors.lightbg),
		}
	},
	{
		DiffAdd = {
			provider = "DiffAdd",
			condition = checkwidth,
			icon = "  ",
			highlight = highlight(colors.white),
		}
	},
	{
		DiffModified = {
			provider = "DiffModified",
			condition = checkwidth,
			icon = "   ",
			highlight = highlight(colors.grey),
		}
	},
	{
		DiffRemove = {
			provider = "DiffRemove",
			condition = checkwidth,
			icon = "  ",
			highlight = highlight(colors.grey);
		}
	},
	{
		DiagnosticError = {
			provider = "DiagnosticError",
			icon = "  ",
			highlight = highlight(colors.red),
		}
	},
	{
		DiagnosticWarn = {
			provider = "DiagnosticWarn",
			icon = "  ",
			highlight = highlight(colors.yellow),
		}
	},
}

local mid = {
	{
		ViMode = {
			provider = function()
				local mode_color = {
					n = colors.red,
					i = colors.green,
					v=colors.blue,
					[''] = colors.blue,
					V=colors.blue,
					c = colors.magenta,
					no = colors.red,
					s = colors.orange,
					S=colors.orange,
					[''] = colors.orange,
					ic = colors.yellow,
					R = colors.violet,
					Rv = colors.violet,
					cv = colors.red,
					ce=colors.red,
					r = colors.cyan,
					rm = colors.cyan,
					['r?'] = colors.cyan,
					['!']  = colors.red,
					t = colors.red,
				}
				local mode = vim.fn.mode()
				-- vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color[mode])
				local alias = {
					n = "Normal",
					i = "Insert",
					c = "Command",
					V = "Visual",
					[""] = "Visual",
					v = "Visual",
					R = "Replace"
				}
				local current_Mode = alias[mode]

				if current_Mode == nil then
					return "  Terminal "
				else
					return "  " .. current_Mode .. " "
				end
			end,
			highlight = highlight(colors.red),
		}
	},
}

local right = {
	{
		SearchCount = {
			-- Source: https://github.com/glepnir/galaxyline.nvim/pull/205
			provider = function()
				local search_term = vim.fn.getreg('/')
				local search_count = vim.fn.searchcount({recompute = 1, maxcount = -1})
				if not search_count then
					return
				end
				local active = vim.v.hlsearch == 1 and search_count.total > 0
				if active then
					return '/' .. search_term .. ' [' .. search_count.current .. '/' .. search_count.total .. ']'
				end
			end,
			condition = condition.hide_in_width,
			separator = separator,
			highlight = highlight(colors.blue),
		}
	},
	{
		GitIcon = {
			provider = function()
				return " "
			end,
			condition = require("galaxyline.condition").check_git_workspace,
			highlight = { colors.grey, colors.statusline_bg },
			separator = separator,
			separator_highlight = highlight(colors.statusline_bg),
		}
	},
	{
		GitBranch = {
			provider = "GitBranch",
			condition = require("galaxyline.condition").check_git_workspace,
			highlight = highlight(colors.grey),
		}
	},
	{
		FileFormat = {
			provider = function()
				return " " .. vim.bo.fileformat:upper() .. " "
			end,
			separator = " ",
			condition = condition.hide_in_width,
			highlight = highlight(colors.blue),
		}
	},
	{
		FileEncode = {
			provider = 'FileEncode',
			condition = condition.hide_in_width,
			separator_highlight = { colors.lightbg },
			-- separator = " ",
			highlight = highlight(colors.blue),
		}
	},
	{
		lsp_status = {
			provider = function()
				local clients = vim.lsp.get_active_clients()
				if next(clients) ~= nil then
					return " " .. "  " .. "LSP "
				else
					return ""
				end
			end,
			highlight = highlight(colors.purple),
		}
	},
	{
		line_percentage = {
			provider = function()
				local current_line = vim.fn.line(".")
				local total_line = vim.fn.line("$")

				if current_line == 1 then
					return "  Top "
				elseif current_line == vim.fn.line("$") then
					return "  Bot "
				end
				local result, _ = math.modf((current_line / total_line) * 100)
				return "  " .. result .. "% "
			end,
			highlight = highlight(colors.green),
		}
	}
}

local add_to_line = function(section, items)
	local i = 0
	for k, r in pairs(items) do
		-- How to programmatically configure
		-- local item_key, item = next(r)
		-- local modded_item = {[item_key] = item}
		gls[section][i] = r
		i = i + 1
	end
end
add_to_line("left", left)
add_to_line("mid", mid)
add_to_line("right", right)
