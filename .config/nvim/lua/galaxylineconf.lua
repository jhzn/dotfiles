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
local separator = " | "
local separator_highlight = { colors.blue, colors.lightbg }

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
			separator_highlight = { colors.blue, colors.lightbg }
		}
	},
	{
		FileName = {
			provider = { "FileName" },
			condition = condition.buffer_not_empty,
			highlight = { colors.white, colors.lightbg },
			separator = " ",
			separator_highlight = { colors.lightbg, colors.lightbg2 }
		}
	},
	{
		current_dir = {
			provider = function()
				local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
				return "  " .. dir_name .. " "
			end,
			highlight = { colors.grey, colors.lightbg2 },
			separator = " ",
			separator_highlight = { colors.lightbg2, colors.statusline_bg }
		}
	},
	{
		DiffAdd = {
			provider = "DiffAdd",
			condition = checkwidth,
			icon = "  ",
			highlight = { colors.white, colors.statusline_bg }
		}
	},
	{
		DiffModified = {
			provider = "DiffModified",
			condition = checkwidth,
			icon = "   ",
			highlight = { colors.grey, colors.statusline_bg }
		}
	},
	{
		DiffRemove = {
			provider = "DiffRemove",
			condition = checkwidth,
			icon = "  ",
			highlight = { colors.grey, colors.statusline_bg }
		}
	},
	{
		DiagnosticError = {
			provider = "DiagnosticError",
			icon = "  ",
			highlight = { colors.red, colors.statusline_bg }
		}
	},
	{
		DiagnosticWarn = {
			provider = "DiagnosticWarn",
			icon = "  ",
			highlight = { colors.yellow, colors.statusline_bg }
		}
	},
}


local mid = {
	{
		ViMode = {
			provider = function()
				local alias = {
					n = "Normal",
					i = "Insert",
					c = "Command",
					V = "Visual",
					[""] = "Visual",
					v = "Visual",
					R = "Replace"
				}
				local current_Mode = alias[vim.fn.mode()]

				if current_Mode == nil then
					return "  Terminal "
				else
					return "  " .. current_Mode .. " "
				end
			end,
			highlight = { colors.red, colors.lightbg }
		}
	},
	{
		GitIcon = {
			provider = function()
				return " "
			end,
			condition = require("galaxyline.condition").check_git_workspace,
			highlight = { colors.grey, colors.statusline_bg },
			separator = " ",
			separator_highlight = { colors.statusline_bg, colors.statusline_bg }
		}
	},
	{
		GitBranch = {
			provider = "GitBranch",
			condition = require("galaxyline.condition").check_git_workspace,
			highlight = { colors.grey, colors.statusline_bg }
		}
	},
	{
		AbsoluteFilePath = {
			provider = function()
				local filepath = vim.fn.fnamemodify(vim.fn.expand('%:p:h'), ':~:.')
				return plenary_path.new(filepath):shorten(5)
			end,
			separator = " | ",
			separator_highlight = { colors.blue, colors.lightbg },
			condition = require("galaxyline.condition").check_git_workspace,
			highlight = { colors.grey, colors.statusline_bg }
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
				local active = vim.v.hlsearch == 1 and search_count.total > 0
				if active then
					return '/' .. search_term .. ' [' .. search_count.current .. '/' .. search_count.total .. ']'
				end
			end,
			condition = condition.hide_in_width,
			separator = ' ',
			highlight = { colors.blue, colors.lightbg }
		}
	},
	{
		FileFormat = {
			provider = function()
				return " " .. vim.bo.fileformat:upper() .. " "
			end,
			condition = condition.hide_in_width,
			separator = ' ',
			highlight = { colors.blue, colors.lightbg }
		}
	},
	{
		FileEncode = {
			provider = 'FileEncode',
			condition = condition.hide_in_width,
			separator_highlight = { colors.lightbg },
			highlight = { colors.blue, colors.lightbg }
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
			highlight = { colors.purple, colors.lightbg }
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
			highlight = { colors.green, colors.lightbg }
		}
	}
}

local add_to_line = function(section, items)
	local i = 0
	for k, r in pairs(items) do
		gls[section][i] = r
		i = i + 1
	end
end
add_to_line("left", left)
add_to_line("mid", mid)
add_to_line("right", right)
