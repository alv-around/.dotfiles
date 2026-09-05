local AMBIGUOUS_LINK = "1"

-- Match on the client name rather than diagnostic.source. marksman does set
-- source (to "Marksman", capitalised -- easy to get wrong), but the client
-- name is what the LSP config registers the server under.
local function is_marksman(ctx)
  local client = ctx and ctx.client_id and vim.lsp.get_client_by_id(ctx.client_id)
  return client ~= nil and client.name == "marksman"
end

-- LSP allows the code to be a string or a number; marksman sends a string,
-- but normalise so this doesn't quietly stop matching if that ever changes.
local function keep(diagnostic)
  return tostring(diagnostic.code) ~= AMBIGUOUS_LINK
end

-- Push diagnostics (textDocument/publishDiagnostics) -- what marksman sends.
local publish = vim.lsp.handlers["textDocument/publishDiagnostics"]
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, cfg)
  if result and result.diagnostics and is_marksman(ctx) then
    result.diagnostics = vim.tbl_filter(keep, result.diagnostics)
  end
  return publish(err, result, ctx, cfg)
end

-- Pull diagnostics (textDocument/diagnostic). marksman does not use these
-- today; covering both means this keeps working if it ever switches over.
local pull = vim.lsp.handlers["textDocument/diagnostic"]
if pull then
  vim.lsp.handlers["textDocument/diagnostic"] = function(err, result, ctx, cfg)
    if result and result.items and is_marksman(ctx) then
      result.items = vim.tbl_filter(keep, result.items)
    end
    return pull(err, result, ctx, cfg)
  end
end
