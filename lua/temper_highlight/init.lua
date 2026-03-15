local M = {}

local templight = require("templight")

local ns = vim.api.nvim_create_namespace("temper_highlight")

-- Temper code token kinds -> treesitter highlight groups
local code_hl_map = {
  kw = "@keyword",
  ty = "@type",
  st = "@string",
  nm = "@number",
  cm = "@comment",
  op = "@operator",
  lt = "@boolean",
  id = "@variable",
  pn = "@punctuation",
  ch = "@character",
  dc = "@attribute",
  -- ws has no highlight
}

-- Markdown token kinds -> distinct highlight groups
-- Uses a different color palette so prose is visually distinct from code
local md_hl_map = {
  mh = "@markup.heading",
  mt = "@markup.raw",       -- prose text in a muted/distinct color
  me = "@markup.italic",
  mb = "@markup.strong",
  mc = "@markup.raw.block",
  ml = "@markup.link",
  mf = "@comment",          -- fence markers are dim
}

--- Parse a "kind:length,kind:length,..." encoded string and apply highlights.
---@param buf number Buffer handle
---@param line_idx number 0-based line number
---@param tokens string Encoded token string
---@param hl_map table Token kind -> highlight group mapping
---@param col_offset number Column offset (for indented code in .temper.md)
local function apply_tokens(buf, line_idx, tokens, hl_map, col_offset)
  if tokens == "" then return end
  local col = col_offset
  for kind, len_str in string.gmatch(tokens, "(%a+):(%d+)") do
    local len = tonumber(len_str)
    local hl = hl_map[kind]
    if hl then
      vim.api.nvim_buf_add_highlight(buf, ns, hl, line_idx, col, col + len)
    end
    col = col + len
  end
end

--- Highlight a .temper file (all lines are code).
---@param buf number
local function highlight_temper(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  for i, line in ipairs(lines) do
    local tokens = templight.tokenizeLine(line)
    apply_tokens(buf, i - 1, tokens, code_hl_map, 0)
  end
end

--- Highlight a .temper.md file.
--- Code blocks (4-space indented lines) get Temper highlighting.
--- Fenced ```temper blocks also get Temper highlighting.
--- All other lines get Markdown highlighting in a distinct scheme.
---@param buf number
local function highlight_temper_md(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local in_fence = false
  local fence_is_temper = false

  for i, line in ipairs(lines) do
    local line_idx = i - 1

    -- Check for fence open/close
    if string.match(line, "^```") then
      if not in_fence then
        in_fence = true
        -- Check if it's a temper code fence (```temper or ```temper-config or just ```)
        local lang = string.match(line, "^```(%S+)")
        fence_is_temper = (lang == "temper" or lang == nil)
        -- Highlight the fence line itself as markdown
        local md_tokens = templight.tokenizeMarkdownLine(line)
        apply_tokens(buf, line_idx, md_tokens, md_hl_map, 0)
      else
        in_fence = false
        fence_is_temper = false
        -- Closing fence
        local md_tokens = templight.tokenizeMarkdownLine(line)
        apply_tokens(buf, line_idx, md_tokens, md_hl_map, 0)
      end
    elseif in_fence and fence_is_temper then
      -- Inside a temper fence: tokenize as Temper code
      local tokens = templight.tokenizeLine(line)
      apply_tokens(buf, line_idx, tokens, code_hl_map, 0)
    elseif in_fence then
      -- Inside a non-temper fence (e.g. ```log): leave unhighlighted or dim
      vim.api.nvim_buf_add_highlight(buf, ns, "@comment", line_idx, 0, -1)
    elseif string.match(line, "^    ") then
      -- 4-space indented code block: tokenize the code portion
      -- The indent itself is whitespace, code starts at col 4
      local code = string.sub(line, 5)
      local tokens = templight.tokenizeLine(code)
      apply_tokens(buf, line_idx, tokens, code_hl_map, 4)
    else
      -- Markdown prose line
      local md_tokens = templight.tokenizeMarkdownLine(line)
      apply_tokens(buf, line_idx, md_tokens, md_hl_map, 0)
    end
  end
end

--- Main entry point: highlight the given buffer.
---@param buf number
function M.highlight_buffer(buf)
  -- Clear previous highlights
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  local name = vim.api.nvim_buf_get_name(buf)
  if string.match(name, "%.temper%.md$") then
    highlight_temper_md(buf)
  else
    highlight_temper(buf)
  end
end

return M
