local gl = require("galaxyline")
local gls = gl.section
local condition = require("galaxyline.condition")

gl.short_line_list = {" "}

local colors = {
	white = "#abb2bf",
	darker_black = "#1b1f27",
	black = "#1e222a", --  nvim bg
	black2 = "#252931",
	one_bg = "#282c34", -- real bg of onedark
	one_bg2 = "#353b45",
	one_bg3 = "#30343c",
	grey = "#42464e",
	grey_fg = "#565c64",
	grey_fg2 = "#6f737b",
	light_grey = "#6f737b",
	red = "#d47d85",
	baby_pink = "#DE8C92",
	pink = "#ff75a0",
	line = "#2a2e36", -- for lines like vertsplit
	green = "#A3BE8C",
	vibrant_green = "#7eca9c",
	-- nord_blue = "#81A1C1",
	blue = "#61afef",
	yellow = "#e7c787",
	sun = "#EBCB8B",
	purple = "#b4bbc8",
	dark_purple = "#c882e7",
	teal = "#519ABA",
	orange = "#fca2aa",
	cyan = "#a3b8ef",
	statusline_bg = "#22262e",
	lightbg = "#2d3139",
	lightbg2 = "#262a32"
}

local checkwidth = function()
	local squeeze_width = vim.fn.winwidth(0) / 2
	if squeeze_width > 30 then
		return true
	end
	return false
end

local left = {
	{
		FirstElement = {
			provider = function()
				return "▋"
			end,
			highlight = {colors.blue, colors.blue}
		}
	},
	{
		statusIcon = {
			provider = function()
				return "  "
			end,
			highlight = {colors.statusline_bg, colors.blue},
			separator = "  ",
			separator_highlight = {colors.blue, colors.lightbg}
		}
	},
	{
		FileName = {
			provider = {"FileName"},
			condition = condition.buffer_not_empty,
			highlight = {colors.white, colors.lightbg},
			separator = " ",
			separator_highlight = {colors.lightbg, colors.lightbg2}
		}
	},
	{
		current_dir = {
			provider = function()
				local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
				return "  " .. dir_name .. " "
			end,
			highlight = {colors.grey_fg2, colors.lightbg2},
			separator = " ",
			separator_highlight = {colors.lightbg2, colors.statusline_bg}
		}
	},
	{
		DiffAdd = {
			provider = "DiffAdd",
			condition = checkwidth,
			icon = "  ",
			highlight = {colors.white, colors.statusline_bg}
		}
	},
	{
		DiffModified = {
			provider = "DiffModified",
			condition = checkwidth,
			icon = "   ",
			highlight = {colors.grey_fg2, colors.statusline_bg}
		}
	},
	{
		DiffRemove = {
			provider = "DiffRemove",
			condition = checkwidth,
			icon = "  ",
			highlight = {colors.grey_fg2, colors.statusline_bg}
		}
	},
	{
		DiagnosticError = {
			provider = "DiagnosticError",
			icon = "  ",
			highlight = {colors.red, colors.statusline_bg}
		}
	},
	{
		DiagnosticWarn = {
			provider = "DiagnosticWarn",
			icon = "  ",
			highlight = {colors.yellow, colors.statusline_bg}
		}
	},
	--{
		--DiagnosticInfo = {
			--provider = function()
				--return PrintDiagnostics()
				--end,
				--icon = "  ",
				--highlight = {colors.yellow, colors.statusline_bg}
				--}
				--}
}
--vim.cmd [[ autocmd CursorHold * lua PrintDiagnostics() ]]

local i = 0
for _, r in pairs(left) do
	gls.left[i] = r
	i = i + 1
end

local right = {
	{
		FileFormat = {
			provider = 'FileFormat',
			condition = condition.hide_in_width,
			-- separator = ' ',
			separator_highlight = {colors.statusline_bg, colors.statusline_bg},
			highlight = {colors.blue,colors.statusline_bg}
		}
	},
	{
		FileEncode = {
			provider = 'FileEncode',
			condition = condition.hide_in_width,
			separator = ' ',
			separator_highlight = {colors.statusline_bg, colors.statusline_bg},
			highlight = {colors.blue, colors.statusline_bg}
		}
	},
	{
		lsp_status = {
			provider = function()
				local clients = vim.lsp.get_active_clients()
				if next(clients) ~= nil then
					return " " .. "  " .. " LSP "
				else
					return ""
				end
			end,
			highlight = {colors.grey_fg2, colors.statusline_bg}
		}
	},
	{
		GitIcon = {
			provider = function()
				return " "
			end,
			condition = require("galaxyline.condition").check_git_workspace,
			highlight = {colors.grey_fg2, colors.statusline_bg},
			separator = " ",
			separator_highlight = {colors.statusline_bg, colors.statusline_bg}
		}
	},
	{
		GitBranch = {
			provider = "GitBranch",
			condition = require("galaxyline.condition").check_git_workspace,
			highlight = {colors.grey_fg2, colors.statusline_bg}
		}
	},
	{
		viMode_icon = {
			provider = function()
				return " "
			end,
			highlight = {colors.statusline_bg, colors.red},
			separator = " ",
			separator_highlight = {colors.red, colors.statusline_bg}
		}
	},
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
			highlight = {colors.red, colors.lightbg}
		}
	},
	{
		some_icon = {
			provider = function()
				return " "
			end,
			separator = "",
			separator_highlight = {colors.green, colors.lightbg},
			highlight = {colors.lightbg, colors.green}
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
			highlight = {colors.green, colors.lightbg}
		}
	}
}
i = 0
for _, r in pairs(right) do
	gls.right[i] = r
	i = i + 1

end
